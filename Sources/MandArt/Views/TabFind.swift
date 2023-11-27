import SwiftUI
import UniformTypeIdentifiers

struct TabFind: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice
  @State private var scale: Double
  @State private var scaleMultiplier: Double = 5.0000
  @State private var didChange: Bool = false
  @State private var scaleString: String = ""

  init(doc: MandArtDocument, activeDisplayState: Binding<ActiveDisplayChoice>) {
    self._doc = ObservedObject(initialValue: doc)
    self._activeDisplayState = activeDisplayState
    self._scale = State(initialValue: doc.picdef.scale)
    _scaleString = State(initialValue: String(format: "%.0f", doc.picdef.scale))
  }

  func zoomIn() {
    scale *= 2.0
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    didChange = !didChange // force redraw
  }

  func zoomOut() {
    scale /= 2.0
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    didChange = !didChange // force redraw
  }

  func zoomInCustom(n: Double) {
    scale *= n
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    didChange = !didChange // force redraw
  }

  func zoomOutCustom(n: Double) {
    scale /= n
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    didChange = !didChange // force redraw
  }

  func aspectRatio() -> Double {
    let h = Double(doc.picdef.imageHeight)
    let w = Double(doc.picdef.imageWidth)
    return max(h / w, w / h)
  }

  var body: some View {
    ScrollView {
      VStack {

        Section(header:
                  Text("Set Image Size")
          .font(.headline)
          .fontWeight(.medium)
          .padding(.bottom)
        ) {

          HStack {

            VStack {

              Text("Width, px:")
              Text("(imageWidth)")
              DelayedTextFieldInt(
                placeholder: "1100",
                value: $doc.picdef.imageWidth,
                formatter: MAFormatters.fmtImageWidthHeight
              )
              .textFieldStyle(.roundedBorder)
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 80)
              .padding(10)
              .help("Enter the width, in pixels, of the image.")
              .onChange(of: doc.picdef.imageWidth) { _ in
                print("TabFind: onChange width")
                activeDisplayState = .MandArtFull
              }

            } // end vstack

            VStack {
              Text("Height, px")
              Text("(imageHeight)")
              DelayedTextFieldInt(
                placeholder: "1000",
                value: $doc.picdef.imageHeight,
                formatter: MAFormatters.fmtImageWidthHeight
              )
              .frame(maxWidth: 80)
              .padding(10)
              .help("Enter the height, in pixels, of the image.")
              .onChange(of: doc.picdef.imageHeight) { _ in
                print("TabFind: onChange height")
                activeDisplayState = .MandArtFull
              }

            } // end vstack

            VStack {
              Text("Aspect")
              Text("ratio:")

              Text(String(format: "%.1f", aspectRatio()))
                .padding(1)
                .help("Calculated value of image width over image height.")
            }

          } // end hstack
        } // end section

        Divider()

        Section(
          header:
            Text("")
            .font(.headline)
            .fontWeight(.medium)
            .padding(.bottom)
        ) {

          HStack {
            VStack { // vertical container
              Text("Enter center x")
              Text("Between -2 and 2")
              Text("(xCenter)")
              DelayedTextFieldDouble(
                placeholder: "-0.75",
                value: $doc.picdef.xCenter,
                formatter: MAFormatters.fmtXY
              )
              .textFieldStyle(.roundedBorder)
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 170)
              .help(
                "Enter the x value in the Mandelbrot coordinate system for the center of the image."
              )
              .onChange(of: doc.picdef.xCenter) { _ in
                print("TabFind: onChange x")
                activeDisplayState = .MandArtFull
              }
            } // end vstack

            VStack { //  vertical container
              Text("Enter center y")
              Text("Between -2 and 2")
              Text("(yCenter)")
              DelayedTextFieldDouble(
                placeholder: "0.0",
                value: $doc.picdef.yCenter,
                formatter: MAFormatters.fmtXY
              )
              .textFieldStyle(.roundedBorder)
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 170)
              .help(
                "Enter the Y value in the Mandelbrot coordinate system for the center of the image."
              )
              .onChange(of: doc.picdef.yCenter) { _ in
                print("TabFind: onChange y")
                activeDisplayState = .MandArtFull
              }
            }
          } // end HStack for XY

          HStack {
            Text("Scale (scale)")
            TextField("Scale", text: $scaleString, onCommit: {
              if let newScale = Double(scaleString) {
                doc.picdef.scale = newScale.rounded()
              }
            })
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 180)
            .help("Enter the magnification (may take a while).")
            .onAppear {
              scaleString = String(format: "%.0f", doc.picdef.scale)
            }
            .onChange(of: doc.picdef.scale) { _ in
              print("TabFind: onChange scale")
              // Update scaleString whenever doc changes
              let newScaleString = String(format: "%.0f", doc.picdef.scale)
              if newScaleString != scaleString {
                scaleString = newScaleString
              }
              didChange = !didChange
              activeDisplayState = .MandArtFull
            }
          }
          .padding(.horizontal)

          //  Show Row (HStack) of Rotate and Zoom Next

          HStack {

            VStack {
              Text("Rotate (º)")
                .help("Enter degress to rotate (theta).")

              DelayedTextFieldDouble(
                placeholder: "0",
                value: $doc.picdef.theta,
                formatter: MAFormatters.fmtRotationTheta
              )
              .textFieldStyle(.roundedBorder)
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 60)
              .help("Enter the angle to rotate the image counterclockwise, in degrees.")
              .onChange(of: doc.picdef.theta) { _ in
                print("TabFind: onChange theta")
                activeDisplayState = .MandArtFull
              }
            }

            Divider()
            VStack {
              Text("Zoom By 2")
              HStack {
                Button("+") { zoomIn() }
                  .help("Zoom in by factor of 2 (may take a while).")
                Text("2")
                Button("-") { zoomOut() }
                  .help("Zoom out by factor of 2 (may take a while).")
              }
            }
            Divider()

            VStack {
              Text("Custom Zoom")
              HStack {
                Button("+") { zoomInCustom(n: scaleMultiplier) }
                  .help("Zoom in by multiplier (may take a while).")
                DelayedTextFieldDouble(
                  placeholder: String(format: "%.4f", scaleMultiplier),
                  value: $scaleMultiplier,
                  formatter: MAFormatters.fmtScaleMultiplier
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .frame(minWidth: 60, maxWidth: 80 )
                .help("Enter the angle to rotate the image counterclockwise, in degrees.")
                .onChange(of: doc.picdef.theta) { _ in
                  print("TabFind: onChange theta")
                  activeDisplayState = .MandArtFull
                }
                Button("-") { zoomOutCustom(n: scaleMultiplier) }
                  .help("Zoom out by multiplier (may take a while).")
              }
            }
          }

          //  Divider()

          HStack {
            Text("Sharpening (iterationsMax):")

            DelayedTextFieldDouble(
              placeholder: "10,000",
              value: $doc.picdef.iterationsMax,
              formatter: MAFormatters.fmtSharpeningItMax
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .help(
              "Enter the maximum number of iterations for a given point in the image. A larger value will increase the resolution, but slow down the calculation."
            )
            .frame(maxWidth: 70)
            .onChange(of: doc.picdef.iterationsMax) { _ in
              print("TabFind: onChange iterationsMax")
              activeDisplayState = .MandArtFull
            }
          }
          .padding(.horizontal)

          HStack {
            Text("Color smoothing (rSqLimit):")

            DelayedTextFieldDouble(
              placeholder: "400",
              value: $doc.picdef.rSqLimit,
              formatter: MAFormatters.fmtSmootingRSqLimit
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 60)
            .help(
              "Enter min value for square of distance from origin. A larger value will smooth the color gradient, but slow down the calculation."
            )
            .onChange(of: doc.picdef.rSqLimit) { _ in
              print("TabFind: onChange rSqLimit")
              activeDisplayState = .MandArtFull
            }
          }

        } // end section

        Spacer()

      } //  vstack
    } // scrollview
  } //  body
}
