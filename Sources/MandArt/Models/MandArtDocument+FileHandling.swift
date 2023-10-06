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

  func saveMandArtImage() {
    print("calling saveMandArtImage")

    guard pngSaver.beforeSaveImage(for: picdef) else {
      print("Error preparing image for saving.")
      return
    }

    guard let cgImage = contextImageGlobal else {
      print("Error: No context image available.")
      return
    }

    let savePanel: NSSavePanel = initSavePanel(fn: imageFileName)

    savePanel.begin { [weak self] result in
      if result == .OK, let url = savePanel.url {
        self?.pngSaver.saveImage(cgImage, to: url)
      }
    }
  }
}
