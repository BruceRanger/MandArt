import AppKit
import SwiftUI

/// View for the welcome screen main content (all but the header).
@available(macOS 11.0, *)
struct WelcomeMainView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        WelcomeMainImageView()
          .frame(height: geometry.size.height * Constants.imageHeightFactor)

        WelcomeMainInformationView(showWelcomeScreen: appState.shouldShowWelcomeWhenStartingUp)
          .frame(maxHeight: .infinity) // all  vertical space
          .padding()
      }
    }
  }
}
