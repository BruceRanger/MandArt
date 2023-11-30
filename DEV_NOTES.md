# Developer Notes

## Keeping Tools Updated

All at once with brew upgrade, or provide just the name or names of those you want to upgrade.

```shell
brew update
brew upgrade
brew upgrade periphery powershell swiftformat-for-xcode
```

## Formatting and Linting

```
swiftformat Sources/MandArt --config .swiftformat
swiftlint --fix --config .swiftlint.yml Sources/MandArt
```

## Periphery

First, build, then run:

```
xcodebuild -scheme MandArt -destination 'platform=macOS' -derivedDataPath 'DerivedData' clean build

periphery scan --skip-build --index-store-path 'DerivedData/MandArt/Index.noindex/DataStore/'
```

## Create Documentation

To update the hosted documents, follow the process described in the
[MandArt-Docs](https://github.com/denisecase/MandArt-Docs) repo.
