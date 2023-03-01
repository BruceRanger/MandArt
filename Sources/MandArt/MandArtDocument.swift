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

  // Save the image to a file.
  func saveMandArtImage() {
    let winTitle = self.getCurrentWindowTitle()
    let justname = winTitle.replacingOccurrences(of: ".mandart", with: "")
    let imageFileName = justname + ".png"
    var data: Data
    do {
      data = try JSONEncoder().encode(self.picdef)
    } catch {
      print("!!error encoding self.picdef")
      exit(1)
    }
    let fileWrapper = FileWrapper(regularFileWithContents: data)

    // trigger state from this window / json document to get a current img
    self.picdef.imageHeight += 1
    self.picdef.imageHeight -= 1

    let currImage = contextImageGlobal!
    let savePanel = NSSavePanel()
    savePanel.title = "Choose Directory for MandArt image"
    savePanel.nameFieldStringValue = imageFileName
    savePanel.canCreateDirectories = true
    savePanel.begin { result in
      if result == .OK, let url = savePanel.url {
        let dest = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeJPEG, 1, nil)
        CGImageDestinationAddImage(dest!, currImage, nil)
        if CGImageDestinationFinalize(dest!) {
          print("Image saved successfully to \(url)")
        } else {
          print("Error saving image")
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

extension UTType {
  static let mandartDocType = UTType(importedAs: "org.bhj.mandart")
}
