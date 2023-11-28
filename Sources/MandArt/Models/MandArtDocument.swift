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
    picdef = PictureDefinition(hues: hues)
    pngCommenter = PngCommenter(picdef: picdef)
    pngSaver = PngSaver(pngCommenter: pngCommenter)
  }

  /// Initializer to read a document from disk
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else {
      throw CocoaError(.fileReadCorruptFile)
    }
    docName = configuration.file.filename ?? "unknown"
    picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
    pngCommenter = PngCommenter(picdef: picdef)
    pngSaver = PngSaver(pngCommenter: pngCommenter)
    print("Opening data file = ", docName)
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
    picdef // return the current state
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
}
