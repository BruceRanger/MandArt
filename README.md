# MandArt

> Mandelbrot set running in SwiftUI - create custom art

- Applied Physics Engineering
- [Bruce Johnson](https://github.com/bruceranger)

## Documentation 

- [Documentation](https://denisecase.github.io/MandArt-Docs/documentation/mandart/)
- [Source](https://github.com/denisecase/MandArt-Docs)

## For

- MacOS v 12+

## Developed On

- Xcode 14.1+


## Generate MandArt-Docs

To create documentatation for the MandArt-Docs repo.

1. Uncomment out Package.swift in the root folder. 
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


## After generating Docs

1. Copy MandArt/docs to MandArt-Docs/docs 
2. Commit and push MandArt-Docs to GitHub (using VS Code)

In MandArt:

1. Comment out Package.swift.
2. Move Documentation.docc back to root.
3. Delete the /docs folder.



## References

- [Install Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin)
- [swift-docc-plugin](https://github.com/apple/swift-docc-plugin)
- <https://rhonabwy.com/2022/01/28/hosting-your-swift-library-docs-on-github-pages/>
- [Generating Documentation for Hosting Online](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/generating-documentation-for-hosting-online/)
- [Publishing to Github Pages](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/publishing-to-github-pages/)
