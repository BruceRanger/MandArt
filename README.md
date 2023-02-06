# MandArt

> Mandelbrot set running in SwiftUI - create custom art

- Applied Physics Engineering
- [Bruce Johnson](https://github.com/bruceranger)

## Development

- Xcode 14.1

Starting April 2023, 
all iOS and iPadOS apps submitted to the App Store 
must be built with Xcode 14.1 and the iOS 16.1 SDK.

## For

- MacOS

## Build Documentation

Documentation is hosted at:

- [docs]()
- [repo](https://github.com/denisecase/MandArt-Docs)

Process Reference

- [Install Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin)
- [Publishing to GitHub Pages](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)

1. XCode menu: Product / Build Documentation. 
1. Right-click on Workspace Documentation for the package (MandArt) / export.
1. Creates .doccarchive file. 
1. Xcode / Settings / Locations tab / Command Line tools 14.2

In Terminal, open in the MandArt source folder run

```
swift package generate-documentation --allow-writing-to-directory ./docs \
    --target MandArt \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path https://denisecase.github.io/MandArt-Docs/ \
    --output-path ./docs 
```