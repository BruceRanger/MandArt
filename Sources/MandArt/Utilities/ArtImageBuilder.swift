

import Foundation
import CoreGraphics

struct ArtImageBuilder {

  static func createCGImageFromArtPixels(_ artPixels: [[Double]], _ colors: [[Double]], _ picdef: PictureDefinition) -> CGImage? {
    let imageWidth = picdef.imageWidth
    let imageHeight = picdef.imageHeight
    let iterationsMax = picdef.iterationsMax

    // Create a context and set background color
    let context = CGContext(data: nil, width: imageWidth, height: imageHeight, bitsPerComponent: 8, bytesPerRow: imageWidth * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

    // Iterate over artPixels and apply colors
    for y in 0..<imageHeight {
      for x in 0..<imageWidth {
        let pixelValue = artPixels[x][y]

        if pixelValue >= iterationsMax { // black
          context?.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else {
          // Apply color mapping logic using colors array
          let h = pixelValue // assuming pixelValue represents h value
          let mappedColor = mapColor(h: h, colors: colors, picdef: picdef)

          context?.setFillColor(red: CGFloat(mappedColor[0]), green: CGFloat(mappedColor[1]), blue: CGFloat(mappedColor[2]), alpha: 1.0)
        }

        context?.fill(CGRect(x: x, y: y, width: 1, height: 1))
      }
    }

    // Convert the context into an image
    return context?.makeImage()
  }

  // Helper function to map color based on h value
  private static func mapColor(h: Double, colors: [[Double]], picdef: PictureDefinition) -> [Double] {
    let nBlocks = picdef.nBlocks
    let nColors = colors.count
    let spacingColorFar = picdef.spacingColorFar
    let spacingColorNear = picdef.spacingColorNear
    var yY = picdef.yY

    if yY == 1.0 { yY -= 1.0e-10 }

    var spacingColorMid = 0.0
    var fNBlocks = 0.0
    var color = [Double](repeating: 0.0, count: 3)
    var block0 = 0
    var block1 = 0

    fNBlocks = Double(nBlocks)

    spacingColorMid = (picdef.iterationsMax - picdef.dFIterMin - fNBlocks * spacingColorFar) / pow(fNBlocks, spacingColorNear)

    var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

    for i in 0 ... nBlocks {
      blockBound[i] = spacingColorFar * Double(i) + spacingColorMid * pow(Double(i), spacingColorNear)
    }

    var hValue = h - picdef.dFIterMin

    var block = 0

    while block < nBlocks {
      if hValue >= blockBound[block], hValue < blockBound[block + 1] {
        break
      }
      block += 1
    }

    let xX = (hValue - blockBound[block]) / (blockBound[block + 1] - blockBound[block])

    block0 = block
    if block0 >= nColors {
      block0 -= nColors
    }

    block1 = block0 + 1
    if block1 == nColors {
      block1 -= nColors
    }

    for c in 0..<3 {
      color[c] = colors[block0][c] + xX * (colors[block1][c] - colors[block0][c])
    }

    return color
  }

}
