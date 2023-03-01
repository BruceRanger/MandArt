# MandArt

[![macos-Monterey](https://img.shields.io/badge/macos-monterey-brightgreen.svg)](https://www.apple.com/macos/monterey)
[![macos-Ventura](https://img.shields.io/badge/macos-ventura-brightgreen.svg)](https://www.apple.com/macos/ventura)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[![swift-version](https://img.shields.io/badge/swift-5.7-brightgreen.svg)](https://github.com/apple/swift)
[![swiftui-version](https://img.shields.io/badge/swiftui-3-brightgreen)](https://developer.apple.com/documentation/swiftui)
[![xcode-version](https://img.shields.io/badge/xcode-14-brightgreen)](https://developer.apple.com/xcode/)


SwiftUI macOS app to create custom art using the Mandelbrot set.

- Applied Physics Engineering
- [Bruce Johnson](https://github.com/bruceranger)

## Learn More

- [Documentation](https://denisecase.github.io/MandArt-Docs/documentation/mandart/)

## Dev Notes: Formatting and Linting

```
swiftlint --fix --config .swiftlint.yml Sources/MandArt

swiftformat Sources/MandArt --swiftversion 5 --config .swiftformat

swiftlint lint --config .swiftlint.yml Sources/MandArt/Hue.swift
swiftlint lint --config .swiftlint.yml Sources/MandArt/PictureDefinition.swift
swiftlint lint --config .swiftlint.yml Sources/MandArt/MandArtDocument.swift
swiftlint lint --config .swiftlint.yml Sources/MandArt/MandArtApp.swift
swiftlint lint --config .swiftlint.yml Sources/MandArt/MandMath.swift
swiftlint lint --config .swiftlint.yml Sources/MandArt/ContentView.swift


```

## Dev Notes: How to Create Documentation

The following process is used to create documentatation and host it in the
[MandArt-Docs](https://github.com/denisecase/MandArt-Docs) repo.

1. Add or uncomment Package.swift in the root folder of MandArt repo. 
2. Move Documentation.docc from root to Sources/MandArt with the .swift files. 
3. Open Terminal, in the root MandArt repository folder.
4. In Terminal, run

```
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target MandArt \ --output-path ./docs \
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

