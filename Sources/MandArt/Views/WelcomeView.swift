import AppKit
import SwiftUI

@available(macOS 11.0, *)
enum Constants {
  static let windowHeight: CGFloat = 550
  static let windowWidth: CGFloat = 667
  static let imageHeightFactor: CGFloat = 0.6
  static let descriptionHeightFactor: CGFloat = 0.4
}

@available(macOS 11.0, *)
struct WelcomeView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack(spacing: 0) {
      WelcomeHeaderView()
      WelcomeMainView()
      Spacer()
    }
    .frame(maxWidth: .infinity) // HStack-like for horizontal centering
    .padding()
    .frame(minWidth: Constants.windowWidth, minHeight: Constants.windowHeight)
    .background(Color(.windowBackgroundColor))
    .ignoresSafeArea()
    .overlay(
      GeometryReader { geometry in
        Color.clear
          .preference(key: ViewSizeKey.self, value: geometry.size)
      }
    )
    .onPreferenceChange(ViewSizeKey.self) { size in
      updateWindowFrame(with: size)
    }
  }

  private func updateWindowFrame(with _: CGSize) {
    // Code to update window frame based on size
  }

  var screenSize: CGSize {
    // Fetching the main screen's size
    guard let screen = NSScreen.main else {
      return CGSize(width: Constants.windowWidth, height: Constants.windowHeight)
    }
    return screen.frame.size
  }
}

@available(macOS 11.0, *)
struct ViewSizeKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}
