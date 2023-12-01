import AppKit
import SwiftUI

/// View for the welcome screen header
@available(macOS 11.0, *)
struct WelcomeHeaderView: View {
  var body: some View {
    VStack(spacing: 10) {
      Text("Welcome to MandArt")
        .font(.title)
        .fontWeight(.bold)
      Spacer().frame(height: 10)
    }
    .padding()
  }
}
