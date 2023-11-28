import SwiftUI

@available(macOS 12.0, *)
class PngSaver {
  private var pngCommenter: PngCommenter

  init(pngCommenter: PngCommenter) {
    self.pngCommenter = pngCommenter
  }

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
