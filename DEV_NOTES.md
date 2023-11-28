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

The following process is used to create documentatation and host it in the
[MandArt-Docs](https://github.com/denisecase/MandArt-Docs) repo.

1. Add or uncomment Package.swift in the root folder of MandArt repo. 
2. Move Documentation.docc from root to Sources/MandArt with the .swift files. 
3. Open Terminal, in the root MandArt repository folder.
4. In Terminal, run

```
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target MandArt --output-path ./docs \
    --disable-indexing \
    --transform-for-static-hosting  \
    --emit-digest \
    --target MandArt \
    --hosting-base-path 'MandArt-Docs'
```


After generating Docs

1. Copy MandArt/docs to MandArt-Docs/docs 
2. Commit and push MandArt-Docs to GitHub (using VS Code)

In MandArt:

1. Remove or comment out Package.swift.
2. Move Documentation.docc back to root.
3. Delete the /docs folder.