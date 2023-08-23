//
//  ArtGenerator.swift
//  MandArt
//
//


import Foundation
import CoreGraphics

struct ArtCalculator {

  static func generateArtImage(
    gradientImage: CGImage,
    fIterGlobal: inout [[Double]],
    fIterMin: inout Double,
    imageHeight: Int,
    imageWidth: Int,
    picdef: PictureDefinition
  ) -> CGImage? {
    let nBlocks = picdef.nBlocks
    let nColors = picdef.hues.count
    let spacingColorFar = picdef.spacingColorFar
    let spacingColorNear = picdef.spacingColorNear
    var yY = picdef.yY

    if yY == 1.0 { yY = yY - 1.0e-10 }

    var spacingColorMid = 0.0
    var fNBlocks = 0.0
    var color = 0.0
    var block0 = 0
    var block1 = 0

    fNBlocks = Double(nBlocks)

    spacingColorMid = (picdef.iterationsMax - fIterMin - fNBlocks * spacingColorFar) / pow(fNBlocks, spacingColorNear)

    var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

    for i in 0 ... nBlocks {
      blockBound[i] = spacingColorFar * Double(i) + spacingColorMid * pow(Double(i), spacingColorNear)
    }

    var h = 0.0
    var xX = 0.0

    var rasterBuffer = [UInt8](repeating: 0, count: imageWidth * imageHeight * 4)

    for v in 0 ... (imageHeight - 1) {
      let pixelVerticalOffset = (imageHeight - v - 1) * imageWidth * 4

      for u in 0 ... (imageWidth - 1) {
        let pixelHorizontalOffset = u * 4
        let pixelOffset = pixelVerticalOffset + pixelHorizontalOffset

        var pixelAddress = pixelOffset

        if fIterGlobal[u][v] >= picdef.iterationsMax { // black
          rasterBuffer[pixelAddress] = UInt8(0) // red
          pixelAddress += 1
          rasterBuffer[pixelAddress] = UInt8(0) // green
          pixelAddress += 1
          rasterBuffer[pixelAddress] = UInt8(0) // blue
          pixelAddress += 1
          rasterBuffer[pixelAddress] = UInt8(255) // alpha
        } else {
          h = fIterGlobal[u][v] - fIterMin

          for block in 0 ... nBlocks {
            block0 = block

            if h >= blockBound[block], h < blockBound[block + 1] {
              if (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block]) <= yY {
                h = blockBound[block]
              } else {
                h = blockBound[block] +
                ((h - blockBound[block]) - yY * (blockBound[block + 1] - blockBound[block])) /
                (1 - yY)
              }

              xX = (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block])

              while block0 > nColors - 1 {
                block0 = block0 - nColors
              }

              block1 = block0 + 1

              if block1 == nColors {
                block1 = block1 - nColors
              }

              color = picdef.hues[block0].r + xX * (picdef.hues[block1].r - picdef.hues[block0].r)
              rasterBuffer[pixelAddress] = UInt8(color) // R
              pixelAddress += 1

              color = picdef.hues[block0].g + xX * (picdef.hues[block1].g - picdef.hues[block0].g)
              rasterBuffer[pixelAddress] = UInt8(color) // G
              pixelAddress += 1

              color = picdef.hues[block0].b + xX * (picdef.hues[block1].b - picdef.hues[block0].b)
              rasterBuffer[pixelAddress] = UInt8(color) // B
              pixelAddress += 1

              rasterBuffer[pixelAddress] = UInt8(255) // alpha
            }
          }
        }
      }
    }

    let bytesPerRow = imageWidth * 4
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let context = CGContext(
      data: &rasterBuffer,
      width: imageWidth,
      height: imageHeight,
      bitsPerComponent: 8,
      bytesPerRow: bytesPerRow,
      space: colorSpace,
      bitmapInfo: bitmapInfo.rawValue
    )

    guard let artImage = context?.makeImage() else {
      return nil
    }

    return artImage
  }
}
