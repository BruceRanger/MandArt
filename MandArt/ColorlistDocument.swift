//
//  ColorlistDocument.swift
//  MandArt
//

import SwiftUI
import UniformTypeIdentifiers

// Define this document's type.
extension UTType {
    static let colorlistDocument = UTType(exportedAs: "com.example.colorlist")
}

final class ColorlistDocument: ReferenceFileDocument {

    typealias Snapshot = Colorlist
    
    @Published var colorlist: Colorlist
    
    // Define the document type this app is able to load.
    /// - Tag: ContentType
    static var readableContentTypes: [UTType] { [.colorlistDocument] }
    
    /// - Tag: Snapshot
    func snapshot(contentType: UTType) throws -> Colorlist {
        colorlist // Make a copy.
    }
    
    init() {
        colorlist = .demoList
    }

    // Load a file's contents into the document.
    /// - Tag: DocumentInit
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.colorlist = try JSONDecoder().decode(Colorlist.self, from: data)
    }
    
    /// Saves the document's data to a file.
    /// - Tag: FileWrapper
    func fileWrapper(snapshot: Colorlist, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}

// Provide operations on the checklist document.
extension ColorlistDocument {
    
    /// Toggles an item's checked status, and registers an undo action.
    /// - Tag: PerformToggle
    func toggleItem(_ item: ColorlistItem, undoManager: UndoManager? = nil) {
        let index = colorlist.items.firstIndex(of: item)!
        
        colorlist.items[index].isChecked.toggle()
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Because it calls itself, this is redoable, as well.
            doc.toggleItem(item, undoManager: undoManager)
        }
    }
    
    /// Adds a new item, and registers an undo action.
    func addItem(title: String, undoManager: UndoManager? = nil) {
        colorlist.addItem(title: title)
        let count = colorlist.items.count
        undoManager?.registerUndo(withTarget: self) { doc in
            withAnimation {
                doc.deleteItem(index: count - 1, undoManager: undoManager)
            }
        }
    }
    
    /// Deletes the item at an index, and registers an undo action.
    func deleteItem(index: Int, undoManager: UndoManager? = nil) {
        let oldItems = colorlist.items
        withAnimation {
            _ = colorlist.items.remove(at: index)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceItems(with: oldItems, undoManager: undoManager)
        }
    }
    
    /// Deletes the items with specified IDs.
    func deleteItems(withIDs ids: [UUID], undoManager: UndoManager? = nil) {
        var indexSet: IndexSet = IndexSet()

        let enumerated = colorlist.items.enumerated()
        for (index, item) in enumerated where ids.contains(item.id) {
            indexSet.insert(index)
        }

        delete(offsets: indexSet, undoManager: undoManager)
    }
    
    /// Replaces the existing items with a new set of items.
    func replaceItems(with newItems: [ColorlistItem], undoManager: UndoManager? = nil, animation: Animation? = .default) {
        let oldItems = colorlist.items
        
        withAnimation(animation) {
            colorlist.items = newItems
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
                // Because you recurse here, redo support is automatic.
            doc.replaceItems(with: oldItems, undoManager: undoManager, animation: animation)
        }
    }

    /// Deletes the items at a specified set of offsets, and registers an undo action.
    func delete(offsets: IndexSet, undoManager: UndoManager? = nil) {
        let oldItems = colorlist.items
        withAnimation {
            colorlist.items.remove(atOffsets: offsets)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceItems(with: oldItems, undoManager: undoManager)
        }
    }
    
    /// Relocates the specified items, and registers an undo action.
    func moveItemsAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
        let oldItems = colorlist.items
        withAnimation {
            colorlist.items.move(fromOffsets: offsets, toOffset: toOffset)
        }
        
        undoManager?.registerUndo(withTarget: self) { doc in
            // Use the replaceItems symmetric undoable-redoable function.
            doc.replaceItems(with: oldItems, undoManager: undoManager)
        }
        
    }
    
    /// Registers an undo action and a redo action for a title change.
    func registerUndoTitleChange(for item: ColorlistItem, oldTitle: String, undoManager: UndoManager?) {
        let index = colorlist.items.firstIndex(of: item)!
        
        // The change has already happened, so save the collection of new items.
        let newItems = colorlist.items
        
        // Register the undo action.
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.colorlist.items[index].title = oldTitle
            
            // Register the redo action.
            undoManager?.registerUndo(withTarget: self) { doc in
                // Use the replaceItems symmetric undoable-redoable function.
                doc.replaceItems(with: newItems, undoManager: undoManager, animation: nil)
            }
        }
    }

}
