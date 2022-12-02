//
//  MandArtApp.swift
//  MandArt
//
//  See https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

import SwiftUI

@main
struct MandArtApp: App {
    var body: some Scene {

        WindowGroup("Welcome to MandArt") {
            // ContentView()

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
