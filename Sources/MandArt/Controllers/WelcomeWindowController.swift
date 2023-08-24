import SwiftUI
import AppKit

class WelcomeWindowController: NSWindowController {
  init() {
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .resizable],
      backing: .buffered, defer: false)

    super.init(window: window)

    window.center()
    window.setFrameAutosaveName("Welcome Window")
    window.contentView = NSHostingView(rootView: WelcomeView())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
