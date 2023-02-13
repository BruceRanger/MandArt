///
///  MandArtApp.swift
///  MandArt
///
///  See https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui
///
///
///// get everything we can from MandMath (Swift-only) first
// let defaultFileName = MandMath.getDefaultDocumentName()
// let windowGroupName = MandMath.getWindowGroupName()

import AppKit // needed to get user screen dimensions
import SwiftUI

@available(macOS 12.0, *)
@main
struct MandArtApp: App {
    /// The body of the app; kicks off the opening page.
    ///  It creates a WindowGroup and DocumentGroup.
    var body: some Scene {
        // access the screen size
        //  let screenSize = NSScreen.main?.frame.size ?? .zero
        //      let screenHeight = round(screenSize.height)
        //     let screenWidth = round(screenSize.width)
        // let screenHeightStr = String(format: "%.0f",screenHeight)
        // let screenWidthStr = String(format: "%.0f",screenWidth)
        
        //  Unfortunately, the default behavior of ScrollView
        // in SwiftUI only supports vertical scrolling.
        
        WindowGroup(windowGroupName) {
            
            VStack {
                
                Spacer()
                
                Button("Click to open a sample MandArt") {
                    
                    // close current window and open new document
                    
                    NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
                    
                    NSDocumentController.shared.newDocument(defaultFileName)
                }
                
                Spacer()
                
                Text("See menu File / New to create a new MandArt document.")
                
                Spacer()
                
                Text("See menu / Help / MandArt Help to learn more.")
                
                Spacer()
                
            }  // end VStack
            .onAppear{
                NSWindow.allowsAutomaticWindowTabbing = false
            }
            .frame(minWidth: 300, maxWidth: 500,
                   minHeight: 200, maxHeight: 400)
            
        }
        
        DocumentGroup(newDocument: { MandArtDocument() }) { _ in
            ContentView()
                .onAppear{
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
            let displayText:String = "MandArt Help"
            let url:URL = URL(string: "https://denisecase.github.io/MandArt-Docs/documentation/mandart/")!
            CommandGroup(replacing:CommandGroupPlacement.help){
                Link(displayText, destination: url)
            }
            
            
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
