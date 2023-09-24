import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

/** Extend CGImage to add pngData()
 */
@available(macOS, introduced: 10.13)
extension CGImage {
  func pngData() -> Data? {
    let mutableData = CFDataCreateMutable(nil, 0)!
    let dest = CGImageDestinationCreateWithData(mutableData, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(dest, self, nil)
    if CGImageDestinationFinalize(dest) {
      return mutableData as Data
    }
    return nil
  }
}
