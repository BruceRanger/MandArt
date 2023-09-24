/**
 MandArtDocument is a reference file document that supports only reading and writing MandArt data files that generate MandArt images.

 Its snapshot is a PictureDefinition and it has a @Published picdef property that, when changed,
 triggers a reload of all views using the document. This document class also has a docName
 property for the name of the data document and a simple initializer that creates a new demo MandArt.

 For more information, see:
 https://www.hackingwithswift.com/quick-start/swiftui/
 how-to-create-a-document-based-app-using-filedocument-and-documentgroup
 */

import SwiftUI
import UniformTypeIdentifiers

 /**
  A utility class to work with files for saving and sharing your art.
 Includes logic for adding, deleting, and reordering colors.

 Note: Since MandArtDocument is a class,  derive from [ReferenceFileDocument](
 https://developer.apple.com/documentation/swiftui/referencefiledocument
 )
 rather than FileDocument for a struct.
*/
@available(macOS 12.0, *)
final class MandArtDocument: ReferenceFileDocument, ObservableObject {

  var docName: String = "unknown"

  // snapshot used to serialize and save current version
  // while active self remains editable by the user
  typealias Snapshot = PictureDefinition

  static var readableContentTypes: [UTType] { [.mandartDocType] }

  // our document has a @Published picdef property,
  // when picdef is changed,
  // all views using that document will be reloaded
  @Published var picdef: PictureDefinition
  var imageDescriptionManager = ImageDescriptionManager(picdef: PictureDefinition(hues: []))

  /**
   A simple initializer that creates a new demo picture
   */
  init() {
    self.docName = "unknown"  // Initialize this first
    let hues: [Hue] = [
      Hue(num: 1, r: 0.0, g: 255.0, b: 0.0),
      Hue(num: 2, r: 255.0, g: 255.0, b: 0.0),
      Hue(num: 3, r: 255.0, g: 0.0, b: 0.0),
      Hue(num: 4, r: 255.0, g: 0.0, b: 255.0),
      Hue(num: 5, r: 0.0, g: 0.0, b: 255.0),
      Hue(num: 6, r: 0.0, g: 255.0, b: 255.0),
    ]
    self.picdef = PictureDefinition(hues: hues)

    self.imageDescriptionManager = ImageDescriptionManager(picdef: self.picdef)

  }

  /**
   Initialize a document with our picdef property
   - Parameter configuration: config
   */
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else {
      throw CocoaError(.fileReadCorruptFile)
    }
    self.docName = configuration.file.filename!
    self.picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
    self.imageDescriptionManager = ImageDescriptionManager(picdef: self.picdef)

    print("Opening data file = ", self.docName)
  }

  /**
   Get the current window title (shows data file name).
   */
  func getCurrentWindowTitle() -> String {
    guard let mainWindow = NSApp.mainWindow else {
      return ""
    }
    return mainWindow.title
  }

  func getUserCGColorList() -> [CGColor] {
    return self.picdef.hues.map { hue in
      return CGColor(red: CGFloat(hue.r / 255.0), green: CGFloat(hue.g / 255.0), blue: CGFloat(hue.b / 255.0), alpha: 1.0)
    }
  }

  /**
   Save the active picture definittion data to a file.
   - Parameters:
   - snapshot: snapshot of the current state
   - configuration: write config
   - Returns: a fileWrapper
   */
  func fileWrapper(
    snapshot: PictureDefinition,
    configuration _: WriteConfiguration
  ) throws -> FileWrapper {
    let data = try JSONEncoder().encode(snapshot)
    let fileWrapper = FileWrapper(regularFileWithContents: data)
    return fileWrapper
  }

  // Save the MandArt data to a file.
  func saveMandArtDataFile() {
    // first, save the data file and wait for it to complete
    DispatchQueue.main.async {
      // Trigger a "File > Save" menu event to update the app's UI.
      NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: self)
    }
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

  func getDefaultImageFileName() -> String {
    let winTitle = self.getCurrentWindowTitle()
    let justname = winTitle.replacingOccurrences(of: ".mandart", with: "")
    let imageFileName = justname + ".png"
    return imageFileName
  }

  func initSavePanel(fn: String) -> NSSavePanel {
    let savePanel = NSSavePanel()
    savePanel.title = "Choose Directory for MandArt image"
    savePanel.nameFieldStringValue = fn
    savePanel.canCreateDirectories = true
    return savePanel
  }

  func saveMandArtImage() {
    beforeSaveImage()
    guard let cgImage = contextImageGlobal else {
      print("Error: No context image available.")
      return
    }
    let imageFileName: String = getDefaultImageFileName()
    let comment: String = imageDescriptionManager.generateImageComment()
    let savePanel: NSSavePanel = initSavePanel(fn: imageFileName)

    let ciImage = CIImage(cgImage: cgImage)

    // Set the description attribute in the PNG metadata
    let pngMetadata: [String: Any] = [
      kCGImagePropertyPNGDescription as String: comment
    ]

    savePanel.begin { result in
      if result == .OK, let url = savePanel.url {
        let context = CIContext(options: nil)

        // Get the CIImage PNG representation
        guard let pngData = context.pngRepresentation(of: ciImage, format: .RGBA8, colorSpace: ciImage.colorSpace!) else {
          print("Error: Failed to generate PNG data.")
          return
        }

        do {
          try pngData.write(to: url, options: .atomic)
          print("Saved image to: \(url)")
          // After saving, update image metadata with description
          if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
             let imageType = CGImageSourceGetType(imageSource),
             let mutableData = CFDataCreateMutableCopy(nil, 0, pngData as CFData),
             let destination = CGImageDestinationCreateWithData(mutableData, imageType, 1, nil) {

            CGImageDestinationAddImageFromSource(destination, imageSource, 0, pngMetadata as CFDictionary)
            if CGImageDestinationFinalize(destination) {
              try? (mutableData as Data).write(to: url, options: .atomic)
              print("Description added to the image: \(comment)")
            } else {
              print("Error adding metadata to the image")
            }
          }
        } catch let error {
          print("Error saving image: \(error)")
        }
      } // end if okay
    } // end save begin
  } // end save function

  /**
   Create a snapshot of the current state of the document for serialization
   while the live self remains editiable by the user
   - Parameter contentType: the standard type we use
   - Returns: picture definition
   */
  @available(macOS 12.0, *)
  func snapshot(contentType _: UTType) throws -> PictureDefinition {
    self.picdef // return the current state
  }

}
