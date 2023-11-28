import Foundation
import ImageIO
import UniformTypeIdentifiers

@available(macOS 12.0, *)
public class PngCommenter {
  let picdef: PictureDefinition
  let fullDomain: String = "com.bhj.mandart"

  init(picdef: PictureDefinition) {
    self.picdef = picdef
  }

  func getComment() -> String {
    let comment = """
    dFIterMin is \(picdef.dFIterMin)
    imageHeight is \(picdef.imageHeight)
    imageWidth is \(picdef.imageWidth)
    iterationsMax is \(picdef.iterationsMax)
    leftNumber is \(picdef.leftNumber)
    nBlocks is \(picdef.nBlocks)
    rSqLimit is \(picdef.rSqLimit)
    scale is \(picdef.scale)
    spacingColorFar is \(picdef.spacingColorFar)
    spacingColorNear is \(picdef.spacingColorNear)
    theta is \(picdef.theta)
    xCenter is \(picdef.xCenter)
    yCenter is \(picdef.yCenter)
    yY is \(picdef.yY)
    """

    return comment
  }

  func setPNGDescription(imageURL: URL, description: String) throws {
    // Get the image data
    guard let imageData = try? Data(contentsOf: imageURL) else {
      throw NSError(domain: fullDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to read image data"])
    }

    // Create a CGImageSource from the image data
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
      throw NSError(domain: fullDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image source"])
    }

    // Create a CGImageDestination to write the image with metadata
    guard let destination = CGImageDestinationCreateWithURL(
      imageURL as CFURL,
      UTType.png.identifier as CFString,
      1,
      nil
    ) else {
      throw NSError(
        domain: fullDomain,
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: "Failed to create image destination"]
      )
    }

    // Get the image properties dictionary
    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
      throw NSError(
        domain: fullDomain,
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: "Failed to get image properties"]
      )
    }

    // Create a mutable copy of the properties dictionary
    var mutableProperties = properties as [CFString: Any]

    // Add the PNG dictionary with the description attribute
    var pngProperties = [CFString: Any]()
    pngProperties[kCGImagePropertyPNGDescription] = description
    mutableProperties[kCGImagePropertyPNGDictionary] = pngProperties

    // Add the image to the destination with metadata
    CGImageDestinationAddImageFromSource(destination, imageSource, 0, mutableProperties as CFDictionary)

    // Finalize the destination to write the image with metadata to disk
    guard CGImageDestinationFinalize(destination) else {
      throw NSError(
        domain: fullDomain,
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: "Failed to write image with metadata to disk"]
      )
    }
  }

  func getPNGDescription(from imageURL: URL) -> String? {
    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
          let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
          let pngProperties = properties[kCGImagePropertyPNGDictionary] as? [String: Any]
    else {
      return nil
    }

    return pngProperties[kCGImagePropertyPNGDescription as String] as? String
  }
}
