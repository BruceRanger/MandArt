import AppKit
import SwiftUI

@available(macOS 10.15, *)
class AppState: ObservableObject {
  @Published var shouldShowWelcomeWhenStartingUp: Bool = UserDefaults.standard
    .object(forKey: "shouldShowWelcomeWhenStartingUp") as? Bool ?? true
}

@available(macOS 10.15, *)
struct WindowAccessor: NSViewRepresentable {
  var callback: (NSWindow?) -> Void

  func makeNSView(context _: Context) -> NSView {
    let view = NSView()
    DispatchQueue.main.async {
      self.callback(view.window)
    }
    return view
  }

  func updateNSView(_: NSView, context _: Context) {}
}

@available(macOS 12.0, *)
@main
struct MandArtApp: App {
  @StateObject private var defaultDocument = MandArtDocument()
  @StateObject var appState: AppState
  @State private var shouldShowWelcomeWhenStartingUp: Bool

  init() {
    let initialState = UserDefaults.standard.object(forKey: "shouldShowWelcomeWhenStartingUp") as? Bool ?? true
    _appState = StateObject(wrappedValue: AppState())
    _shouldShowWelcomeWhenStartingUp = State(initialValue: initialState)
  }

  enum AppConstants {
    static let defaultOpeningWidth: CGFloat = 800.0
    static let defaultOpeningHeight: CGFloat = 600.0
    static let defaultPercentWidth: CGFloat = 0.8
    static let defaultPercentHeight: CGFloat = 0.8
    static let dockAndPreviewsWidth: CGFloat = 200.0
    static let minWelcomeWidth: CGFloat = 500.0
    static let minWelcomeHeight: CGFloat = 500.0
    static let heightMargin: CGFloat = 50.0

    static func defaultWidth() -> CGFloat {
      if let screenWidth = NSScreen.main?.visibleFrame.width {
        return min(screenWidth * defaultPercentWidth, screenWidth - dockAndPreviewsWidth)
      }
      return defaultOpeningWidth
    }

    static func defaultHeight() -> CGFloat {
      if let screenHeight = NSScreen.main?.visibleFrame.height {
        return screenHeight * defaultPercentHeight
      }
      return defaultOpeningHeight
    }

    static func maxWelcomeWidth() -> CGFloat {
      if let screenWidth = NSScreen.main?.visibleFrame.width {
        return screenWidth * 0.66
      }
      return minWelcomeWidth
    }

    static func maxWelcomeHeight() -> CGFloat {
      if let screenHeight = NSScreen.main?.visibleFrame.height {
        return screenHeight * 0.8
      }
      return minWelcomeHeight
    }

    static func maxDocumentWidth() -> CGFloat {
      if let screenWidth = NSScreen.main?.visibleFrame.width {
        return screenWidth - dockAndPreviewsWidth
      }
      return defaultOpeningWidth
    }

    static func maxDocumentHeight() -> CGFloat {
      if let screenHeight = NSScreen.main?.visibleFrame.height {
        return screenHeight - heightMargin
      }
      return defaultOpeningHeight
    }
  }

  var body: some Scene {
    WindowGroup {
      if shouldShowWelcomeWhenStartingUp {
        WelcomeView()
          .environmentObject(appState)
          .onAppear {
            NSWindow.allowsAutomaticWindowTabbing = false
          }
      } else {
        ContentView(doc: defaultDocument)
          .background(WindowAccessor { window in
            if let window = window {
              let uniqueIdentifier = defaultDocument.picdef.id
              window.setFrameAutosaveName("Document Window \(uniqueIdentifier.uuidString)")
            }
          })
          .onAppear {
            NSWindow.allowsAutomaticWindowTabbing = false
          }
      }
    }

    DocumentGroup(newDocument: { MandArtDocument() }) { file in
      let doc = file.document
      ContentView(doc: doc)
        .background(WindowAccessor { window in
          if let window = window {
            let uniqueIdentifier = doc.picdef.id
            window.setFrameAutosaveName("Document Window \(uniqueIdentifier.uuidString)")
          }
        })
        .onAppear {
          NSWindow.allowsAutomaticWindowTabbing = false
        }
    } // DG

    .commands {
      appMenuCommands()
    }
  }
}
