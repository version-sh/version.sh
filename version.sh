#!/bin/bash

# This script is used to update the version of the package.

# Define the version file path
file="pubspec.yaml"

# Define the list of change types for the commit message grouping when creating
# the changelog. All the commit messages that start with one of these change
# types will be grouped under that change type in the changelog.
# The rest of the commit messages will be grouped under the "Other" section.
declare -a CHANGE_TYPES=("Add" "Change" "Fix")

# Function to extract version number from version file
get_version() {
  local version_line=$(grep -m1 "^version:" $file)
  local version=$(echo $version_line | cut -d' ' -f2)
  echo $version
}

# Function to get the commit message for version change
get_version_commit_message() {
  local version=$1
  local version_number=$(echo $version | cut -d'+' -f1)
  local build=$(echo $version | cut -d'+' -f2)
  echo "Change: bump version to $version_number Build $build"
}

# Function to update the version based on semver
update_version() {
  local current_version=$1
  local version_type=$2

  # Splitting version into major, minor, patch, and build
  local major=$(echo $current_version | cut -d'.' -f1)
  local minor=$(echo $current_version | cut -d'.' -f2)
  local patch=$(echo $current_version | cut -d'.' -f3 | cut -d'+' -f1)
  local build=$(echo $current_version | cut -d'+' -f2)

  # Incrementing version based on the specified type
  case $version_type in
    "build")
      build=$((build + 1))
      ;;
    "patch")
      patch=$((patch + 1))
      ;;
    "minor")
      minor=$((minor + 1))
      patch=0
      ;;
    "major")
      major=$((major + 1))
      minor=0
      patch=0
      ;;
    *)
      echo "Invalid version type. Usage: ./version.sh [build|patch|minor|major]"
      exit 1
  esac

  local new_version="$major.$minor.$patch+$build"
  echo $new_version
}

# Check if the script was called with the "commit" option
if [ "$1" == "commit" ]; then
  # Read the version from version file
  current_version=$(get_version)
  build=$(echo $current_version | cut -d'+' -f2)

  # Get the commit message for version change
  commit_message=$(get_version_commit_message $current_version $build)
  echo "$commit_message"

  exit 0
fi

# Check if the script was called with the "version" option
if [ "$1" == "version" ]; then
  # Read the version from version file
  current_version=$(get_version)
  echo "$current_version"

  exit 0
fi

# Check if the script was called with the "next-version" option
if [ "$1" == "next-version" ]; then
  # Read the version from version file
  current_version=$(get_version)
  build=$(echo $current_version | cut -d'+' -f2)

  # Get the next version
  next_version=$(update_version $current_version "build")
  echo "$next_version"

  exit 0
fi

# Check if the script was called with the "changelog" option
if [ "$1" == "changelog" ]; then

  # Parse command line arguments
  for arg in "$@"; do
    case $arg in
      --name=*)
        export VERSION_NAME="${arg#*=}"
        shift
        ;;
      --to=*)
        export VERSION_TO="${arg#*=}"
        shift
        ;;
      --from=*)
        export VERSION_FROM="${arg#*=}"
        shift
        ;;
      changelog)
        shift
        ;;
      --silent)
        export SILENT=true
        shift
        ;;
      --force)
        export FORCE=true
        shift
        ;;
      --help)
        echo "Usage: ./version.sh changelog [--name=<version_name>] [--to=<version_to>] [--from=<version_from>] [--silent] [--force]"
        exit 0
        ;;
      *)
        echo "Invalid argument: $arg"
        echo "Usage: ./version.sh changelog [--name=<version_name>] [--to=<version_to>] [--from=<version_from>] [--silent] [--force]"
        exit 1
        ;;
    esac
  done

  # Set default values if arguments are not defined
  if [ -z "$VERSION_NAME" ]; then
    export VERSION_NAME=$(git tag --sort=-creatordate | head -1)
  fi

  if [ -z "$VERSION_TO" ]; then
    export VERSION_TO=$(git tag --sort=-creatordate | head -1)
  fi

  if [ -z "$VERSION_FROM" ]; then
    if [ "$VERSION_TO" == "HEAD" ]; then
      export VERSION_FROM=$(git tag --sort=-creatordate | head -1)
    else
      export VERSION_FROM=$(git tag --sort=-creatordate | head -2 | awk '{split($0, tags, "\n")} END {print tags[1]}')
    fi
    # export VERSION_FROM=$(git tag --sort=-creatordate | head -2 | awk '{split($0, tags, "\n")} END {print tags[1]}')
  fi

  # Get the list of changes
  echo "Getting changes from $VERSION_FROM to $VERSION_TO..."
  echo ""
  export CHANGES=$(git log --pretty="- %s" $VERSION_TO...$VERSION_FROM)

  # Get the release date
  export DATE=$(date +%Y-%m-%d)

  # Define the release notes title
  export TITLE="# 🎁 Release notes (\`$VERSION_NAME\` - $DATE)"

  # echo "Checking for release notes for version $VERSION_NAME ($DATE)..."

  # Check if release notes already exist
  if cat CHANGELOG.md | grep "$TITLE" > /dev/null; then
    if [ "$FORCE" == "true" ]; then
      echo "Release notes already exist for version $VERSION_NAME ($DATE). Forcing update..."
    else
      echo "Release notes already exist for version $VERSION_NAME ($DATE)!"
      exit 1
    fi
  fi

  # Initialize the changelog variable
  changelog=""

  # Group changes by type
  for type in "${CHANGE_TYPES[@]}"; do
    changes=$(echo "$CHANGES" | grep -i -E "^- $type")
    if [ -n "$changes" ]; then
      changelog+="### $type\n$changes\n\n"
    fi
  done

  # Group remaining changes into "Others"
  others=$(echo "$CHANGES" | grep -ivE "^- ($(IFS='|'; echo "${CHANGE_TYPES[*]}"))")
  if [ -n "$others" ]; then
    changelog+="### Others\n$others\n\n"
  fi

  # Add metadata
  changelog="$TITLE\n\n$changelog## Metadata\n\`\`\`\nThis version -------- $VERSION_NAME\nPrevious version ---- $VERSION_FROM\nTotal commits ------- $(echo "$CHANGES" | wc -l)\n\`\`\`\n"

  if [ -z "$SILENT" ] && [ -z "$FORCE" ]; then
    echo "Release notes for version $VERSION_NAME ($DATE):"
    echo ""
    echo -e "$changelog"
    echo ""
    echo "Does this look good? (y/n)" && read answer

    if [ "$answer" != "${answer#[Yy]}" ]; then
      echo "Updating CHANGELOG.md..."
    else
      echo "Exiting..."
      exit 0
    fi
  fi

  # Prepend to CHANGELOG.md
  echo -e "$changelog\n$(cat CHANGELOG.md)" > CHANGELOG.md

  echo "Changelog updated successfully for version $VERSION_NAME! 🎉"

  exit 0
fi

# Read the version from version file
current_version=$(get_version)
echo "Current version: $current_version"

# Check the argument and update the version accordingly
case $1 in
  "build" | "patch" | "minor" | "major")
    new_version=$(update_version $current_version $1)
    echo "Updating version to: $new_version"

    # Get the commit message for version change
    commit_message=$(get_version_commit_message $new_version $((build + 1)))
    echo "Commit message: $commit_message"

    # Check for dry-run option
    if [ "$2" == "--dry-run" ]; then
      echo "Dry run. Exiting..."
      exit 0
    fi

    # Replace the version line in version file
    awk -v new_version="$new_version" '/^version:/ { print "version: " new_version; next }1' $file > $file.tmp
    mv $file.tmp $file

    echo "Version updated successfully!"
    ;;
  *)
    echo "Invalid argument. Usage: ./version.sh [build|patch|minor|major]"
    exit 1
esac


