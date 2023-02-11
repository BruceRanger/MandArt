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

## XCode Documentation Generation

1. XCode menu: Product / Build Documentation. 
1. Right-click on Workspace Documentation for the package (MandArt) / export.
1. Creates .doccarchive file. 
1. Xcode / Settings / Locations tab / Command Line tools 14.2

Available at: 

<MandArt/.build/plugins/Swift-DocC/outputs/MandArt.doccarchive>

## Plugin Documentation Generation

Documentation will be hosted at:

- [docs]()
- [repo](https://github.com/denisecase/MandArt-Docs)

In Terminal, open in the root repository folder, run

```

swift package --allow-writing-to-directory ./docs \
    generate-documentation --target MandArt --output-path ./docs \
    --disable-indexing \
    --transform-for-static-hosting  \
    --emit-digest \
    --target MandArt \
    --hosting-base-path 'MandArt'



```

Preview:

```
swift package --disable-sandbox preview-documentation --target MandArt
```

========================================
Starting Local Preview Server
	 Address: http://localhost:8000/documentation/mandart
========================================



References:

- [Install Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin)
- [swift-docc-plugin](https://github.com/apple/swift-docc-plugin)
- <https://rhonabwy.com/2022/01/28/hosting-your-swift-library-docs-on-github-pages/>
- [Generating Documentation for Hosting Online](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/generating-documentation-for-hosting-online/)
- [Publishing to Github Pages](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)
