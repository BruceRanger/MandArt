import Foundation
import CoreGraphics

struct GradientImage {

  struct GradientImageInputs {
    let imageWidth: Int
    let imageHeight: Int
    let leftColorRGBArray: [Double]
    let rightColorRGBArray: [Double]
    let gradientThreshold: Double
  }


  static func createCGContext(
    width: Int,
    height: Int,
    bitsPerComponent: Int,
    componentsPerPixel: Int
  ) -> CGContext? {
    let bytesPerRow = width * (bitsPerComponent * componentsPerPixel) / 8
    let rasterBufferSize = width * height * (bitsPerComponent * componentsPerPixel) / 8
    let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

    let context = CGContext(
      data: rasterBufferPtr,
      width: width,
      height: height,
      bitsPerComponent: bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: CGColorSpace(name: CGColorSpace.sRGB)!,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )

    return context
  }


  static func createCGImage(using params: GradientImageInputs) -> CGImage? {

    let BITS_PER_COMPONENT = 8
    let COMPONENTS_PER_PIXEL = 4
    let BYTES_PER_PIXEL = (BITS_PER_COMPONENT * COMPONENTS_PER_PIXEL) / 8

    guard let context = createCGContext(
      width: params.imageWidth,
      height: params.imageHeight,
      bitsPerComponent: BITS_PER_COMPONENT,
      componentsPerPixel: COMPONENTS_PER_PIXEL
    ) else {
      return nil
    }

    let gradientParameters = GradientGrid.GradientGridInputs(
      imageWidth: params.imageWidth,
      imageHeight: params.imageHeight,
      colorLeft: params.leftColorRGBArray,
      colorRight: params.rightColorRGBArray,
      gradientThreshold: params.gradientThreshold,
      bytesPerPixel: BYTES_PER_PIXEL,
      rasterBufferPtr: context.data!.assumingMemoryBound(to: UInt8.self)
    )

    GradientGrid.calculate(using: gradientParameters)

    // Draw the pixels
    for v in 0 ..< params.imageHeight {
      for u in 0 ..< params.imageWidth {
        let pixelValue = gradientParameters.rasterBufferPtr[v * context.bytesPerRow + u * BYTES_PER_PIXEL]
        let t = Double(pixelValue) / 255.0

        // Interpolate between leftColor and rightColor based on pixelValue
        let pixelColor = [
          UInt8((1 - t) * params.leftColorRGBArray[0] + t * params.rightColorRGBArray[0]), // R
          UInt8((1 - t) * params.leftColorRGBArray[1] + t * params.rightColorRGBArray[1]), // G
          UInt8((1 - t) * params.leftColorRGBArray[2] + t * params.rightColorRGBArray[2])  // B
        ]

        let pixelAddress = context.data!.assumingMemoryBound(to: UInt8.self) + (v * context.bytesPerRow) + (u * BYTES_PER_PIXEL)
        pixelAddress[0] = pixelColor[0] // R
        pixelAddress[1] = pixelColor[1] // G
        pixelAddress[2] = pixelColor[2] // B
        pixelAddress[3] = UInt8(255)    // Alpha
      }
    }

    guard let gradientImage = context.makeImage() else {
      return nil
    }
    context.data?.deallocate()
    return gradientImage
  }
  
}

