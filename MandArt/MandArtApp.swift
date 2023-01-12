///
///  MandArtApp.swift
///  MandArt
///
///  See https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

import SwiftUI

@main
struct MandArtApp: App {

    /// The body of the app; kicks off the opening page.
    ///  It creates a WindowGroup and DocumentGroup.
    var body: some Scene {

        // get everything we can from MandMath (Swift-only) first
        let defaultFileName = MandMath.getDefaultDocumentName()
        let windowGroupName = MandMath.getWindowGroupName()
        let openingButtonText = MandMath.getOpeningButtonText()

        WindowGroup(windowGroupName) {
            // In some action at the end of this scene flow
            // just close current window and open new document
            Button(openingButtonText) {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
                NSDocumentController.shared.newDocument(defaultFileName)
            }
            .frame(minWidth: 300, maxWidth: .infinity,
                   minHeight: 200, maxHeight: .infinity)
        }

        DocumentGroup(newDocument: { MandArtDocument() }) { configuration in
            ContentView()
        }
        .commands {
            // use CommandGroup to modify built-in menu behavior
            //CommandGroup(replacing: .help) {
                // what needs to go here?
            //}

            // we don't need the pasteboard (cut/copy/paste/delete_
            CommandGroup(replacing: .pasteboard) { }

        }
    }
}

 
