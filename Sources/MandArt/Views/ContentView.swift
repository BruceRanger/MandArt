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
 

  /**
   Gets an image to display on the right side of the app

   - Returns: An optional CGImage or nil
   */
  func getImage() -> CGImage? {
    var colors: [[Double]] = self.doc.picdef.hues.map { [$0.r, $0.g, $0.b] }

    switch activeDisplayState {
      case .MandArt:
        let art = ArtImage(picdef: self.doc.picdef)
        let img = art.getPictureImage(colors: &colors)
        return img
      case .Gradient:
        if leftGradientIsValid {
          return getGradientImage()
        }
        return nil
      case .Colors:
        let art = ArtImage(picdef: self.doc.picdef)
        let img = art.getColorImage(colors: &colors)
        return img
    }
  }

  func getGradientImage() -> CGImage? {
    print("getGradientImage")
    let leftNumber = self.doc.picdef.leftNumber
    let rightNumber = calculatedRightNumber

    guard let leftColorRGBArray = self.doc.picdef.getColorGivenNumberStartingAtOne(leftNumber) else {
      return nil // Handle the error case properly
    }
    guard let rightColorRGBArray = self.doc.picdef.getColorGivenNumberStartingAtOne(rightNumber) else {
      return nil // Handle the error case properly
    }

    let gradientParameters = GradientImage.GradientImageInputs(
      imageWidth: self.doc.picdef.imageWidth,
      imageHeight: self.doc.picdef.imageHeight,
      leftColorRGBArray: leftColorRGBArray,
      rightColorRGBArray: rightColorRGBArray,
      gradientThreshold: self.doc.picdef.yY
    )

    return GradientImage.createCGImage(using: gradientParameters)
  }


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

        GeometryReader { geometry in
          ScrollView(showsIndicators: true) {
            Text("MandArt")
              .font(.title)
              TabbedView(doc:doc, activeDisplayState: $activeDisplayState)
          }
        } // end input scoll bar geometry reader

        ChoosePopupView(doc:doc)

        HStack {
          Button("Add New Color") { doc.addHue() }
            .help("Add a new color.")
            .padding([.bottom], 2)
        }

        ColorListView(doc:doc, activeDisplayState:$activeDisplayState)

      } // end VStack for user instructions, rest is 2nd col
      .frame(width: inputWidth)
      .padding(2)

      // SECOND COLUMN - VSTACK - IS FOR IMAGES

      // RIGHT COLUMN IS FOR IMAGES......................

      ScrollView(showsIndicators: true) {
        VStack {
          if activeDisplayState == .MandArt {

            let image: CGImage = getImage()!
            GeometryReader {_ in
              ZStack(alignment: .topLeading) {
                
                ScrollView([.horizontal, .vertical]) {
                    Image(image, scale: 1.0, label: Text("Test"))
                    .gesture(self.tapGesture)

                }
                .frame(width: MandArtApp.AppConstants.defaultWidth(), height: MandArtApp.AppConstants.defaultHeight(), alignment: .topLeading)
              }
            }

          } else if activeDisplayState == ActiveDisplayChoice.Gradient {
            let image: CGImage = getImage()!
            GeometryReader { _ in
              ZStack(alignment: .topLeading) {
                Image(image, scale: 1.0, label: Text("Test"))
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
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  popupViewModel.showingAllColorsPopups[iAll!] = false
                }) {
                  Image(systemName: "xmark.circle")
                }
                VStack {
                  let arrCGs = MandMath.getAllCGColorsList(iSort: iAll!)
                  let arrColors = arrCGs.map { cgColor in
                    Color(cgColor)
                  }
                  let nColumns = 32  //64
                  let nRows = arrColors.count / nColumns
                  ForEach(0 ..< nRows) { rowIndex in
                    HStack(spacing: 0) {
                      ForEach(0 ..< nColumns) { columnIndex in
                        let index = rowIndex * nColumns + columnIndex
                        Rectangle()
                          .fill(arrColors[index])
                          .frame(width: 17, height: 27)
                          .cornerRadius(4)
                          .padding(1)
                      }
                    }
                  }
                } // end VStack of color options
                Spacer()
              } // end VStack
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(radius: 10)
              .padding()
            } // end ZStack for popup
            .transition(.scale)
          } // end if popup

          // IF USER WANTED TO SEE ALL PRINTABLE COLORS
          // WITH PLACEHOLDERS

          if iAP != nil {
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  popupViewModel.showingAllPrintableColorsPopups[iAP!] = false
                }) {
                  Image(systemName: "xmark.circle")
                }
                VStack {
                  let arrCGs = MandMath.getAllPrintableCGColorsList(iSort: iAP!)
                  let arrColors = arrCGs.map { cgColor in
                    Color(cgColor)
                  }
                  let nColumns = 32 //64
                  let nRows = arrColors.count / nColumns
                  ForEach(0 ..< nRows) { rowIndex in
                    HStack(spacing: 0) {
                      ForEach(0 ..< nColumns) { columnIndex in
                        let index = rowIndex * nColumns + columnIndex
                        Rectangle()
                          .fill(arrColors[index])
                          .frame(width: 17, height: 27)
                          .cornerRadius(4)
                          .padding(1)
                      }
                    }
                  }
                } // end VStack of color options
                Spacer()
              } // end VStack
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(radius: 10)
              .padding()
            } // end ZStack for popup
            .transition(.scale)
          } // end if popup

          // IF USER WANTED TO SEE ONLY PRINTABLE COLORS
          // * WITHOUT * PLACEHOLDERS

          if iP != nil {
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  popupViewModel.showingPrintableColorsPopups[iP!] = false
                }) {
                  Image(systemName: "xmark.circle")
                }
                VStack {
                  let arrCGs = MandMath.getPrintableCGColorListSorted(iSort: iP!)
                  let arrColors = arrCGs.map { cgColor in
                    Color(cgColor)
                  }

                  let nColumns = 32
                  ForEach(0 ..< arrColors.count / nColumns) { rowIndex in
                    HStack(spacing: 0) {
                      ForEach(0 ..< 32) { columnIndex in
                        let index = rowIndex * nColumns + columnIndex
                        let color = arrColors[index]
                        let nsColor = NSColor(color)
                        let red = nsColor.redComponent
                        let green = nsColor.greenComponent
                        let blue = nsColor.blueComponent

                        let colorValueR = "\(Int(red * 255))"
                        let colorValueG = "\(Int(green * 255))"
                        let colorValueB = "\(Int(blue * 255))"

                        VStack {
                          Rectangle()
                            .fill(arrColors[index])
                            .frame(width: 30, height: 30)
                            .cornerRadius(4)
                            .padding(1)

                          Text(colorValueR)
                            .font(.system(size: 10))
                            .background(Color.white)
                          Text(colorValueG)
                            .font(.system(size: 10))
                            .background(Color.white)
                          Text(colorValueB)
                            .font(.system(size: 10))
                            .background(Color.white)
                        } // end Zstack of rect, rgb values
                      } // end for each column of colors
                    } // end HStack of colors
                  } // end for each color
                } // end VStack of color options
                Spacer()
              } // end VStack
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(radius: 10)
              .padding()
            } // end ZStack for popup
            .transition(.scale)
          } // end if popup
        } // end VStack right side (picture space)
        .padding(2)
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
        if (self.activeDisplayState == .MandArt){
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

  // HELPER FUNCTIONS ..................................

  // Save the image inputs to a file.
  func saveMandArtImageInputs() {
    let winTitle = doc.getCurrentWindowTitle()
    let justname = winTitle.replacingOccurrences(of: ".mandart", with: "")
    let fname = justname + ".mandart"
    var data: Data
    do {
      //     data = try JSONEncoder().encode(doc.picdef)
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      data = try encoder.encode(doc.picdef)
    } catch {
      print("Error encoding picdef.")
      print("Closing all windows and exiting with error code 98.")
      NSApplication.shared.windows.forEach { $0.close() }
      NSApplication.shared.terminate(nil)
      exit(98)
    }
    if data == Data() {
      print("Error encoding picdef.")
      print("Closing all windows and exiting with error code 99.")
      NSApplication.shared.windows.forEach { $0.close() }
      NSApplication.shared.terminate(nil)
      exit(99)
    }

    // trigger state change to force a current image
    doc.picdef.imageHeight += 1
    doc.picdef.imageHeight -= 1

    var currImage = contextImageGlobal!
    let savePanel = NSSavePanel()
    savePanel.title = "Choose directory and name for image inputs file"
    savePanel.nameFieldStringValue = fname
    savePanel.canCreateDirectories = true
    savePanel.allowedContentTypes = [UTType.json, UTType.mandartDocType]
    savePanel.begin { (result) in
      if result == .OK {
        do {
          try data.write(to: savePanel.url!)
        } catch {
          print("Error saving file: \(error.localizedDescription)")
        }
        print("Image inputs saved successfully to \(savePanel.url!)")
      } else {
        print("Error saving image inputs")
      }
    }
  }



}



