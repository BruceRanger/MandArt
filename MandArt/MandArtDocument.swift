//
//  MandArtDocument.swift
//  MandArt
//
//  See:
//  https://www.hackingwithswift.com/quick-start/swiftui/
//  how-to-create-a-document-based-app-using-filedocument-and-documentgroup
//

import SwiftUI
import UniformTypeIdentifiers
import CoreGraphics
import ImageIO
import AppKit // uikit for mobile, appkit for Mac

/// A utility class to work with files for saving and sharing your art.
/// Includes logic for adding, deleting, and reordering colors.
///
/// Note: Since MandArtDocument is a class, we derive from
/// [ReferenceFileDocument](
/// https://developer.apple.com/documentation/swiftui/referencefiledocument
/// )
/// rather than FileDocument for a struct.
final class MandArtDocument: ReferenceFileDocument {
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
    }

    /// Save the picture definittion document to file.
    /// - Parameters:
    ///   - snapshot: snapshot of the current state
    ///   - configuration: write config
    /// - Returns: a fileWrapper
    func fileWrapper(
        snapshot: PictureDefinition,
        configuration _: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        print("print the image too")
        let modDate = fileWrapper.fileAttributes["NSFileModificationDate"]
        let uniqueString = stringFromAny(modDate)
        let success = saveImage(tag: uniqueString)
        if !success {
            print("Error saving file. Should show this to the user.")
        }
        return fileWrapper
    }

    /// Save custom user MandArt as a .png file.
    ///  To find it after saving, search your machine for mandart
    ///  It will be named mandart-datetime.png
    /// - Parameter tag: unique string of datatime saved
    /// - Returns: a Bool true if successful, false if not
    func saveImage(tag: String) -> Bool {
        print("saving image with tag=", tag)
        let endCount = tag.count - 6
        let uniqueEnough = tag[0 ..< endCount] // see string extension
        let fn = "mandart-" + uniqueEnough + ".png"
        print("Saving Image as ", fn)
        let allocator: CFAllocator = kCFAllocatorDefault
        let filePath: CFString = fn as NSString
        let pathStyle = CFURLPathStyle.cfurlWindowsPathStyle
        let isDirectory = false
        let url: CFURL = CFURLCreateWithFileSystemPath(allocator, filePath, pathStyle, isDirectory)
        print("Saving Image to ", url)
        //  file:///Users/denisecase/Library/Containers/Bruce-Johnson.MandArt/Data/
        let imageType: CFString = kUTTypePNG
        let count = 1
        let options: CFDictionary? = nil
        var destination: CGImageDestination
        let destinationAttempt: CGImageDestination? = CGImageDestinationCreateWithURL(url, imageType, count, options)
        if destinationAttempt == nil {
            return false
        } else {
            destination = destinationAttempt.unsafelyUnwrapped
            CGImageDestinationAddImage(destination, contextImageGlobal!, nil)
            CGImageDestinationFinalize(destination)
            saveImageUserDirectory(contextImageGlobal!, fileName: fn)
            return true
        }
    }

    /// Yes, you may need to adjust your project settings
    /// to have the proper entitlements to access the user's picturesDirectory folder.
    /// To do this, go to your project's Signing & Capabilities tab
    /// and enable the Files and Folders capability for your app.

    /// Once you've done that, you'll be able to access the user's picturesDirectory
    /// folder and save files there.
    /// Keep in mind that this capability only applies to apps running on
    /// macOS 11.0 or later.
    /// For earlier versions of macOS,
    /// you'll need to use the app's sandbox container's picturesDirectory folder.
    ///
    func saveImageUserDirectory(_ image: CGImage!, fileName: String) {
        DispatchQueue.main.async {
            let savePanel = NSSavePanel()
            savePanel.title = "Choose Directory for MandArt image"
            savePanel.nameFieldStringValue = fileName
            savePanel.canCreateDirectories = true
            savePanel.begin { result in
                if result == .OK, let url = savePanel.url {
                    let dest = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeJPEG, 1, nil)
                    CGImageDestinationAddImage(dest!, image, nil)
                    if CGImageDestinationFinalize(dest!) {
                        print("Image saved successfully to \(url)")
                    } else {
                        print("Error saving image")
                    }
                }
            }
            print("After savePanel.begin")
        }
    }

    /// Create a snapshot of the current state of the document for serialization
    ///  while the live self remains editiable by the user
    /// - Parameter contentType: the standard type we use
    /// - Returns: picture definition
    func snapshot(contentType _: UTType) throws -> PictureDefinition {
        return picdef // return the current state
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
