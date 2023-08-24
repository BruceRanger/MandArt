import SwiftUI
import AppKit

@available(macOS 12.0, *)
@main
struct MandArtApp: App {

  struct AppConstants {
    static let defaultOpeningWidth: CGFloat = 800.0
    static let defaultOpeningHeight: CGFloat = 600.0
    static let defaultPercentWidth: CGFloat = 0.8
    static let defaultPercentHeight: CGFloat = 0.8

    static func defaultWidth() -> CGFloat {
      if let screenWidth = NSScreen.main?.visibleFrame.width {
        return screenWidth * defaultPercentWidth
      }
      return defaultOpeningWidth
    }

    static func defaultHeight() -> CGFloat {
      if let screenHeight = NSScreen.main?.visibleFrame.height {
        return screenHeight * defaultPercentHeight
      }
      return defaultOpeningHeight
    }
  }


  @AppStorage("shouldShowWelcome") var shouldShowWelcome: Bool = true

  init() {
    let value = UserDefaults.standard.bool(forKey: "shouldShowWelcome")
    print("Starting up. Should show welcome: \(value)")
  }

  var body: some Scene {

    WindowGroup {

      if shouldShowWelcome {
        WelcomeView()
          .onAppear {
            NSWindow.allowsAutomaticWindowTabbing = false
          }
      } else {
        ContentView()
          .environmentObject(MandArtDocument())
          .onAppear {
            NSWindow.allowsAutomaticWindowTabbing = false
          }
      }

    }

    DocumentGroup(newDocument: { MandArtDocument() }) { _ in
      ContentView()
        .frame(
          width: AppConstants.defaultWidth(),
          height: AppConstants.defaultHeight()
        )
        .onAppear {
          NSWindow.allowsAutomaticWindowTabbing = false
        }
    }

    .commands {
     appMenuCommands()
    }
  }

}
