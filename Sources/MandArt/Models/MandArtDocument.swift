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

  var pngCommenter = PngCommenter(picdef: PictureDefinition(hues: []))
  var pngSaver = PngSaver(pngCommenter: PngCommenter(picdef: PictureDefinition(hues: [])))

  // MARK: - Initializers

  /// Default initializer for a new demo picture
  init() {
    let hues = [
      Hue(num: 1, r: 0.0, g: 255.0, b: 0.0),
      Hue(num: 2, r: 255.0, g: 255.0, b: 0.0),
      Hue(num: 3, r: 255.0, g: 0.0, b: 0.0),
      Hue(num: 4, r: 255.0, g: 0.0, b: 255.0),
      Hue(num: 5, r: 0.0, g: 0.0, b: 255.0),
      Hue(num: 6, r: 0.0, g: 255.0, b: 255.0),
    ]
    self.picdef = PictureDefinition(hues: hues)
    self.pngCommenter = PngCommenter(picdef: self.picdef)
    self.pngSaver = PngSaver(pngCommenter: self.pngCommenter)
  }

  /// Initializer to read a document from disk
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else {
      throw CocoaError(.fileReadCorruptFile)
    }
    self.docName = configuration.file.filename ?? "unknown"
    self.picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
    self.pngCommenter = PngCommenter(picdef: self.picdef)
    self.pngSaver = PngSaver(pngCommenter: self.pngCommenter)
    print("Opening data file = ", self.docName)
  }

  // MARK: - Snapshot and Serialization

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

  // MARK: - File Handling

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

    //  var currImage = contextImageGlobal!
    let savePanel = NSSavePanel()
    savePanel.title = "Choose directory and name for image inputs file"
    savePanel.nameFieldStringValue = dataFileName
    savePanel.canCreateDirectories = true
    savePanel.allowedContentTypes = [UTType.mandartDocType]

    savePanel.begin { (result) in
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

  // MARK: - Helper Functions

  var currentWindowTitle: String {
    return NSApp.mainWindow?.title ?? ""
  }

  var dataFileName: String {
    return baseFileName + Constants.dotMandart
  }

  var imageFileName: String {
    return baseFileName + Constants.dotPng
  }

  private var baseFileName: String {
    let title = currentWindowTitle.isEmpty ? "MyArt" : currentWindowTitle

    // Strip off the .mandart extension if it exists
    if title.hasSuffix(Constants.dotMandart) {
      return title.replacingOccurrences(of: Constants.dotMandart, with: "")
    }
    return title
  }

  var userCGColorList: [CGColor] {
    return picdef.hues.map { hue in
      CGColor(red: CGFloat(hue.r / 255.0), green: CGFloat(hue.g / 255.0), blue: CGFloat(hue.b / 255.0), alpha: 1.0)
    }
  }

  func handleError(_ error: MandArtError) {
    print(error.localizedDescription)
    // Here you can also display an alert to the user or handle the error in other ways
    // For now, we will just log and exit the application
    NSApplication.shared.windows.forEach { $0.close() }
    NSApplication.shared.terminate(nil)
  }

  // MARK: - Constants

  private struct Constants {
    static let dotMandart = ".mandart"
    static let dotPng = ".png"
  }

}
