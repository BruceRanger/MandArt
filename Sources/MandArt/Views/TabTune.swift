import SwiftUI
import UniformTypeIdentifiers

struct TabTune: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  var body: some View {

    ScrollView {
    VStack(spacing: 20) {

      VStack(spacing: 10) {
        Text("Spacing far from MiniMand (near to edge)")
        SliderTextfieldView(
          range: 1...20,
          step: 1,
          placeholder: "5",
          formatter: MAFormatters.fmtSpacingNearEdge,
          helpText: "Enter the value for the color spacing near the edges of the image, away from MiniMand.",
          value: $doc.picdef.spacingColorFar
        )
      }

      VStack(spacing: 10) {
        Text("Spacing near to MiniMand (far from edge)")
        SliderTextfieldView(
          range: 5...50,
          step: 5,
          placeholder: "15",
          formatter: MAFormatters.fmtSpacingFarFromEdge,
          helpText: "Enter the value for the color spacing away from the edges of the image, near the MiniMand.",
          value: $doc.picdef.spacingColorNear

        )
      }

      // dFIterMin
      VStack(spacing: 10) {
        Text("Change in minimum iteration (dFIterMin)")
        SliderTextfieldView(
          range: -5...20,
          step: 1,
          placeholder: "0",
          formatter: MAFormatters.fmtChangeInMinIteration,
          helpText: "Enter a value for the change in the minimum number of iterations in the image. This will change the coloring.",
          value: $doc.picdef.dFIterMin
        )
      }

      // nBlocks
      VStack(spacing: 10) {
        Text("Number of Color Blocks (nBlocks)")
        SliderTextfieldView(
          range: 10...100,
          step: 10,
          placeholder: "60",
          formatter: MAFormatters.fmtNBlocks,
          helpText: "Enter a value for the number of blocks of color in the image.",
          value: Binding(
            get: { Double(doc.picdef.nBlocks) },
            set: { doc.picdef.nBlocks = Int($0) }
          )
        )
      }
      Spacer()

    } //  vstack
  } // scrollview
    .padding()
  }
}
