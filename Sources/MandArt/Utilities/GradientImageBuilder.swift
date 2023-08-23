
import Foundation
import CoreGraphics

struct GradientImageBuilder {

  internal static func createCGImageFromPixels(_ pixels: [[UInt8]], _ width: Int, _ height: Int) -> CGImage? {
    let bitsPerComponent = 8 // for UInt8
    let componentsPerPixel = 4 // RGBA = 4 components
    let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // = 4
    let bytesPerRow: Int = width * bytesPerPixel
    let rasterBufferSize: Int = width * height * bytesPerPixel

    // Allocate data for raster buffer. Using UInt8 to address individual RGBA components easily.
    let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

    // Create CGBitmapContext for drawing and converting into an image for display
    let context = CGContext(
      data: rasterBufferPtr,
      width: width,
      height: height,
      bitsPerComponent: bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: CGColorSpace(name: CGColorSpace.sRGB)!,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!

    // Fill the context with a white background
    context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    context.fill(CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))

    // Draw the pixels
    for v in 0 ..< height {
      for u in 0 ..< width {
        let pixel = pixels[v][u]
        let pixelAddress = rasterBufferPtr + (v * bytesPerRow) + (u * bytesPerPixel)
        pixelAddress[0] = pixel // R
        pixelAddress[1] = pixel // G
        pixelAddress[2] = pixel // B
        pixelAddress[3] = UInt8(255) // Alpha
      }
    }

    // Convert the context into an image
    guard let gradientImage = context.makeImage() else {
      return nil
    }

    // Deallocate the raster buffer
    rasterBufferPtr.deallocate()

    return gradientImage
  }
}

