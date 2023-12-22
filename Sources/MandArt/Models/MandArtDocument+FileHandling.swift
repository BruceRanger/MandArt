import Foundation
import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
extension MandArtDocument {
  // Save the image inputs to a file.
  func saveMandArtImageInputs() {
    var data: Data
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      data = try encoder.encode(picdef)
    } catch {
      handleError(MandArtError.encodingError)
      return
    }
    if data.isEmpty {
      handleError(MandArtError.emptyData)
      return
    }

    // trigger state change to force a current image
    picdef.imageHeight += 1
    picdef.imageHeight -= 1

    // var currImage = contextImageGlobal!
    let savePanel = NSSavePanel()
    savePanel.title = "Choose directory and name for image inputs file"
    savePanel.nameFieldStringValue = dataFileName
    savePanel.canCreateDirectories = true
    savePanel.allowedContentTypes = [UTType.mandartDocType]

    savePanel.begin { result in
      if result == .OK {
        do {
          try data.write(to: savePanel.url!)
        } catch {
          print("Error saving file: \(error.localizedDescription)")
        }
        print("Image inputs saved successfully to \(savePanel.url!)")

        // Update the window title with the saved file name (without its extension)
        if let fileName = savePanel.url?.lastPathComponent {
          let justName = fileName.replacingOccurrences(of: Constants.dotMandart, with: "")
          NSApp.mainWindow?.title = justName
        }
      } else {
        print("Error saving image inputs")
      }
    }
  }

  func saveMandArtDataFile() {
    // first, save the data file and wait for it to complete
    DispatchQueue.main.async {
      // Trigger a "File > Save" menu event to update the app's UI.
      NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: self)
    }
  }

  func initSavePanel(fn: String) -> NSSavePanel {
    let savePanel = NSSavePanel()
    savePanel.title = "Choose Directory for MandArt image"
    savePanel.nameFieldStringValue = fn
    savePanel.canCreateDirectories = true
    return savePanel
  }

  // Saving PNG with Description comment

  func getCurrentWindowTitle() -> String {
    guard let mainWindow = NSApp.mainWindow else {
      return ""
    }
    return mainWindow.title
  }

  func getDefaultImageFileName() -> String {
    let winTitle = self.getCurrentWindowTitle()
    let justname = winTitle.replacingOccurrences(of: ".mandart", with: "")
    let imageFileName = justname + ".png"
    return imageFileName
  }

  func getImageComment() -> String {
    let a = String(picdef.dFIterMin)
    let b = String(picdef.imageHeight)
    let c = String(picdef.imageWidth)
    let d = String(picdef.iterationsMax)
    let e = String(picdef.leftNumber)
    let f = String(picdef.nBlocks)
    let g = String(picdef.rSqLimit)
    let h = String(picdef.scale)
    let i = String(picdef.spacingColorFar)
    let j = String(picdef.spacingColorNear)
    let k = String(picdef.theta)
    let l = String(picdef.xCenter)
    let m = String(picdef.yCenter)
    let n = String(picdef.yY)

    let comment = "dFIterMin is \(a) \n" +
    "imageHeight is \(b) \n" +
    "imageWidth is \(c) \n" +
    "iterationsMax is \(d) \n" +
    "leftNumber is \(e) \n" +
    "nBlocks is \(f) \n" +
    "rSqLimit is \(g) \n" +
    "scale is \(h) \n" +
    "spacingColorFar is \(i) \n" +
    "spacingColorNear is \(j) \n" +
    "theta is \(k) \n" +
    "xCenter is \(l) \n" +
    "yCenter is \(m) \n" +
    "yY is \(n) \n" +
    " "

    return comment
  }

  func beforeSaveImage() {
    var data: Data
    do {
      data = try JSONEncoder().encode(self.picdef)
    } catch {
      print("Error encoding picdef.")
      print("Closing all windows and exiting with error code 98.")
      NSApplication.shared.windows.forEach { $0.close() }
      NSApplication.shared.terminate(nil)
      exit(98)
    }
    if data == Data() {
      print("Error encoding picdef.")
      print("Closing all windows and exiting with error code 99.")
      NSApplication.shared.windows.forEach { $0.close() }
      NSApplication.shared.terminate(nil)
      exit(99)
    }
    // trigger state change to force a current image
    self.picdef.imageHeight += 1
    self.picdef.imageHeight -= 1
  }

  // requires Cocoa
  // requires ImageIO
  func setPNGDescription(imageURL: URL, description: String) throws {
    // Get the image data
    guard let imageData = try? Data(contentsOf: imageURL) else {
      throw NSError(domain: "com.bhj.mandart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to read image data"])
    }

    // Create a CGImageSource from the image data
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
      throw NSError(domain: "com.bhj.mandart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image source"])
    }

    // Create a CGImageDestination to write the image with metadata
    guard let destination = CGImageDestinationCreateWithURL(imageURL as CFURL, kUTTypePNG, 1, nil) else {
      throw NSError(domain: "com.bhj.mandart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image destination"])
    }

    // Get the image properties dictionary
    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
      throw NSError(domain: "com.bhj.mandart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get image properties"])
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
      throw NSError(domain: "com.bhj.mandart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to write image with metadata to disk"])
    }
  }

  func saveMandArtImage() {
    beforeSaveImage()
    guard let cgImage = contextImageGlobal else {
      print("Error: No context image available.")
      return
    }
    let imageFileName: String = getDefaultImageFileName()
    let comment: String = getImageComment()
    let savePanel: NSSavePanel = initSavePanel(fn: imageFileName)

    // Set the description attribute in the PNG metadata
    let pngMetadata: [String: Any] = [
      kCGImagePropertyPNGDescription as String: comment
    ]

    savePanel.begin { result in
      if result == .OK, let url = savePanel.url {
        let imageData = cgImage.pngData()!
        let ciImage = CIImage(data: imageData, options: [.properties: pngMetadata])
        let context = CIContext(options: nil)

        guard let pngData = context.pngRepresentation(of: ciImage!, format: .RGBA8, colorSpace: ciImage!.colorSpace!) else {
          print("Error: Failed to generate PNG data.")
          return
        }

        do {
          try pngData.write(to: url, options: .atomic)
          print("Saved image to: \(url)")
          print("Description: \(comment)")
          // Needed to actually write the description
          let imageURL = url
          let description = comment
          try self.setPNGDescription(imageURL: imageURL, description: description)
        } catch let error {
          print("Error saving image: \(error)")
        }
      }
    }
  }

}
