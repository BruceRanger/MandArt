import CoreGraphics
import Foundation

/// A utility enum for creating gradient images.
enum GradientImage {
  /// Holds input parameters required for creating a gradient image.
  struct GradientImageInputs {
    let imageWidth: Int
    let imageHeight: Int
    let leftColorRGBArray: [Double]
    let rightColorRGBArray: [Double]
    let gradientThreshold: Double
  }

  /// Creates a CGContext for image rendering.
  /// - Parameters:
  ///   - width: The width of the context.
  ///   - height: The height of the context.
  ///   - bitsPerComponent: The number of bits used for each color component of a pixel.
  ///   - componentsPerPixel: The number of components (including alpha) for each pixel.
  /// - Returns: An optional CGContext if successful.
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

  /// Creates a CGImage representing a gradient using the provided parameters.
  /// - Parameter params: `GradientImageInputs` struct containing parameters for the gradient.
  /// - Returns: An optional CGImage representing the gradient.
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

    let gradientGridInputs = GradientGrid.GradientGridInputs(
      imageWidth: params.imageWidth,
      imageHeight: params.imageHeight,
      colorLeft: params.leftColorRGBArray,
      colorRight: params.rightColorRGBArray,
      gradientThreshold: params.gradientThreshold,
      bytesPerPixel: BYTES_PER_PIXEL,
      rasterBufferPtr: context.data!.assumingMemoryBound(to: UInt8.self)
    )

    GradientGrid.calculateGradientGrid(using: gradientGridInputs)

    guard let gradientImage = context.makeImage() else {
      return nil
    }
    context.data?.deallocate()
    return gradientImage
  }
}
