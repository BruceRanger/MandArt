//
//  OpeningView.swift
//  MandArt
////

import SwiftUI

struct OpeningView: View {
    let defaultFileName = MandMath.getDefaultDocumentName()

    var body: some View {
        VStack {
            Text("Use the MandArt Menu:")
                .padding(10)

            Text("select 'File/Open' or 'File/Open Recent'")
                .padding(10)

            Text("to open an existing MandArt file.")
                .padding(10)

            Text("Or click here to open an example.")
                .padding(10)

            Text("After changing a value, hit RETURN.")
                .padding(10)

            Text("When done editing, click 'File/Save'.")
                .padding(10)
        }
        .foregroundColor(.white)
        .font(.largeTitle)
        .frame(
            minWidth: 500,
            minHeight: 400
        )
        .background(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .leading, endPoint: .trailing))
        .onTapGesture {
            NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
            NSDocumentController.shared.newDocument(defaultFileName)
        }
    }
}
