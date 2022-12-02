//
//  ColorlistView.swift
//  MandArt
//

import SwiftUI

struct ColorlistView: View {
    /// The document that the environment stores.
    @EnvironmentObject var document: ColorlistDocument
    /// The undo manager that the environment stores.
    /// - Tag: UndoManager
    @Environment(\.undoManager) var undoManager
    
    #if os(iOS) // Edit mode doesn't exist in macOS.
    @Environment(\.editMode) var editMode
    #endif // os(iOS)
    
    /// The internal selection state.
    @State private var selection = Set<UUID>()
        
    /// - Tag: ToggleAction
    var body: some View {
        List(selection: $selection) {
            // Iterate over a collection of bindings to the items.
            ForEach($document.colorlist.items) { $item in
                ColorlistRow(item: $item) {
                    // The checkbox toggle action.
                    document.toggleItem($item.wrappedValue, undoManager: undoManager)
                } onTextCommit: { oldTitle in
                    // The title changed the commit action.
                    document.registerUndoTitleChange(for: $item.wrappedValue, oldTitle: oldTitle, undoManager: undoManager)
                }
            }
            .onDelete(perform: onDelete)
            .onMove(perform: onMove)
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                addButton
                    .disabled(editMode?.wrappedValue == .active ? true : false)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #elseif os(macOS)
            ToolbarItem {
                addButton
            }
            ToolbarItem {
                deleteButton
            }
            #endif // os(iOS)
        }
    }
    
    /// Adds a new item to the list.
    var addButton: some View {
        Button(action: {
            print("Button tapped!")
            withAnimation {
                document.addItem(title: "Another item.", undoManager: undoManager)
            }
        }) {
            Image(systemName: "plus")
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    /// A button with an action that deletes the selected items from the list.
    var deleteButton: some View {
        Button(action: {
            print("Button tapped!")
            withAnimation {
                document.deleteItems(withIDs: Array(selection), undoManager: undoManager)
            }
            selection.removeAll()
        }) {
            Image(systemName: "trash")
        }
        .buttonStyle(BorderlessButtonStyle())
        .disabled(selection.isEmpty)
    }
    
    /// Deletes a set of items from the list.
    func onDelete(offsets: IndexSet) {
        document.delete(offsets: offsets, undoManager: undoManager)
    }
    
    /// Moves a set of items to a new location.
    func onMove(offsets: IndexSet, toOffset: Int) {
        document.moveItemsAt(offsets: offsets, toOffset: toOffset, undoManager: undoManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            #if os(iOS)
            // Provide the navigation view that `DocumentGroup` provides in the app.
            NavigationView {
                ColorlistView().environmentObject(ColorlistDocument())
                    // Avoid presenting with grouped style.
                    .listStyle(PlainListStyle())
            }
            #else
            ColorlistView().environmentObject(ColorlistDocument())
            #endif // os(iOS)
        }
    }
}
