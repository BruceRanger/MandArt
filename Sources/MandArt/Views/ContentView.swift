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

  let widthOfInputPanel: Double = 400

  var body: some View {
    GeometryReader { geometry in
      HStack(alignment: .top, spacing: 0)  {
        PanelUI(doc: doc,
                popupManager: popupManager,activeDisplayState: $activeDisplayState)
          .frame(width: widthOfInputPanel)

        PanelDisplay(doc: doc, activeDisplayState: $activeDisplayState)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } // hstack
//      .overlay(
//        ZStack {
//          // Popup background with corner radius
//          RoundedRectangle(cornerRadius: 10)
//            .fill(Color.white)
//
//          VStack {
//            // Custom close button at the top
//            Button(action: {
//              // Close action
//            }) {
//              Image(systemName: "xmark.circle.fill")
//                .font(.title)
//                .foregroundColor(.gray)
//            }
//            .padding(.top, 10)
//
//            ScrollView {
//              // Your popup content here
//            }
//          }
//          .padding()
//        }
//          .frame(maxWidth: .infinity, maxHeight: .infinity)
//      )

      .overlay(
        ScrollView {

            if popupManager.showingAllColorsPopups[0] {
              PopupAllColors(iAll: $popupManager.iAll,
                             showingAllColorsPopups: $popupManager.showingAllColorsPopups)
            }

            else if popupManager.showingAllPrintableColorsPopups[0] {
              PopupAllPrintableColors(iAP: $popupManager.iAP,
                                      showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
            }

            else if popupManager.showingPrintableColorsPopups[0] {
              PopupPrintableColors(iP: $popupManager.iP,
                                   showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
            }


            else if popupManager.showingAllColorsPopups[1] {
              PopupAllColors(iAll: $popupManager.iAll,
                             showingAllColorsPopups: $popupManager.showingAllColorsPopups)
            }

            else if popupManager.showingAllPrintableColorsPopups[1] {
              PopupAllPrintableColors(iAP: $popupManager.iAP,
                                      showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
            }

            else if popupManager.showingPrintableColorsPopups[1] {
              PopupPrintableColors(iP: $popupManager.iP,
                                   showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
            }


            else if popupManager.showingAllColorsPopups[2] {
              PopupAllColors(iAll: $popupManager.iAll,
                             showingAllColorsPopups: $popupManager.showingAllColorsPopups)
            }

            else if popupManager.showingAllPrintableColorsPopups[2] {
              PopupAllPrintableColors(iAP: $popupManager.iAP,
                                      showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
            }

            else if popupManager.showingPrintableColorsPopups[2] {
              PopupPrintableColors(iP: $popupManager.iP,
                                   showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
            }

            else if popupManager.showingAllColorsPopups[3] {
              PopupAllColors(iAll: $popupManager.iAll,
                             showingAllColorsPopups: $popupManager.showingAllColorsPopups)
            }

            else if popupManager.showingAllPrintableColorsPopups[3] {
              PopupAllPrintableColors(iAP: $popupManager.iAP,
                                      showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
            }

            else if popupManager.showingPrintableColorsPopups[3] {
              PopupPrintableColors(iP: $popupManager.iP,
                                   showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
            }

            else if popupManager.showingAllColorsPopups[4] {
              PopupAllColors(iAll: $popupManager.iAll,
                             showingAllColorsPopups: $popupManager.showingAllColorsPopups)
            }

            else if popupManager.showingAllPrintableColorsPopups[4] {
              PopupAllPrintableColors(iAP: $popupManager.iAP,
                                      showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
            }

            else if popupManager.showingPrintableColorsPopups[4] {
              PopupPrintableColors(iP: $popupManager.iP,
                                   showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
            }



            else if popupManager.showingAllColorsPopups[5] {
              PopupAllColors(iAll: $popupManager.iAll,
                             showingAllColorsPopups: $popupManager.showingAllColorsPopups)
            }

            else if popupManager.showingAllPrintableColorsPopups[5] {
              PopupAllPrintableColors(iAP: $popupManager.iAP,
                                      showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
            }

            else  if popupManager.showingPrintableColorsPopups[5] {
              PopupPrintableColors(iP: $popupManager.iP,
                                   showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
            }




        }
          .edgesIgnoringSafeArea(.top) // Cover entire window
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
