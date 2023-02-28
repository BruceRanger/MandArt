/**
 MandArtApp

 This struct is the main entry point of the MandArt application.  It has a body that creates a WindowGroup
 and a DocumentGroup. The WindowGroup presents an opening page that provides information
 about the app, a sample MandArt button, and links to help resources. The DocumentGroup creates new MandArtDocument instances and presents the ContentView for editing the MandArt picture. This class
 modifies the app menu by removing the Edit/pasteboard menu item and the View/Tab bar menu item
 and by replacing the Help/MandArt Help menu item with a link to the app's hosted documentation on
 GitHub Pages.

 For more information, see:
 https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

 Note: This class is only available on macOS 12.0 and later.
 */
import AppKit // needed to get user screen dimensions
import SwiftUI

@available(macOS 12.0, *)
@main
struct MandArtApp: App {
    /// The body of the app; kicks off the opening page.
    ///  It creates a WindowGroup and DocumentGroup.
    var body: some Scene {

        WindowGroup(windowGroupName) {

            VStack {
                Spacer()
                Button("Click to open a sample MandArt") {
                    // close current window and open new document

                    NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)

                    NSDocumentController.shared.newDocument(defaultFileName)
                }
                Spacer()
                Text("See menu: File > New to create a new MandArt document.")
                Spacer()
                Text("See menu: Help > MandArt Help to learn more.")
                Spacer()
            } // end VStack
            .frame(minWidth: 400, maxWidth: 800,
                   minHeight: 200, maxHeight: 400)
            .onAppear {
                NSWindow.allowsAutomaticWindowTabbing = false
            }
        }

        DocumentGroup(newDocument: { MandArtDocument() }) { configuration in
            ContentView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            // Make all modifications to the MENU in here

            // we don't need the Edit/pasteboard menu item (cut/copy/paste/delete)
            // so we'll replace it with nothing
            CommandGroup(replacing: CommandGroupPlacement.pasteboard) {}

            // we don't need the Edit/Emoji and Symbols menu item
            // so we could turn it off using Objective-C
            // but that seems extreme, so we'll leave it in

            // we don't need the View / Tab bar menu item
            // so we turned it off above using
            // NSWindow.allowsAutomaticWindowTabbing = false

            // Help has "Search" & "MandArt Help" by default
            // let's replace the MandArt help option with a Link
            // to our hosted documenation on GitHub Pages
            let displayText: String = "MandArt Help"
            let url: URL = .init(string: "https://denisecase.github.io/MandArt-Docs/documentation/mandart/")!
            CommandGroup(replacing: CommandGroupPlacement.help) {
                Link(displayText, destination: url)
            }
        } // end .commands
    } // end body
} // end app

/*

 SwiftFormat is a command-line tool that can be used to format your Swift code.
 Here's how you can use it.

 Install SwiftFormat using Homebrew, by running the following command:

 brew install swiftformat

 Format your code: To format a single file, run the following command:

 swiftformat <file-name>.swift

 To format an entire directory, run the following command:

 swiftformat <directory-name> or, from the root project repo directory:

 swiftformat .

 */

/*

 SwiftLint is a tool that helps enforce Swift style and conventions.
 Here's how you can use it:

 Install SwiftLint using Homebrew, by running the following command:

 brew install swiftlint

 To lint a single file, run the following command:

 swiftlint lint <file-name>.swift

 To lint an entire directory, run the following command from the root project
 repo folder:

 swiftlint lint .

 Customize lint rules:
 SwiftLint has a number of customizable rules
 that can be used to enforce specific coding conventions and standards.
 You can specify these rules by creating a .swiftlint.yml configuration
 file in your project's root directory or
 by passing them as command-line arguments.

 Integrating with Xcode:
 SwiftLint can be easily integrated with Xcode to automatically
 check and enforce coding style in real-time.
 To do this, you can add a new "Run Script" phase
 to your Xcode project and call the swiftlint command
 with the appropriate arguments.

 SwiftLint will enforce the specified lint rules and conventions,
 helping you maintain a consistent and high-quality codebase.

 To lint and fix, run:

 swiftlint --fix && swiftlint MandArtApp.swift
 */
