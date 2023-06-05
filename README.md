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

## Usage

To use the version.sh script, open a terminal and navigate to the directory where the script is located. Then, run the script with one of the following arguments:

### build

The build argument increments the build number of the current version. To use this argument, run the following command:

```
./version.sh build
```

This will update the version number in the pubspec.yaml file and output the new version number.

### patch

The patch argument increments the patch number of the current version. To use this argument, run the following command:

```
./version.sh patch
```

This will update the version number in the pubspec.yaml file and output the new version number.

### minor

The minor argument increments the minor number of the current version and resets the patch number to 0. To use this argument, run the following command:

```
./version.sh minor
```

This will update the version number in the pubspec.yaml file and output the new version number.

### major

The major argument increments the major number of the current version and resets the minor and patch numbers to 0. To use this argument, run the following command:

```
./version.sh major
```

This will update the version number in the pubspec.yaml file and output the new version number.

### commit

The commit argument gets the commit message for version change. To use this argument, run the following command:

```
./version.sh commit
```

This will output the commit message for the version change.

### version

The version argument gets the current version. To use this argument, run the following command:

```
./version.sh version
```

This will output the current version.

### next-version

The next-version argument gets the next version. To use this argument, run the following command:

```
./version.sh version
```

This will output the next version.

### changelog

The changelog argument updates the changelog. To use this argument, run the following command:

```
./version.sh changelog
```

This will update the changelog and output a success message.

## Examples

Here are some examples of how to use the version.sh script:

### Example 1

To increment the build number of the current version, run the following command:

```
./version.sh build
```

This will output the new version number.

### Example 2

To get the commit message for version change, run the following command:

```
./version.sh commit
```

This will output the commit message for the version change.

### Example 3

To update the changelog, run the following command:

```
./version.sh changelog
```

This will update the changelog and output a success message.
