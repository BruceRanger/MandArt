import AppKit // keypress
import Foundation // trig functions
import SwiftUI // views
import UniformTypeIdentifiers
import CoreGraphics // for image scrollview?

var contextImageGlobal: CGImage?

enum ActiveDisplayChoice {
  case MandArt
  case Gradient
  case Colors
}

@available(macOS 12.0, *)
struct ContentView: View {

  @EnvironmentObject var appState: AppState
  @ObservedObject var doc: MandArtDocument
  @StateObject var popupManager = PopupManager()
  @State var activeDisplayState: ActiveDisplayChoice = .MandArt

  @State private var moved: Double = 0.0
  @State private var startTime: Date?
  @State private var previousPicdef: PictureDefinition?
  @State private var textFieldImageHeight: NSTextField = .init()
  @State private var textFieldY: NSTextField = .init()
  private let widthOfInputPanel: CGFloat = 400

  var body: some View {

    GeometryReader { _ in

      HStack(spacing: 0) {

        PanelUI(doc: doc, popupManager: popupManager, activeDisplayState: $activeDisplayState)
          .frame(width: widthOfInputPanel)
          .fixedSize(horizontal: true, vertical: false)

        PanelDisplay(doc: doc, activeDisplayState: $activeDisplayState)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

      .overlay(
        ContentViewPopups(doc: doc, popupManager: popupManager, activeDisplayState: $activeDisplayState)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.leading, 0)
      .onAppear {
        activeDisplayState = .MandArt
      }

    } // geo
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  } // body
}
