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

        WindowGroup("Welcome to MandArt") {

            // In some action at the end of this scene flow
            // just close current window and open new document
            Button("View Sample Art") {
                NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
                NSDocumentController.shared.newDocument("default.json")
            }
            .frame(width: 500, height: 400,alignment: .center)
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

            // we don't need start dictation or emoji and symbols

            // we want to enable undo redo
            // CommandGroup(replacing: .undoRedo) {}


            // we can add a new menu before the window option
            // like so
            //            CommandMenu("About") {
            //                Button(action: {
            //                }) {
            //                    Text("Test")
            //                }
            //            }
        }
    }
}

 
