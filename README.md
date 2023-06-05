# version.sh Script Documentation

The version.sh script is used to update the version of a package. It can be called with the following arguments:

- `build`: Increment the build number.
- `patch`: Increment the patch number.
- `minor`: Increment the minor number and reset the patch number to 0.
- `major`: Increment the major number and reset the minor and patch numbers to 0.
- `commit`: Get the commit message for version change.
- `version`: Get the current version.
- `next-version`: Get the next version.
- `changelog`: Update the changelog.

## Installation

To install the version.sh script, just copy the script to the root of your package. You can do this by running the following command:

```
curl -o version.sh https://raw.githubusercontent.com/version-sh/version.sh/main/version.sh
```

Then, make the script executable by running the following command:

```
chmod +x version.sh
```

Open the version.sh script in a text editor and update the following variables:

- `file`: The name of the file that contains the version number.

The file should have a version number in the following format:

```
version: 1.0.0+0
```

**Note:** The version number must be on a single line.
We recommend using the pubspec.yaml file for this. Also more file support will be added in the future.

That's it! You can now use the version.sh script to update the version number of your package.

## Usage

To use the version.sh script, open a terminal and navigate to the directory where the script is located. Then, run the script with one of the following arguments:

### build

The build argument increments the build number of the current version. To use this argument, run the following command:

```
./version.sh build

# Current version example: 1.0.0+0
# Output example: 1.0.0+1
```

This will update the version number in the pubspec.yaml file and output the new version number.

### patch

The patch argument increments the patch number of the current version. To use this argument, run the following command:

```
./version.sh patch

# Current version example: 1.0.0+0
# Output example: 1.0.1+0
```

This will update the version number in the pubspec.yaml file and output the new version number.

### minor

The minor argument increments the minor number of the current version and resets the patch number to 0. To use this argument, run the following command:

```
./version.sh minor

# Current version example: 1.0.0+0
# Output example: 1.1.0
```

This will update the version number in the pubspec.yaml file and output the new version number.

### major

The major argument increments the major number of the current version and resets the minor and patch numbers to 0. To use this argument, run the following command:

```
./version.sh major

# Current version example: 1.0.0+0
# Output example: 2.0.0
```

This will update the version number in the pubspec.yaml file and output the new version number.

### commit

The commit argument gets the commit message for version change. To use this argument, run the following command:

```
./version.sh commit

# Current version example: 1.0.0+1
# Output example: Bump version to 1.0.0 Build 1
```

This will output the commit message for the version change.

### version

The version argument gets the current version. To use this argument, run the following command:

```
./version.sh version

# Current version example: 1.0.0+1
# Output example: 1.0.0+1
```

This will output the current version.

### next-version

The next-version argument gets the next version. To use this argument, run the following command:

```
./version.sh next-version

# Current version example: 1.0.0+1
# Output example: 1.0.0+2
```

This will output the next version.

### changelog

The changelog argument updates the changelog. To use this argument, run the following command:

```
./version.sh changelog
```

Output example:

```
# 🎁 Release notes (`v1.0.0+182`)

## Changes
- Change: bump version to 1.0.0 Build 182
- Add changelog.md
- Fix pagination
- Change: refactor logic

## Metadata

This version -------- v1.0.0+182
Previous version ---- v1.0.0+181
Total commits -------        4

```
