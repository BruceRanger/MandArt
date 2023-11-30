import AppKit // keypress
import CoreGraphics // for image scrollview?
import Foundation // trig functions
import SwiftUI // views
import UniformTypeIdentifiers

// Global variable to hold a reference to the CGImage used across the app
var contextImageGlobal: CGImage?

/// `ContentView` is the main view of the MandArt application, available on macOS 12.0 and later.
/// It provides the user interface for interacting with the Mandelbrot set art generation features of the app.
@available(macOS 12.0, *)
struct ContentView: View {
  @EnvironmentObject var appState: AppState
  @ObservedObject var doc: MandArtDocument
  @StateObject var popupManager = PopupManager()
  @State var requiresFullCalc = true
  @State var showGradient: Bool = false

  @State private var moved: Double = 0.0
  @State private var startTime: Date?
  @State private var previousPicdef: PictureDefinition?
  @State private var textFieldImageHeight: NSTextField = .init()
  @State private var textFieldY: NSTextField = .init()
  private let widthOfInputPanel: CGFloat = 400

  var body: some View {
    GeometryReader { _ in

      HStack(spacing: 0) {
        PanelUI(
          doc: doc,
          popupManager: popupManager,
          requiresFullCalc: $requiresFullCalc,
          showGradient: $showGradient
        )
        .frame(width: widthOfInputPanel)
        .fixedSize(horizontal: true, vertical: false)

        PanelDisplay(doc: doc, requiresFullCalc: $requiresFullCalc, showGradient: $showGradient)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      .overlay(
        ContentViewPopups(doc: doc, popupManager: popupManager, requiresFullCalc: $requiresFullCalc)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.leading, 0)
    } // geo
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  } // body
}
