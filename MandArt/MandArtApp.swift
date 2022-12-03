///
///  MandArtApp.swift
///  MandArt
///
///  See https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

import SwiftUI

/// The main entry point for MandArt.
///
///  Click the button to open a picture document.
///
@main
struct MandArtApp: App {

    /// The body of the app; kicks off the opening page.
    ///  It creates a WindowGroup and DocumentGroup.
    var body: some Scene {

        WindowGroup("Welcome to MandArt") {

            // In some action at the end of this scene flow
            // just close current window and open new document
            Button("View Sample Art") {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
                NSDocumentController.shared.newDocument("default.json")
            }
        }

        DocumentGroup(newDocument: { MandArtDocument() }) { configuration in
            ContentView()
        }
    }
}
