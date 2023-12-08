import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFindRotateAndMore: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool

  var body: some View {
    HStack {
      Text("Rotation")
        .help("Enter degress to rotate counter-clockwise.")

      DelayedTextFieldDouble(
        placeholder: "0",
        value: $doc.picdef.theta,
        formatter: MAFormatters.fmtRotationTheta
      )
      .textFieldStyle(.roundedBorder)
      .multilineTextAlignment(.trailing)
      .frame(maxWidth: 60)
      .help("Enter the angle to rotate the image counter-clockwise, in degrees.")
      .onChange(of: doc.picdef.theta) { _ in
        requiresFullCalc = true
      }
    } // end hstack theta

    HStack {
      Text("Maximum tries:")

      DelayedTextFieldDouble(
        placeholder: "10,000",
        value: $doc.picdef.iterationsMax,
        formatter: MAFormatters.fmtSharpeningItMax
      )
      .textFieldStyle(.roundedBorder)
      .multilineTextAlignment(.trailing)
      .help(
        "Enter the maximum number of tries for a given point in the image. A larger value will increase the resolution, but slow down the calculation and make the coloring more difficult."
      )
      .frame(maxWidth: 70)
      .onChange(of: doc.picdef.iterationsMax) { _ in
        requiresFullCalc = true
      }
    } // end hstack sharpening
    .padding(.horizontal)

    HStack {
      Text("Color smoothing limit:")

      DelayedTextFieldDouble(
        placeholder: "400",
        value: $doc.picdef.rSqLimit,
        formatter: MAFormatters.fmtSmootingRSqLimit
      )
      .textFieldStyle(.roundedBorder)
      .multilineTextAlignment(.trailing)
      .frame(maxWidth: 60)
      .help(
        "Enter the minimum value for the square of the distance from origin before the number of tries is ended. A larger value will smooth the color gradient, but slow down the calculation. Must be greater than 4"
      )
      .onChange(of: doc.picdef.rSqLimit) { _ in
        requiresFullCalc = true
      }
    } // end hstack smoothing
  }
}
