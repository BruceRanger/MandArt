/**
  WelcomeView.swift
  MandArt
 */

import SwiftUI
import AppKit

// set window size constants

let h: CGFloat = 550
let w: CGFloat = 667

@available(macOS 11.0, *)
struct WelcomeView: View {

  var body: some View {

    VStack(spacing: 0) {
      WelcomeTitleView()
      WelcomeContentView()
      Spacer()
    }
    .padding()
    .frame(minWidth: w, minHeight: h)
    .background(Color.white)
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay(
      GeometryReader { geometry in
        Color.clear
          .preference(key: ViewSizeKey.self, value: geometry.size)
      }
    )
    .onPreferenceChange(ViewSizeKey.self) { size in
      let width = size.width
      let height = size.height
      let window = NSApplication.shared.windows.first
      let screenRect = NSScreen.main?.frame ?? .zero
      let center = CGPoint(x: screenRect.midX, y: screenRect.midY)
      let newFrame = NSRect(x: center.x - width / 2, y: center.y - height / 2, width: width, height: height)
      window?.setFrame(newFrame, display: true)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
  }

}

@available(macOS 10.15, *)
struct WelcomeTitleView: View {
  var body: some View {
    VStack( spacing: 10) {
      Text("Welcome to MandArt")
        .font(.title)
        .fontWeight(.bold)
      Text("Version 0.1 (beta)")
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

@available(macOS 10.15, *)
struct WelcomeImage: View {
  @State private var scale: CGFloat = 1
  @State private var angle: Double = 0


/**
 Get the highest resolution application icon image (for use on the welcome screen).
 */
  func getAppIconImage() -> NSImage? {
    guard let iconData = NSApplication.shared.applicationIconImage.tiffRepresentation as NSData?,
          let icon = NSImage(data: iconData as Data),
          let representation = NSBitmapImageRep(data: iconData as Data),
          let cgImage = representation.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
      return nil
    }
    let size = CGSize(width: cgImage.width, height: cgImage.height)
    return NSImage(cgImage: cgImage, size: size)
  }


  var body: some View {

   //Image(nsImage: NSApp.applicationIconImage)
    Image(nsImage: getAppIconImage()!)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(height: h/2)
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
      Text("Find an interesting location (e.g., where two black areas meet), zoom in and out, and customize the coloring. Nearby colors flow into one another, so check their gradients to see how the intermediate colors  appear. If you'll print your art, choose from colors more likely to print true.")
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

@available(macOS 10.15, *)
struct ViewSizeKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}




