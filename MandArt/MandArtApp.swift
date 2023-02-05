///
///  MandArtApp.swift
///  MandArt
///
///  See https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui
///

import SwiftUI

@main
struct MandArtApp: App {
    let windowGroupName = MandMath.getWindowGroupName()

    /// The body of the app; kicks off the opening page.
    ///  It creates a WindowGroup and DocumentGroup.
    var body: some Scene {
        WindowGroup(windowGroupName) {
            OpeningView()
        }

        let defdoc = MandArtDocument()
        DocumentGroup(newDocument: { defdoc }) { _ in
            ContentView().environmentObject(defdoc)
        }
        .commands {
            // we don't need the pasteboard (cut/copy/paste/delete_
            CommandGroup(replacing: .pasteboard) {}
        }
    }
}
