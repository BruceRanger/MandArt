/**
  WelcomeView.swift
  MandArt
 */
import SwiftUI
import AppKit

let windowHeight: CGFloat = 550
let windowWidth: CGFloat = 667

@available(macOS 11.0, *)
struct WelcomeView: View {
  var body: some View {
    VStack(spacing: 0) {
      WelcomeTitleView()
      WelcomeContentView()
      Spacer()
    }
    .padding()
    .frame(minWidth: windowWidth, minHeight: windowHeight)
    .background(Color(.windowBackgroundColor))
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(
      GeometryReader { geometry in
        Color.clear
          .preference(key: ViewSizeKey.self, value: geometry.size)
      }
    )
    .onPreferenceChange(ViewSizeKey.self) { size in
      updateWindowFrame(with: size)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }

  private func updateWindowFrame(with size: CGSize) {
    // Code to update window frame based on size
  }
}

@available(macOS 11.0, *)
struct WelcomeTitleView: View {
  var body: some View {
    VStack(spacing: 10) {
      Text("Welcome to MandArt")
        .font(.title)
        .fontWeight(.bold)
      Text("   ")
        .font(.headline)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}

@available(macOS 11.0, *)
struct WelcomeContentView: View {
  var body: some View {
    WelcomeImage()
    WelcomeDescription()
      .padding()
  }
}

@available(macOS 11.0, *)
struct WelcomeImage: View {
  @State private var scale: CGFloat = 1
  @State private var angle: Double = 0

  var body: some View {
    Image("Welcome")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(height: windowHeight / 2)
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

@available(macOS 11.0, *)
struct WelcomeDescription: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("MandArt is the ultimate app for creating custom art from the Mandelbrot set.")
        .font(.title3)
        .foregroundColor(.primary)
      Text("Find an interesting location (e.g., where two black areas meet), zoom in and out, and customize the coloring. Nearby colors flow into one another, so check their gradients to see how the intermediate colors appear. If you'll print your art, choose from colors more likely to print true.")
        .foregroundColor(.secondary)
      Button(action: {
        NSApp.sendAction(#selector(NSWindow.performClose(_:)), to: nil, from: nil)
        NSDocumentController.shared.newDocument("new.mandart")
      }) {
        Text("Get started")
          .fontWeight(.semibold)
      }
      .buttonStyle(.bordered)
      .controlSize(.large)
    }
  }
}

@available(macOS 11.0, *)
struct ViewSizeKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

