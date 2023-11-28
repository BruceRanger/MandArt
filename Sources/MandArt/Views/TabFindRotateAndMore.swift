import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFindRotateAndMore: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  var body: some View {
    HStack {
      Text("Rotation,º (theta)")
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
    } // end hstack theta

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
    } // end hstack sharpening
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
    } // end hstack smoothing
  }
}
