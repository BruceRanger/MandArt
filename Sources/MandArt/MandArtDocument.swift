/**
 A document for creating and editing MandArt pictures.

 MandArtDocument is a reference file document that supports only reading and writing JSON files.
 Its snapshot is a PictureDefinition and it has a @Published picdef property that, when changed,
 triggers a reload of all views using the document. This document class also has a jsonDocumentName
 property for the name of the JSON document and a simple initializer that creates a new demo picture.

 For more information, see:
 https://www.hackingwithswift.com/quick-start/swiftui/
 how-to-create-a-document-based-app-using-filedocument-and-documentgroup

 Note: This class is only available on macOS 12.0 and later.
 */
import AppKit // uikit for mobile, appkit for Mac
import CoreGraphics
import ImageIO
import SwiftUI
import UniformTypeIdentifiers

/// A utility class to work with files for saving and sharing your art.
/// Includes logic for adding, deleting, and reordering colors.
///
/// Note: Since MandArtDocument is a class, we derive from
/// [ReferenceFileDocument](
/// https://developer.apple.com/documentation/swiftui/referencefiledocument
/// )
/// rather than FileDocument for a struct.
///
@available(macOS 12.0, *)
final class MandArtDocument: ReferenceFileDocument {
    var jsonDocumentName: String = "unknowndocname"

    // tell the system we support only reading / writing json files
    static var readableContentTypes = [UTType.json]

    // snapshot is used to serialize and save the current version
    // while the active self remains editable by the user
    typealias Snapshot = PictureDefinition

    // our document has a @Published picdef property,
    // so when picdef is changed,
    // all views using that document will be reloaded
    // to reflect the picdef changes
    @Published var picdef: PictureDefinition

    /// A simple initializer that creates a new demo picture
    init() {
        let hues: [Hue] = [
            Hue(num: 1, r: 0.0, g: 255.0, b: 0.0),
            Hue(num: 2, r: 255.0, g: 255.0, b: 0.0),
            Hue(num: 3, r: 255.0, g: 0.0, b: 0.0),
            Hue(num: 4, r: 255.0, g: 0.0, b: 255.0),
            Hue(num: 5, r: 0.0, g: 0.0, b: 255.0),
            Hue(num: 6, r: 0.0, g: 255.0, b: 255.0)
        ]
        picdef = PictureDefinition(hues: hues)
    }

    /// Initialize a document with our picdef property
    /// - Parameter configuration: config
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
        jsonDocumentName = configuration.file.filename!
        print("Opening JSON file = ", jsonDocumentName)
    }

    /// Save the active picture definittion data to a file.
    /// - Parameters:
    ///   - snapshot: snapshot of the current state
    ///   - configuration: write config
    /// - Returns: a fileWrapper
    func fileWrapper(
        snapshot: PictureDefinition,
        configuration _: WriteConfiguration
    ) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        let fn = fileWrapper.filename
        print("When saving a new /unamed file, the json file name is ", fn)
        print("In fileWrapper function, saving jsonDocumentName=", jsonDocumentName)
        return fileWrapper
    }

    @available(macOS 12.0, *)
    func saveImagePictureFromJSONDocument() {
        print("Saving image from JSON file:", jsonDocumentName)
        let justname = jsonDocumentName.replacingOccurrences(of: ".json", with: "")
        //      let fn = "mandart-from-" + justname + ".png"
        let fn = justname + ".png"

        var data: Data
        do {
            data = try JSONEncoder().encode(picdef)
        } catch {
            print("!!error encoding self.picdef")
            exit(1)
        }
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        // trigger state from this window / json document to get a current img
        picdef.imageHeight = picdef.imageHeight + 1
        picdef.imageHeight = picdef.imageHeight - 1

        let currImage = contextImageGlobal!
        let savePanel = NSSavePanel()
        savePanel.title = "Choose Directory for MandArt image"
        savePanel.nameFieldStringValue = fn
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

    /// Create a snapshot of the current state of the document for serialization
    ///  while the live self remains editiable by the user
    /// - Parameter contentType: the standard type we use
    /// - Returns: picture definition
    @available(macOS 12.0, *)
    func snapshot(contentType _: UTType) throws -> PictureDefinition {
        picdef // return the current state
    }

    /// Helper function to return a String from an Any?
    /// - Parameter value: an optional Any (Any?)
    /// - Returns: a String with content if possible, otherwise an empty String
    func stringFromAny(_ value: Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
}

// Provide operations on the MandArt document.
@available(macOS 12.0, *)
extension MandArtDocument {
    /// Adds a new default hue, and registers an undo action.
    func addHue(undoManager: UndoManager? = nil) {
        picdef.hues.append(Hue())
        let newLength = picdef.hues.count
        picdef.hues[newLength - 1].num = newLength
        picdef.nColors = newLength
        let count = picdef.hues.count
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                doc.deleteHue(index: count - 1, undoManager: undoManager)
            }
        }
    }

    /// Deletes the hue at an index, and registers an undo action.
    func deleteHue(index: Int, undoManager: UndoManager? = nil) {
        let oldHues = picdef.hues
        picdef.nColors = picdef.nColors - 1
        withAnimation {
            _ = picdef.hues.remove(at: index)
        }

        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceHues(with: oldHues, undoManager: undoManager)
        }
    }

    /// Replaces the existing items with a new set of items.
    func replaceHues(with newHues: [Hue], undoManager: UndoManager? = nil, animation: Animation? = .default) {
        let oldHues = picdef.hues

        withAnimation(animation) {
            picdef.hues = newHues
        }

        undoManager?.registerUndo(withTarget: self) { doc in
            // Because you recurse here, redo support is automatic.
            doc.replaceHues(with: oldHues, undoManager: undoManager, animation: animation)
        }
    }

    /// Relocates the specified items, and registers an undo action.
    func moveHuesAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
        let oldHues = picdef.hues
        withAnimation {
            picdef.hues.move(fromOffsets: offsets, toOffset: toOffset)
        }

        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceHues(with: oldHues, undoManager: undoManager)
        }
    }

    /// Registers an undo action and a redo action for a hue change
    func registerUndoHueChange(for hue: Hue, oldHue: Hue, undoManager: UndoManager?) {
        let index = picdef.hues.firstIndex(of: hue)!

        // The change has already happened, so save the collection of new items.
        let newHues = picdef.hues

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
        let oldHues = picdef.hues
        let oldHue = picdef.hues[index]
        let newHue = Hue(num: oldHue.num,
                         r: oldHue.r,
                         g: oldHue.g,
                         b: newValue)
        picdef.hues[index] = newHue
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceHues(with: oldHues, undoManager: undoManager)
        }
    }

    func updateHueWithColorNumberG(index: Int, newValue: Double, undoManager: UndoManager? = nil) {
        let oldHues = picdef.hues
        let oldHue = picdef.hues[index]
        let newHue = Hue(num: oldHue.num,
                         r: oldHue.r,
                         g: newValue,
                         b: oldHue.b)
        picdef.hues[index] = newHue
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceHues(with: oldHues, undoManager: undoManager)
        }
    }

    func updateHueWithColorNumberR(index: Int, newValue: Double, undoManager: UndoManager? = nil) {
        let oldHues = picdef.hues
        let oldHue = picdef.hues[index]
        let newHue = Hue(num: oldHue.num,
                         r: newValue,
                         g: oldHue.g,
                         b: oldHue.b)
        picdef.hues[index] = newHue
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceHues(with: oldHues, undoManager: undoManager)
        }
    }

    /// Update an ordered color with a new selection from the ColorPicker
    /// - Parameters:
    ///   - index: an Int for the index of this ordered color
    ///   - newColorPick: the Color of the new selection
    ///   - undoManager: undoManager
    func updateHueWithColorPick(index: Int, newColorPick: Color, undoManager: UndoManager? = nil) {
        let oldHues = picdef.hues
        let oldHue = picdef.hues[index]
        if let arr = newColorPick.cgColor {
            let newHue = Hue(num: oldHue.num,
                             r: arr.components![0] * 255.0,
                             g: arr.components![1] * 255.0,
                             b: arr.components![2] * 255.0)
            picdef.hues[index] = newHue
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
        let end = index(start, offsetBy: min(count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start ..< end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}
