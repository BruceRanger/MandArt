//
//  ColorlistRow.swift
//  MandArt
//

import SwiftUI

struct ColorlistRow: View {
    @Binding var item: ColorlistItem
    @FocusState private var isNumFieldFocused: Bool
    
    // Define these handlers as properties that you initialize
    // at the callsite to facilitate preview and testing.
    
 //   var onCheckToggle: () -> Void
    var onNumCommit: (_ oldNum: Int) -> Void
    
    @State private var oldNum: Int = 0
        
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Button {
               // onCheckToggle()
            } label: {
               // Image(systemName: item.isChecked ? "checkmark.square" : "square")
            }
            .buttonStyle(BorderlessButtonStyle())
            Text("No:")
            TextField("number",value: $item.num, formatter: ContentView.cgUnboundFormatter)
                .disabled(true)
                .padding(2)
            .focused($isNumFieldFocused)
            .onChange(of: isNumFieldFocused) { newValue in
                if isNumFieldFocused {
                    // The TextField is now focused.
                    oldNum = item.num
                }
            }
            .onSubmit {
                // The commit handler registers an undo action using the old title.
                onNumCommit(oldNum)
            }

            Spacer()
        }
    }
}

//struct ColorlistRow_Previews: PreviewProvider {
//
//    // Define a shim for the preview of ChecklistRow.
//    struct RowContainer: View {
//        @StateObject private var document = ColorlistDocument()
//
//        var body: some View {
//            ColorlistRow(item: $document.colorlist.items[0]) {
//                document.toggleItem(document.colorlist.items[0])
//            } onTextCommit: { _ in
//
//            }
//        }
//    }
//
//    static var previews: some View {
//        RowContainer()
//            .previewLayout(.sizeThatFits)
//    }
//}
