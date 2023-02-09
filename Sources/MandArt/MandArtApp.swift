///
///  MandArtApp.swift
///  MandArt
///
///  See https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui
///
///
///// get everything we can from MandMath (Swift-only) first
//let defaultFileName = MandMath.getDefaultDocumentName()
//let windowGroupName = MandMath.getWindowGroupName()

import SwiftUI
import AppKit // needed to get user screen dimensions

@available(macOS 12.0, *)
@main
struct MandArtApp: App {


    /// The body of the app; kicks off the opening page.
    ///  It creates a WindowGroup and DocumentGroup.
    var body: some Scene {

            // access the screen size
        let screenSize = NSScreen.main?.frame.size ?? .zero
            let screenHeight = round(screenSize.height)
            let screenWidth = round(screenSize.width)
            let screenHeightStr = String(format: "%.0f",screenHeight)
            let screenWidthStr = String(format: "%.0f",screenWidth)

        //  Unfortunately, the default behavior of ScrollView
        // in SwiftUI only supports vertical scrolling.

            WindowGroup(windowGroupName) {

                ScrollView(showsIndicators: true) {

//                    HStack {
//                        Text("Screen Size \(screenWidthStr) x \(screenHeightStr)")


                    VStack {

                        // just close current window and open new document
                        Button("Click to open a sample MandArt") {
                            NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
                            NSDocumentController.shared.newDocument(defaultFileName)
                            
                        }
                        .frame(minWidth: 300, maxWidth: 500,
                               minHeight: 200, maxHeight: 400)


//                        ForEach(0..<100) { _ in
//                            Text("This is a sample text")
//                                .frame(width: 100)
//                        }
//
//                        HStack {
//                            ForEach(0..<100) { _ in
//                                Text("This is a sample text")
//                                    .frame(width: 100)
//                            }
//                        }


                    }

                   // }
                }
                .frame(minWidth: 300, maxWidth: 500,
                       minHeight: 200, maxHeight: 400)

        }


        DocumentGroup(newDocument: { MandArtDocument() }) { configuration in
            ContentView()
        }
        .commands {
            // we don't need the pasteboard (cut/copy/paste/delete_
            CommandGroup(replacing: .pasteboard) {}
        }
    }
}

/*

 SwiftFormat is a command-line tool that can be used to format your Swift code.
 Here's how you can use it:

 Install SwiftFormat using Homebrew, by running the following command
 in the terminal:

 brew install swiftformat

 Format your code: To format a single file,
 run the following command in the terminal:

 swiftformat <file-name>.swift

 To format an entire directory, run the following command:

 swiftformat <directory-name>

 */

/*

 SwiftLint is a tool that helps enforce Swift style and conventions.
 Here's how you can use it:

 Install SwiftLint using Homebrew,
 by running the following command in the terminal:

 brew install swiftlint

 Lint your code:
 To lint a single file, run the following command in the terminal:

 swiftlint lint <file-name>.swift

 To lint an entire directory, run the following command:

 swiftlint lint <directory-name>

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
