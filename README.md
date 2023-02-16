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

## XCode Documentation 

Available at: 

<MandArt/.build/plugins/Swift-DocC/outputs/MandArt.doccarchive>

## Plugin Documentation Generation - for MandArt-Docs

To create documentatation for the MandArt-Docs repo.

1. Uncomment out Package.swift in the root folder. 
2. Move Documentation.docc from root to Sources/MandArt with the .swift files. 
3. Open Terminal, in the root MandArt repository folder.
4. In Terminal, run

```
swift package --allow-writing-to-directory ./docss \
    generate-documentation --target MandArt --output-path ./docs \
    --disable-indexing \
    --transform-for-static-hosting  \
    --emit-digest \
    --target MandArt \
    --hosting-base-path 'MandArt-Docs'
```


## After generating Docs


1. Copy MandArt/docs to MandArt-Docs/docs 
2. Commit and push MandArt-Docs to GitHub (using VS Code)

In MandArt:

1. Comment out Package.swift.
2. Move Documentation.docc back to root.
3. Delete the /docs folder.


## View Documentation 

- [docs](https://denisecase.github.io/MandArt-Docs/documentation/mandart/)
- [repo](https://github.com/denisecase/MandArt-Docs)


## References

- [Install Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin)
- [swift-docc-plugin](https://github.com/apple/swift-docc-plugin)
- <https://rhonabwy.com/2022/01/28/hosting-your-swift-library-docs-on-github-pages/>
- [Generating Documentation for Hosting Online](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/generating-documentation-for-hosting-online/)
- [Publishing to Github Pages](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)
