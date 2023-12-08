import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFindImageCenter: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool

  var body: some View {
    Section(
      header:
      Text("Set Picture Center")
        .font(.headline)
        .fontWeight(.medium)
    ) {
      HStack {
        VStack { // vertical container
          Text("Enter horizontal center")
          Text("Between -2 and 2")
          DelayedTextFieldDouble(
            placeholder: "-0.75",
            value: $doc.picdef.xCenter,
            formatter: MAFormatters.fmtXY
          )
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: 170)
          .help(
            "Enter a value for the horizontal center of the picture."
          )
          .onChange(of: doc.picdef.xCenter) { _ in
            requiresFullCalc = true
          }
        } // end vstack

        VStack { //  vertical container
          Text("Enter vertical center")
          Text("Between -2 and 2")
          DelayedTextFieldDouble(
            placeholder: "0.0",
            value: $doc.picdef.yCenter,
            formatter: MAFormatters.fmtXY
          )
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: 170)
          .help(
            "Enter a value for the vertical center of the picture."
          )
          .onChange(of: doc.picdef.yCenter) { _ in
            requiresFullCalc = true
          }
        }
      } // end HStack for XY
    }
    Divider()
  }
}
