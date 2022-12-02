//
//  ColorlistRow.swift
//  MandArt
//

import SwiftUI

struct ColorlistRow: View {
    @Binding var item: ColorlistItem
    @FocusState private var isTitleFieldFocused: Bool
    
    // Define these handlers as properties that you initialize
    // at the callsite to facilitate preview and testing.
    var onCheckToggle: () -> Void
    var onTextCommit: (_ oldTitle: String) -> Void
    
    @State private var oldTitle: String = ""
        
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Button {
                onCheckToggle()
            } label: {
                Image(systemName: item.isChecked ? "checkmark.square" : "square")
            }
            .buttonStyle(BorderlessButtonStyle())
            
            TextField("", text: $item.title)
            .focused($isTitleFieldFocused)
            .onChange(of: isTitleFieldFocused) { newValue in
                if isTitleFieldFocused {
                    // The TextField is now focused.
                    oldTitle = item.title
                }
            }
            .onSubmit {
                // The commit handler registers an undo action using the old title.
                onTextCommit(oldTitle)
            }

            Spacer()
        }
    }
}

struct ColorlistRow_Previews: PreviewProvider {
    
    // Define a shim for the preview of ChecklistRow.
    struct RowContainer: View {
        @StateObject private var document = ColorlistDocument()

        var body: some View {
            ColorlistRow(item: $document.colorlist.items[0]) {
                document.toggleItem(document.colorlist.items[0])
            } onTextCommit: { _ in
                
            }
        }
    }

    static var previews: some View {
        RowContainer()
            .previewLayout(.sizeThatFits)
    }
}
