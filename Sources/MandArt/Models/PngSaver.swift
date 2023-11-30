import SwiftUI

/// `PngSaver` is a class responsible for saving CGImage data as a PNG file with additional metadata.
@available(macOS 12.0, *)
class PngSaver {
  // PngCommenter instance used to add comments to the PNG file.
  private var pngCommenter: PngCommenter

  /// Initializes a new PngSaver instance with a given PngCommenter.
  /// - Parameter pngCommenter: PngCommenter instance to use for adding comments.
  init(pngCommenter: PngCommenter) {
    self.pngCommenter = pngCommenter
  }

  /// Adjusts the URL to ensure it has a valid file name, defaulting to "MyArt" if empty.
  /// - Parameter url: Original URL of the image file.
  /// - Returns: Adjusted URL with a valid file name.
  func adjustedURL(_ url: URL) -> URL {
    let fileName = url.deletingPathExtension().lastPathComponent
    if fileName.isEmpty || fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      let newFileName = "MyArt"
      let newURL = url.deletingLastPathComponent().appendingPathComponent(newFileName)
        .appendingPathExtension(url.pathExtension)
      return newURL
    }
    return url
  }

  /// Verifies that the PictureDefinition can be encoded before saving.
  /// - Parameter picdef: PictureDefinition instance to check.
  /// - Returns: Boolean indicating if encoding is successful.
  func beforeSaveImage(for picdef: PictureDefinition) -> Bool {
    do {
      let data = try JSONEncoder().encode(picdef)
      if data.isEmpty {
        print("Error encoding picdef.")
        return false
      }
      return true
    } catch {
      print("Error encoding picdef: \(error)")
      return false
    }
  }

  /// Saves the CGImage to a specified URL and updates the image metadata.
  /// - Parameters:
  ///   - cgImage: CGImage to save as PNG.
  ///   - url: URL to save the image to.
  func saveImage(_ cgImage: CGImage, to url: URL) {
    let adjustedURL = self.adjustedURL(url)
    let ciImage = CIImage(cgImage: cgImage)
    guard let pngData = generatePngData(from: ciImage) else { return }

    do {
      try pngData.write(to: adjustedURL, options: .atomic)
      print("Saved image to: \(url)")
      try updateMetadataForImage(at: url, with: pngData)
    } catch {
      print("Error saving image: \(error)")
    }
  }

  /// Generates PNG data from a CIImage.
  /// - Parameter ciImage: CIImage to convert to PNG data.
  /// - Returns: PNG data if successful, nil otherwise.
  private func generatePngData(from ciImage: CIImage) -> Data? {
    guard let colorSpace = ciImage.colorSpace else {
      print("Error: Failed to retrieve color space.")
      return nil
    }

    let context = CIContext(options: nil)
    guard let pngData = context.pngRepresentation(of: ciImage, format: .RGBA8, colorSpace: colorSpace) else {
      print("Error: Failed to generate PNG data.")
      return nil
    }

    return pngData
  }

  /// Updates the metadata for the image at the specified URL.
  /// - Parameters:
  ///   - url: URL of the image file.
  ///   - pngData: PNG data of the image.
  /// - Throws: An error if writing the image with updated metadata fails.
  private func updateMetadataForImage(at url: URL, with pngData: Data) throws {
    let comment = pngCommenter.getComment()
    let pngMetadata: [String: Any] = [
      kCGImagePropertyPNGDescription as String: comment,
    ]

    if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
       let imageType = CGImageSourceGetType(imageSource),
       let mutableData = CFDataCreateMutableCopy(nil, 0, pngData as CFData),
       let destination = CGImageDestinationCreateWithData(mutableData, imageType, 1, nil) {
      CGImageDestinationAddImageFromSource(destination, imageSource, 0, pngMetadata as CFDictionary)
      if CGImageDestinationFinalize(destination) {
        try (mutableData as Data).write(to: url, options: .atomic)
        print("Description added to the image: \(comment)")
      } else {
        print("Error adding metadata to the image")
      }
    }
  }
}
