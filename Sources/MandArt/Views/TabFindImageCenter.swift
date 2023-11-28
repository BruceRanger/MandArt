import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFindImageCenter: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool

  var body: some View {
    Section(
      header:
      Text("Set Image Center")
        .font(.headline)
        .fontWeight(.medium)
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
            print("TabFind: onChange xCenter")
            requiresFullCalc = true
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
            print("TabFind: onChange yCenter")
            requiresFullCalc = true
          }
        }
      } // end HStack for XY
    }
    Divider()
  }
}
