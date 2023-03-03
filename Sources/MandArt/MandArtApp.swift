/**
 MandArtApp

 This struct is the main entry point of the MandArt application.
 It has a body that creates a WindowGroup and a DocumentGroup.

 The WindowGroup presents an opening page that provides information
 about the app, a sample MandArt button, and links to help resources.

 The DocumentGroup creates new MandArtDocument instances and presents the ContentView for editing the MandArt picture.

 This class modifies the app menu by removing the Edit/pasteboard menu item
 and the View/Tab bar menu item and by replacing the Help/MandArt Help menu item
 with a link to the app's hosted documentation on GitHub Pages.

 Note: This class is only available on macOS 12.0 and later.
 */
import SwiftUI

@available(macOS 12.0, *)
@main
struct MandArtApp: App {


  var body: some Scene {

    WindowGroup("") {
      
      WelcomeView()
        .background(Color.white)
      .onAppear {
        NSWindow.allowsAutomaticWindowTabbing = false
      }
      
    }
    
    
    DocumentGroup(newDocument: { MandArtDocument() }) { _ in
      ContentView()
        .onAppear {
          NSWindow.allowsAutomaticWindowTabbing = false
        }
    }
    .commands {
      // Make all modifications to the MENU here

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

    }
  }
}
