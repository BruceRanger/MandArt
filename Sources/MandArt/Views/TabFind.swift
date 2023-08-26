import SwiftUI
import UniformTypeIdentifiers

struct TabFind: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  internal func zoomIn() {
    doc.picdef.scale = self.doc.picdef.scale * 2.0
  }

  internal func zoomOut() {
    doc.picdef.scale = self.doc.picdef.scale / 2.0
  }

  // Calculated variable for the image aspect ratio.
  // Uses user-specified image height and width.
  private var aspectRatio: String {
    let h = Double(doc.picdef.imageHeight)
    let w = Double(doc.picdef.imageWidth)
    let ratioDouble: Double = max(h / w, w / h)
    let ratioString = String(format: "%.2f", ratioDouble)
    return ratioString
  }

  var body: some View {

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
              ) {
                print("Width loses focus")
                activeDisplayState = .MandArt // on lose focus
              }
              .textFieldStyle(.roundedBorder)
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 80)
              .help("Enter the width, in pixels, of the image.")
            } // end vstack

            VStack {
              Text("Height, px")
              Text("(imageHeight)")
              DelayedTextFieldInt(
                placeholder: "1000",
                value: $doc.picdef.imageHeight,
                formatter: MAFormatters.fmtImageWidthHeight
              ) {
                print("Height loses focus")
                activeDisplayState = .MandArt
              }
              .frame(maxWidth: 80)
              .help("Enter the height, in pixels, of the image.")
            } // end vstack

            VStack {
              Text("Aspect")
              Text("ratio:")

              Text("\(aspectRatio)")
                .padding(1)
                .help("Calculated value of image width over image height.")
            } // end vstack

          } // end hstack
        } // end section

        Divider()

      Section(header:
                Text("")
        .font(.headline) // This sets the font to a "headline" style, which may be similar to what you want.
        .fontWeight(.medium) // Adjusting weight for emphasis.
        .padding(.bottom) // Adds space below.
      ) {

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
              activeDisplayState = .MandArt // on lose focus
            }
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 170)
            .help(
              "Enter the x value in the Mandelbrot coordinate system for the center of the image."
            )
          } // end vstack

          VStack { // each input has a vertical container with a Text label & TextField for data
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
          }
        } // end HStack for XY

        //  Show Row (HStack) of Scale Next

        HStack {
          VStack {
            Text("Rotate (º)")
            Text("(theta)")

            DelayedTextFieldDouble(
              placeholder: "0",
              value: $doc.picdef.theta,
              formatter: MAFormatters.fmtRotationTheta
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(maxWidth: 60)
            .help("Enter the angle to rotate the image counterclockwise, in degrees.")
          }

          VStack {
            Text("Scale (scale)")
            DelayedTextFieldDouble(
              placeholder: "430",
              value: $doc.picdef.scale,
              formatter: MAFormatters.fmtScale
            )
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
        }

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

      } // end section

      Spacer()

    } // end vstack

  } // end body
}
