#!/bin/bash

# This script is used to update the version of the package.
# It can be called with the following arguments:

file="pubspec.yaml"

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
  export VERSION=$(git tag --sort=-creatordate | head -1)
  export PREVIOUS_VERSION=$(git tag --sort=-creatordate | head -2 | awk '{split($0, tags, "\n")} END {print tags[1]}')
  export CHANGES=$(git log --pretty="- %s" $VERSION...$PREVIOUS_VERSION)
  changelog="# 🎁 Release notes (\`$VERSION\`)\n\n## Changes\n$CHANGES\n\n## Metadata\n\`\`\`\nThis version -------- $VERSION\nPrevious version ---- $PREVIOUS_VERSION\nTotal commits ------- $(echo "$CHANGES" | wc -l)\n\`\`\`\n"
  # prepend to CHANGELOG.md
  echo -e "$changelog\n$(cat CHANGELOG.md)" > CHANGELOG.md
  
  echo "Changelog updated successfully for version $VERSION! 🎉"

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
