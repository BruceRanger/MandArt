/**
 A document for creating and editing MandArt pictures.

 MandArtDocument is a reference file document that supports only reading and writing MandArt data files.
 Its snapshot is a PictureDefinition and it has a @Published picdef property that, when changed,
 triggers a reload of all views using the document. This document class also has a docName
 property for the name of the data document and a simple initializer that creates a new demo MandArt.

 For more information, see:
 https://www.hackingwithswift.com/quick-start/swiftui/
 how-to-create-a-document-based-app-using-filedocument-and-documentgroup

 Note: This class is only available on macOS 12.0 and later.
 */
import AppKit
import CoreGraphics
import ImageIO
import SwiftUI
import UniformTypeIdentifiers

 /**
  A utility class to work with files for saving and sharing your art.
 Includes logic for adding, deleting, and reordering colors.

 Note: Since MandArtDocument is a class, we derive from
 [ReferenceFileDocument](
 https://developer.apple.com/documentation/swiftui/referencefiledocument
 )
 rather than FileDocument for a struct.
*/
@available(macOS 12.0, *)
final class MandArtDocument: ReferenceFileDocument, ObservableObject {

  var docName: String = "unknown"
  static var readableContentTypes: [UTType] { [.mandartDocType] }

  // snapshot used to serialize and save current version
  // while active self remains editable by the user
  typealias Snapshot = PictureDefinition

  // our document has a @Published picdef property,
  // so when picdef is changed,
  // all views using that document will be reloaded
  // to reflect the picdef changes
  @Published var picdef: PictureDefinition

  /**
   A simple initializer that creates a new demo picture
   */
  init() {
    let hues: [Hue] = [
      Hue(num: 1, r: 0.0, g: 255.0, b: 0.0),
      Hue(num: 2, r: 255.0, g: 255.0, b: 0.0),
      Hue(num: 3, r: 255.0, g: 0.0, b: 0.0),
      Hue(num: 4, r: 255.0, g: 0.0, b: 255.0),
      Hue(num: 5, r: 0.0, g: 0.0, b: 255.0),
      Hue(num: 6, r: 0.0, g: 255.0, b: 255.0),
    ]
    self.picdef = PictureDefinition(hues: hues)
  }

  func getUserCGColorList() -> [CGColor] {
    return self.picdef.hues.map { hue in
      return CGColor(red: CGFloat(hue.r / 255.0), green: CGFloat(hue.g / 255.0), blue: CGFloat(hue.b / 255.0), alpha: 1.0)
    }
  }

  /**
   Initialize a document with our picdef property
   - Parameter configuration: config
   */
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents else {
      throw CocoaError(.fileReadCorruptFile)
    }
    self.picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
    self.docName = configuration.file.filename!
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
 //   let xString = String(picdef.xCenter)
 //   let yString = String(picdef.yCenter)

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

  func initSavePanel(fn: String) -> NSSavePanel {
    let savePanel = NSSavePanel()
    savePanel.title = "Choose Directory for MandArt image"
    savePanel.nameFieldStringValue = fn
    savePanel.canCreateDirectories = true
    return savePanel
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
    guard let destination = CGImageDestinationCreateWithURL(imageURL as CFURL, UTType.png.identifier as CFString, 1, nil) else {
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
          // Description is not saved.
          // The following is needed to actually write the description
          let imageURL = url
          let description = comment
          try self.setPNGDescription(imageURL: imageURL, description: description)

        } catch let error {
          print("Error saving image: \(error)")
        }
      }
    }
  }

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

// Provide operations on the MandArt document.
@available(macOS 12.0, *)
extension MandArtDocument {
   // Adds a new default hue, and registers an undo action.
  func addHue(undoManager: UndoManager? = nil) {
    self.picdef.hues.append(Hue())
    let newLength = self.picdef.hues.count
    self.picdef.hues[newLength - 1].num = newLength
    let count = self.picdef.hues.count
    undoManager?.registerUndo(withTarget: self) { doc in
      withAnimation {
        doc.deleteHue(index: count - 1, undoManager: undoManager)
      }
    }
  }

   // Deletes the hue at an index, and registers an undo action.
  func deleteHue(index: Int, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    withAnimation {
      _ = picdef.hues.remove(at: index)
    }

    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

   // Replaces the existing items with a new set of items.
  func replaceHues(with newHues: [Hue], undoManager: UndoManager? = nil, animation: Animation? = .default) {
    let oldHues = self.picdef.hues

    withAnimation(animation) {
      picdef.hues = newHues
    }

    undoManager?.registerUndo(withTarget: self) { doc in
      // Because you recurse here, redo support is automatic.
      doc.replaceHues(with: oldHues, undoManager: undoManager, animation: animation)
    }
  }

   // Relocates the specified items, and registers an undo action.
  func moveHuesAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    withAnimation {
      picdef.hues.move(fromOffsets: offsets, toOffset: toOffset)
    }

    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

   // Registers an undo action and a redo action for a hue change
  func registerUndoHueChange(for hue: Hue, oldHue: Hue, undoManager: UndoManager?) {
    let index = self.picdef.hues.firstIndex(of: hue)!

    // The change has already happened, so save the collection of new items.
    let newHues = self.picdef.hues

    // Register the undo action.
    undoManager?.registerUndo(withTarget: self) { doc in
      doc.picdef.hues[index] = oldHue

      // Register the redo action.
      undoManager?.registerUndo(withTarget: self) { doc in
        // Use the replaceItems symmetric undoable-redoable function.
        doc.replaceHues(with: newHues, undoManager: undoManager, animation: nil)
      }
    }
  }

  func updateHueWithColorNumberB(index: Int, newValue: Double, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    let oldHue = self.picdef.hues[index]
    let newHue = Hue(
      num: oldHue.num,
      r: oldHue.r,
      g: oldHue.g,
      b: newValue
    )
    self.picdef.hues[index] = newHue
    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

  func updateHueWithColorNumberG(index: Int, newValue: Double, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    let oldHue = self.picdef.hues[index]
    let newHue = Hue(
      num: oldHue.num,
      r: oldHue.r,
      g: newValue,
      b: oldHue.b
    )
    self.picdef.hues[index] = newHue
    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

  func updateHueWithColorNumberR(index: Int, newValue: Double, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    let oldHue = self.picdef.hues[index]
    let newHue = Hue(
      num: oldHue.num,
      r: newValue,
      g: oldHue.g,
      b: oldHue.b
    )
    self.picdef.hues[index] = newHue
    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

  /**
   Update an ordered color with a new selection from the ColorPicker
   - Parameters:
     - index: an Int for the index of this ordered color
     - newColorPick: the Color of the new selection
     - undoManager: undoManager
   */
  func updateHueWithColorPick(index: Int, newColorPick: Color, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    let oldHue = self.picdef.hues[index]
    if let arr = newColorPick.cgColor {
      let newHue = Hue(
        num: oldHue.num,
        r: arr.components![0] * 255.0,
        g: arr.components![1] * 255.0,
        b: arr.components![2] * 255.0
      )
      self.picdef.hues[index] = newHue
    }
    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }
}

// Helper utility
// Extending String functionality so we can use indexes to get substrings
@available(macOS 12.0, *)
extension String {
  subscript(_ range: CountableRange<Int>) -> String {
    let start = index(startIndex, offsetBy: max(0, range.lowerBound))
    let end = index(start, offsetBy: min(
      count - range.lowerBound,
      range.upperBound - range.lowerBound
    ))
    return String(self[start ..< end])
  }

  subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
    let start = index(startIndex, offsetBy: max(0, range.lowerBound))
    return String(self[start...])
  }
}

/**
 Extend UTType to include org.bhj.mandart (.mandart) files.
 */
@available(macOS 11.0, *)
extension UTType {
  static let mandartDocType = UTType(importedAs: "org.bhj.mandart")
}

/** Extend CGImage to add pngData()
 requires Cocoa
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
