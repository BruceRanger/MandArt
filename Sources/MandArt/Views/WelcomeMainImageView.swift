import AppKit
import SwiftUI

/// View for the welcome screen image.
@available(macOS 11.0, *)
struct WelcomeMainImageView: View {
  @State private var scale: CGFloat = 1
  @State private var angle: Double = 0

  var body: some View {
    Image("Welcome")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(height: Constants.windowHeight / 2)
      .cornerRadius(20)
      .scaleEffect(scale)
      .rotationEffect(.degrees(angle))
      .onAppear {
        angle = -10
        withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 50, damping: 5, initialVelocity: 0)) {
          angle = 10
          scale = 1.1
        }
        withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 50, damping: 10, initialVelocity: 0)) {
          angle = -5
          scale = 0.9
        }

        withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 50, damping: 10, initialVelocity: 0)) {
          angle = 0
          scale = 1.0
        }
      }
  }
}
