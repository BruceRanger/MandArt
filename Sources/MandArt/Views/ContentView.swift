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

@available(macOS 12.0, *)
struct ContentView: View {
  @EnvironmentObject var doc: MandArtDocument

  // set width of the first column (user inputs)
  let inputWidth: Double = 380

  @State private var moved: Double = 0.0
  @State private var startTime: Date?
  @State private var activeDisplayState = ActiveDisplayChoice.MandArt
  @State private var previousPicdef: PictureDefinition?

  @State private var textFieldImageHeight: NSTextField = .init()
  @State private var textFieldY: NSTextField = .init()
  @State private var showingAllColorsPopups = Array(repeating: false, count: 6)
  @State private var showingPrintableColorsPopups = Array(repeating: false, count: 6)
  @State private var showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
  @State private var showingPrintablePopups = Array(repeating: false, count: 100)

  enum ActiveDisplayChoice {
    case MandArt
    case Gradient
    case Colors
  }

  func showMandArtBitMap() {

  }


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
        if self.leftGradientIsValid {
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
        // Wrap in GEOMETRY READER TO GAIN SPACE FROM COLORS

        GeometryReader { geometry in

          ScrollView(showsIndicators: true) {
            Text("MandArt")
              .font(.title)

            //  GROUP 1 -  BASICS

            GroupBasicsView(doc: doc)

            //  GROUP 2 IMAGE SIZE

            Group {
              //  Show Row (HStack) of Image Size Next

              HStack {
                VStack {

                  Text("Image")
                  Text("width, px:")
                  Text("(imageWidth)")
                  DelayedTextFieldInt(
                    placeholder: "1100",
                    value: $doc.picdef.imageWidth,
                    formatter: MAFormatters.fmtImageWidthHeight
                  ) {
                    showMandArtBitMap() // on lose focus
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 80)
                  .help("Enter the width, in pixels, of the image.")
                }

                VStack {
                  Text("Image")
                  Text("height, px")
                  Text("(imageHeight)")
                  DelayedTextFieldInt(
                    placeholder: "1000",
                    value: $doc.picdef.imageHeight,
                    formatter: MAFormatters.fmtImageWidthHeight
                  ) {
                    showMandArtBitMap()
                  }
                  .frame(maxWidth: 80)
                  .help("Enter the height, in pixels, of the image.")
                }


                VStack {
                  Text("Aspect")
                  Text("ratio:")

                  Text("\(aspectRatio)")
                    .padding(1)
                    .help("Calculated value of image width over image height.")
                }
              }

              Divider()
            } // END GROUP 2 IMAGE SIZE

            //  GROUP 3 X, Y and Scale

            VStack {
              //  Show Row (HStack) of x, y

              HStack {
                VStack { // each input has a vertical container with a Text label & TextField for data
                  Text("Enter center x")
                  Text("Between -2 and 2")
                  Text("(xCenter)")
                  DelayedTextFieldDouble(
                    placeholder: "-0.75",
                    value: $doc.picdef.xCenter,
                    formatter: MAFormatters.fmtXY
                  ) {
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .padding(4)
                  .frame(maxWidth: 170)
                  .help(
                    "Enter the x value in the Mandelbrot coordinate system for the center of the image."
                  )
                }

                VStack { // each input has a vertical container with a Text label & TextField for data
                  Text("Enter center y")
                  Text("Between -2 and 2")
                  Text("(yCenter)")
                  DelayedTextFieldDouble(
                    placeholder:"0.0",
                    value: $doc.picdef.yCenter,
                    formatter: MAFormatters.fmtXY
                  ) {
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .padding(4)
                  .frame(maxWidth: 170)
                  .help(
                    "Enter the Y value in the Mandelbrot coordinate system for the center of the image."
                  )
                }
              } // end HStack for XY

              //  Show Row (HStack) of Scale Next

              HStack {
                VStack {
                  Text("Rotate (º)")
                  Text("(theta)")

                  DelayedTextFieldDouble(
                    placeholder:"0",
                    value: $doc.picdef.theta,
                    formatter: MAFormatters.fmtRotationTheta
                  ) {
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 60)
                  .help("Enter the angle to rotate the image counterclockwise, in degrees.")
                }

                VStack {
                  Text("Scale (scale)")
                  DelayedTextFieldDouble(
                    placeholder:"430",
                    value: $doc.picdef.scale,
                    formatter: MAFormatters.fmtScale
                  ) {
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 180)
                  .help("Enter the magnification of the image.")
                }

                VStack {
                  Text("Zoom")

                  HStack {
                    Button("+") { zoomIn() }
                      .help("Zoom in by a factor of two.")

                    Button("-") { zoomOut() }
                      .help("Zoom out by a factor of two.")
                  }
                }
              }

              Divider()

              HStack {
                Text("Sharpening (iterationsMax):")

                DelayedTextFieldDouble(
                  placeholder:"10,000",
                  value: $doc.picdef.iterationsMax,
                  formatter: MAFormatters.fmtSharpeningItMax
                ) {
                  showMandArtBitMap()
                }
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .help(
                  "Enter the maximum number of iterations for a given point in the image. A larger value will increase the resolution, but slow down the calculation."
                )
                .frame(maxWidth: 70)
              }
              .padding(.horizontal)

              HStack {
                Text("Color smoothing (rSqLimit):")

                DelayedTextFieldDouble(
                  placeholder:"400",
                  value: $doc.picdef.rSqLimit,
                  formatter: MAFormatters.fmtSmootingRSqLimit
                ) {
                  showMandArtBitMap()
                }
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 60)
                .help(
                  "Enter min value for square of distance from origin. A larger value will smooth the color gradient, but slow down the calculation."
                )
              }

              Divider()

              // Hold fraction with Slider
              HStack {
                Text("Hold fraction (yY)")
              }
              HStack {
                Text("0")
                Slider(value: $doc.picdef.yY, in: 0 ... 1, step: 0.1)
                  .help(
                    "Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient."
                  )
                Text("1")

                TextField(
                  "0",
                  value: $doc.picdef.yY,
                  formatter: MAFormatters.fmtHoldFractionGradient
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 50)
                .help(
                  "Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient."
                )
              }
              .padding(.horizontal)
              // END Hold fraction with Slider

              Divider()
            } // END GROUP 3 X, Y, SCALE

            // GROUP 4 - GRADIENT

            Group {
              //  Show Row (HStack) of Gradient Content Next

              HStack {
                Text("Draw gradient from color (leftNumber)")

                TextField(
                  "1",
                  value: $doc.picdef.leftNumber,
                  formatter: MAFormatters.fmtLeftGradientNumber
                )
                .frame(maxWidth: 30)
                .foregroundColor(leftGradientIsValid ? .primary : .red)
                .help("Select the color number for the left side of a gradient.")

                Text("to " + String(calculatedRightNumber))
                  .help("The color number for the right side of a gradient.")

                Button("Go") {
                  activeDisplayState = .Gradient
                }
                  .help("Draw a gradient between two adjoining colors.")
              }

              Divider()
            } // END GROUP 4 - GRADIENT

            // GROUP 5 - COLOR TUNING GROUP

            Group {
              Text("Coloring Options")

              Divider()

              Group { // NEAR FAR GROUP
                      // Spacing 1 with Slider
                Text("Spacing far from MiniMand (near to edge)")
                Text("(spacingColorFar)")
                HStack {
                  Text("1")

                  Slider(value: $doc.picdef.spacingColorFar, in: 1 ... 20, step: 1) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .accentColor(Color.blue)

                  Text("20")

                  TextField(
                    "5",
                    value: $doc.picdef.spacingColorFar,
                    formatter: MAFormatters.fmtSpacingNearEdge
                  ) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                  .help(
                    "Enter the value for the color spacing near the edges of the image, away from MiniMand."
                  )
                }

                // END  Slider

                // Spacing 2 with Slider
                Text("Spacing near to MiniMand (far from edge)")
                Text("(spacingColorNear)")
                HStack {
                  Text("5")

                  Slider(value: $doc.picdef.spacingColorNear, in: 5 ... 50, step: 5) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .accentColor(Color.blue)

                  Text("50")

                  TextField(
                    "15",
                    value: $doc.picdef.spacingColorNear,
                    formatter: MAFormatters.fmtSpacingFarFromEdge
                  ) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                }
                .padding(.horizontal)
                .help(
                  "Enter the value for the color spacing away from the edges of the image, near the MiniMand."
                )
                // END  Slider

                Divider()
              } // END NEAR FAR GROUP

              Group {
                // Min Iterations with Slider
                Text("Change in minimum iteration (dFIterMin)")
                HStack {
                  Text("-5")

                  Slider(value: $doc.picdef.dFIterMin, in: -5 ... 20, step: 1) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }

                  Text("20")

                  TextField(
                    "0",
                    value: $doc.picdef.dFIterMin,
                    formatter: MAFormatters.fmtChangeInMinIteration
                  ) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 60)
                }
                .padding(.horizontal)
                .help(
                  "Enter a value for the change in the minimum number of iterations in the image. This will change the coloring."
                )
                // END Min Iterations with Slider

                // nblocks with slider
                Text("Number of Color Blocks (nBlocks)")

                HStack {
                  Text("10")

                  Slider(value: Binding(
                    get: { Double(doc.picdef.nBlocks) },
                    set: { doc.picdef.nBlocks = Int($0) }
                  ), in: 10 ... 100, step: 10) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .accentColor(Color.green)

                  Text("100")

                  TextField(
                    "60",
                    value: $doc.picdef.nBlocks,
                    formatter: MAFormatters.fmtNBlocks
                  ) { isStarted in
                    if isStarted {
                      activeDisplayState = .Colors
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                }
                .padding(.horizontal)
                .help(
                  "Enter a value for the number of blocks of color in the image. Each block is the gradient between two adjacent colors. If the number of blocks is greater than the number of colors, the colors will be repeated."
                )

                Divider()
              } // END GROUP of last 2 slider inputs
            } // end GROUP 5 - COLOR TUNING GROUP
          } // end scroll bar
          .frame(height: geometry.size.height)
        } // end top scoll bar geometry reader
        .frame(
          minHeight: 200,
          maxHeight: .infinity
        )
        .fixedSize(horizontal: false, vertical: false)

        // GROUP FOR POPUPS BUTTONS AND VERIFY AND ADD NEW COLOR

        Group {
          // HSTACK START WITH RED
          HStack {
            Text("Rgb:")

            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[0] = true
            }
            .padding([.bottom], 2)

            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[0] = true
            }
            .padding([.bottom], 2)

            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[0] = true
            }
            .padding([.bottom], 2)

            Text("Rbg:")

            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[1] = true
            }
            .padding([.bottom], 2)

            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[1] = true
            }
            .padding([.bottom], 2)

            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[1] = true
            }
            .padding([.bottom], 2)
          } // END HSTACK START WITH RED

          // HSTACK START WITH GREEN

          HStack {
            Text("Grb:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[2] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[2] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[2] = true
            }
            .padding([.bottom], 2)
            Text("Gbr:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[3] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[3] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[3] = true
            }
            .padding([.bottom], 2)
          } // END HSTACK START WITH GREEN

          // HSTACK START WITH BLUE

          HStack {
            Text("Brg:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[4] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[4] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[4] = true
            }
            .padding([.bottom], 2)

            Text("Bgr:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[5] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[5] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[5] = true
            }
            .padding([.bottom], 2)
          } // END  HSTACK START WITH BLUE

          HStack {
            Button("Add New Color") { doc.addHue() }
              .help("Add a new color.")
              .padding([.bottom], 2)
          }
        } // END  GROUP FOR POPUPS BUTTONS AND VERIFY AND ADD NEW COLOR

        // Wrap the list in a geometry reader so it will
        // shrink when items are deleted
        GeometryReader { geometry in

          List {
            ForEach($doc.picdef.hues, id: \.num) { $hue in
              let i = hue.num - 1
              let isPrintable = getIsPrintable(color: $hue.wrappedValue.color, num: $hue.wrappedValue.num)

              HStack {
                TextField("number", value: $hue.num, formatter: MAFormatters.fmtIntColorOrderNumber)
                  .disabled(true)
                  .frame(maxWidth: 15)

                ColorPicker("", selection: $hue.color, supportsOpacity: false)
                  .onChange(of: hue.color) { newColor in
                    doc.updateHueWithColorPick(
                      index: i, newColorPick: newColor
                    )
                  }

                if !isPrintable {
                  Button {
                    self.showingPrintablePopups[i] = true
                  } label: {
                    Image(systemName: "exclamationmark.circle")
                      .foregroundColor(.blue)
                  }
                  .help("See printable options for " + "\(hue.num)")
                } else {
                  Button {
                    //
                  } label: {
                    Image(systemName: "exclamationmark.circle")
                  }
                  .hidden()
                  .disabled(true)
                }
                if self.showingPrintablePopups[i] {
                  ZStack {
                    Color.white
                      .opacity(0.5)

                    VStack {
                      Button(action: {
                        self.showingPrintablePopups[i] = false
                      }) {
                        Image(systemName: "xmark.circle")
                      }

                      VStack {
                        Text("This color may not print well.")
                        Text("See the instructions for options.")
                      } // end VStack of color options
                    } // end VStack
                    .frame(width: 150, height: 100)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 10)
                  } // end ZStack for popup
                  .transition(.scale)
                } // end if self.showingPrintablePopups[i]

                // enter red

                TextField("255", value: $hue.r, formatter: MAFormatters.fmt0to255) { isStarted in
                  if isStarted {
                    activeDisplayState = .Colors
                  }
                }
                .onChange(of: hue.r) { newValue in
                  doc.updateHueWithColorNumberR(
                    index: i, newValue: newValue
                  )
                }

                // enter green

                TextField("255", value: $hue.g, formatter: MAFormatters.fmt0to255) { isStarted in
                  if isStarted {
                    activeDisplayState = .Colors
                  }
                }
                .onChange(of: hue.g) { newValue in
                  doc.updateHueWithColorNumberG(
                    index: i, newValue: newValue
                  )
                }

                // enter blue

                TextField("255", value: $hue.b, formatter: MAFormatters.fmt0to255) { isStarted in
                  if isStarted {
                    activeDisplayState = .Colors
                  }
                }
                .onChange(of: hue.b) { newValue in
                  doc.updateHueWithColorNumberB(
                    index: i, newValue: newValue
                  )
                }

                Button(role: .destructive) {
                  doc.deleteHue(index: i)
                  updateHueNums()
                } label: {
                  Image(systemName: "trash")
                }
                .help("Delete " + "\(hue.num)")
              }
            } // end foreach
            .onMove { indices, hue in
              doc.picdef.hues.move(
                fromOffsets: indices,
                toOffset: hue
              )
              updateHueNums()
            }
          } // end list
          .frame(height: geometry.size.height)
        } // end color list geometry reader
        .frame(
          minHeight: 0,
          maxHeight: 220
        )
        .fixedSize(horizontal: false, vertical: false)

        // } // END COLOR LIST VSTACK
      } // end VStack for user instructions, rest is 2nd col
      .frame(width: inputWidth)
      .padding(2)

      // SECOND COLUMN - VSTACK - IS FOR IMAGES

      // RIGHT COLUMN IS FOR IMAGES......................

      ScrollView(showsIndicators: true) {
        VStack {
          if activeDisplayState == ActiveDisplayChoice.MandArt {

            let image: CGImage = getImage()!
            GeometryReader {_ in
              ZStack(alignment: .topLeading) {
                
                // WRAP THE IMAGE IN A SCROLLVIEW
                ScrollView([.horizontal, .vertical]) {
                  // THIS IS THE BITMAP IMAGE
                  
                  // Image 1200 x 1000 often needs scroll bars
                  Image(image, scale: 1.0, label: Text("Test"))
                    .resizable() // add for scroll?
                    .aspectRatio(contentMode: .fit) // add for scroll?
                    .gesture(self.tapGesture)

                  
                }  // END BITMAP SCROLLVIEW
                .frame(minWidth: 1200, minHeight: 1000)
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
          let iAll = showingAllColorsPopups.firstIndex(of: true)
          let iAP = showingAllPrintableColorsPopups.firstIndex(of: true)
          let iP = showingPrintableColorsPopups.firstIndex(of: true)

          // IF USER WANTED TO SEE ALL SCREEN COLORS
          if iAll != nil {
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  showingAllColorsPopups[iAll!] = false
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
                  showingAllPrintableColorsPopups[iAP!] = false
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
                  showingPrintableColorsPopups[iP!] = false
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



    } // end HStack
    .onAppear {
      showMandArtBitMap()
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
        // store distance the touch has moved as a sum of all movements
        self.moved += value.translation.width + value.translation.height
        // only set the start time if it's the first event
        if self.startTime == nil {
          self.startTime = value.time
        }
      }
      .onEnded { tap in
        // if we haven't moved very much, treat it as a tap event
        if self.moved < 2, self.moved > -2 {
          doc.picdef.xCenter = getCenterXFromTap(tap)
          doc.picdef.yCenter = getCenterYFromTap(tap)
          showMandArtBitMap() // redraw after new center
        }
        // if we have moved a lot, treat it as a drag event
        else {
          doc.picdef.xCenter = getCenterXFromDrag(tap)
          doc.picdef.yCenter = getCenterYFromDrag(tap)
          showMandArtBitMap() // redraw after drag
        }
        // reset tap event states
        self.moved = 0
        self.startTime = nil
      }
  } // end tapGesture



  // HELPER FUNCTIONS ..................................

  // Calculated variable for the image aspect ratio.
  // Uses user-specified image height and width.
  private var aspectRatio: String {
    let h = Double(doc.picdef.imageHeight)
    let w = Double(doc.picdef.imageWidth)
    let ratioDouble: Double = max(h / w, w / h)
    let ratioString = String(format: "%.2f", ratioDouble)
    return ratioString
  }

  private var leftGradientIsValid: Bool {
    var isValid = false
    let leftNum = self.doc.picdef.leftNumber
    let lastPossible = self.doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  private var calculatedRightNumber: Int {
    if self.leftGradientIsValid, self.doc.picdef.leftNumber < self.doc.picdef.hues.count {
      return self.doc.picdef.leftNumber + 1
    }
    return 1
  }

  private func getIsPrintable(color: Color, num: Int) -> Bool {
    if MandMath.isColorNearPrintableList(color: color.cgColor!, num: num) {
      return true
    } else {
      return false
    }
  }


  fileprivate func resetAllPopupsToFalse() {
    self.showingAllColorsPopups = Array(repeating: false, count: 6)
    self.showingPrintableColorsPopups = Array(repeating: false, count: 6)
    self.showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
  }

  // Multiplies scale by 2.0.
  func zoomIn() {
    self.doc.picdef.scale = self.doc.picdef.scale * 2.0
    self.showMandArtBitMap()
  }

  // Divides scale by 2.0.
  func zoomOut() {
    self.doc.picdef.scale = self.doc.picdef.scale / 2.0
    self.showMandArtBitMap()
  }

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

    let currImage = contextImageGlobal!
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

  // Update hue nums after moviing or deleting
  fileprivate func updateHueNums() {
    for (index, _) in self.$doc.picdef.hues.enumerated() {
      self.doc.picdef.hues[index].num = index + 1
    }
  }

}



