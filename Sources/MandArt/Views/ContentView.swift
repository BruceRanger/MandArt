/**
 ContentView.swift
 MandArt

 The main view in the MandArt project, responsible for displaying the user interface.

 Created by Bruce Johnson on 9/20/21.
 Revised and updated 2021-2023
 All rights reserved.
 */

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
  @EnvironmentObject var doc: MandArtDocument
  @ObservedObject var popupViewModel = PopupViewModel()

  internal var leftGradientIsValid: Bool {
    var isValid = false
    let leftNum = doc.picdef.leftNumber
    let lastPossible = doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  internal var calculatedRightNumber: Int {
    if leftGradientIsValid, doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  // set width of the first column (user inputs)
  let inputWidth: Double = 380

  @State private var moved: Double = 0.0
  @State private var startTime: Date?
  @State private var activeDisplayState = ActiveDisplayChoice.MandArt
  @State private var previousPicdef: PictureDefinition?

  @State private var textFieldImageHeight: NSTextField = .init()
  @State private var textFieldY: NSTextField = .init()

   // To swap a GeometryReader for an Image on button click in SwiftUI,
  // you can use a state variable to keep track of
  // what should be displayed,
  // and change this state variable when buttons are pressed.
  var body: some View {
    HStack(alignment: .top, spacing: 1) {
      // instructions on left, picture on right
      // Left (first) VStack is left side with user stuff
      // Right (second) VStack is for mandart, gradient, or colors
      // Sspacing is between VStacks (the two columns)

      // FIRST COLUMN - VSTACK IS FOR INSTRUCTIONS
      VStack(alignment: .center, spacing: 5) {

        GeometryReader { _ in
          ScrollView(showsIndicators: true) {
            Text("MandArt")
              .font(.title)
              TabbedView(doc: doc, activeDisplayState: $activeDisplayState)
          }
        } // end input scoll bar geometry reader

      } // end VStack for user instructions, rest is 2nd col
      .frame(width: inputWidth)
      .padding(2)

      // SECOND COLUMN - VSTACK - IS FOR IMAGES

      // RIGHT COLUMN IS FOR IMAGES......................

      ScrollView(showsIndicators: true) {
        VStack(alignment: .leading) {
          if activeDisplayState == .MandArt {

            let viewModel = ImageViewModel(doc: doc, activeDisplayState: $activeDisplayState)

            GeometryReader { _ in
              ZStack(alignment: .topLeading) {
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                  if let cgImage = viewModel.getImage() {
                    Image(decorative: cgImage, scale: 1.0)
                      .resizable()
                      .frame(width: CGFloat(cgImage.width), alignment: .topLeading)
                      .gesture(self.tapGesture)
                  } else {
                    Text("No Image Available")
                      .foregroundColor(.gray)
                  }
                } // scrollview
              } // zstack
            } // geo reader

            .frame(width: MandArtApp.AppConstants.defaultWidth(), height: MandArtApp.AppConstants.defaultHeight(), alignment: .topLeading)

          } else if activeDisplayState == ActiveDisplayChoice.Gradient {
            let viewModel = ImageViewModel(doc: doc, activeDisplayState: $activeDisplayState)
            GeometryReader { _ in
              ZStack(alignment: .topLeading) {
                if let cgImage = viewModel.getImage() {
                  Image(decorative: cgImage, scale: 1.0)
                    .resizable()
                    .frame(width: CGFloat(cgImage.width), alignment: .topLeading)
                    .gesture(self.tapGesture)
                } else {
                  Text("No Image Available")
                    .foregroundColor(.gray)
                }

              }
            }
          }

          // User will click buttons on the user input side
          // of the main screen, but we'll show the colors on the
          // right side of the main screen (here)

          // this checks to see which button the user clicked
          // it will set one of the following to "true"
          // and that's the one we'll show.

          // There are six of each - depending on the sort order
          // for example
          // RGB is the first (index = 0)
          // RBG (blue & green reversed) is the second or index 1

          // THere are 3 buttons for each color sort order (e.g. RGB)
          // ALL screen colors
          // ALL PRINTABLE colors (uses white squares as placeholders)
          // just the PRINTABLE colors (no white square placeholders)
          let iAll = popupViewModel.showingAllColorsPopups.firstIndex(of: true)
          let iAP = popupViewModel.showingAllPrintableColorsPopups.firstIndex(of: true)
          let iP = popupViewModel.showingPrintableColorsPopups.firstIndex(of: true)

          // IF USER WANTED TO SEE ALL SCREEN COLORS
          if iAll != nil {
            PopupAllColors( popupViewModel: popupViewModel)
          }

          // IF USER WANTED TO SEE ALL PRINTABLE COLORS WITH PLACEHOLDERS
          if iAP != nil {
            PopupAllPrintableColors(popupViewModel: popupViewModel)
          }

          // ONLY PRINTABLE COLORS WITHOUT PLACEHOLDERS
          if iP != nil {
            PopupPrintableColors(popupViewModel: popupViewModel)
          }

        } // end VStack right side (picture space)
        .padding(2)
        Spacer()
      } // end image scroll view
      .padding(2)

    } // end Opening HStack
    .onAppear {
      activeDisplayState = .MandArt
    }
  } // end view body

  /**
   tapGesture is a variable that defines a drag gesture
   for the user interaction in the user interface.

   The gesture is of type some Gesture
   and uses the DragGesture struct from the SwiftUI framework.

   The minimum distance for the drag gesture is set to 0 units,
   and the coordinate space for the gesture is set to .local.

   The onChanged closure is triggered
   when the gesture is changed by the user's interaction.

   The onEnded closure is triggered
   when the user lifts the mouse off the screen,
   indicating the tap gesture has completed.
   */
  var tapGesture: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { value in
        if self.activeDisplayState == .MandArt {
          // store distance the touch has moved as a sum of all movements
          self.moved += value.translation.width + value.translation.height
          // only set the start time if it's the first event
          if self.startTime == nil {
            self.startTime = value.time
          }
        }
      }
      .onEnded { tap in
        if self.activeDisplayState == .MandArt {
          // if we haven't moved very much, treat it as a tap event
          if self.moved < 2, self.moved > -2 {
            doc.picdef.xCenter = getCenterXFromTap(tap)
            doc.picdef.yCenter = getCenterYFromTap(tap)
            activeDisplayState = .MandArt // redraw after new center
          }
          // if we have moved a lot, treat it as a drag event
          else {
            doc.picdef.xCenter = getCenterXFromDrag(tap)
            doc.picdef.yCenter = getCenterYFromDrag(tap)
            activeDisplayState = .MandArt // redraw after drag
          }
          // reset tap event states
          self.moved = 0
          self.startTime = nil
        }
      }
  } // end tapGesture

}
