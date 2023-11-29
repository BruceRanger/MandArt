import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabTune: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        VStack(spacing: 10) {
          Text("Spacing far from MiniMand (near to edge)")
          SliderTextView(
            range: 1 ... 20,
            step: 1,
            placeholder: "5",
            formatter: MAFormatters.fmtSpacingNearEdge,
            helpText: "Enter the value for the color spacing near the edges of the image, away from MiniMand.",
            value: $doc.picdef.spacingColorFar
          )
          .onChange(of: doc.picdef.spacingColorFar) { _ in
            print("TabTune: onChange spacingColorFar")
          }
        }

        VStack(spacing: 10) {
          Text("Spacing near to MiniMand (far from edge)")
          SliderTextView(
            range: 5 ... 50,
            step: 5,
            placeholder: "15",
            formatter: MAFormatters.fmtSpacingFarFromEdge,
            helpText: "Enter the value for the color spacing away from the edges of the image, near the MiniMand.",
            value: $doc.picdef.spacingColorNear
          )
          .onChange(of: doc.picdef.spacingColorNear) { _ in
            print("TabTune: onChange spacingColorNear")
          }
        }

        // dFIterMin
        VStack(spacing: 10) {
          Text("Change in minimum iteration (dFIterMin)")
          SliderTextView(
            range: -5 ... 20,
            step: 1,
            placeholder: "0",
            formatter: MAFormatters.fmtChangeInMinIteration,
            helpText: "Enter a value for the change in the minimum number of iterations in the image. This will change the coloring.",
            value: $doc.picdef.dFIterMin
          )
          .onChange(of: doc.picdef.dFIterMin) { _ in
            print("TabTune: onChange dFIterMin")
          }
        }

        // nBlocks
        VStack(spacing: 10) {
          Text("Number of Color Blocks (nBlocks)")
          SliderTextView(
            range: 10 ... 100,
            step: 10,
            placeholder: "60",
            formatter: MAFormatters.fmtNBlocks,
            helpText: "Enter a value for the number of blocks of color in the image.",
            value: Binding(
              get: { Double(doc.picdef.nBlocks) },
              set: { doc.picdef.nBlocks = Int($0) }
            )
          )
          .onChange(of: doc.picdef.nBlocks) { _ in
            print("TabTune: onChange nBlocks")
          }
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
          .onChange(of: doc.picdef.yY) { _ in
            print("TabTune: onChange yY")
          }
        }
        .padding(.horizontal)
        // END Hold fraction with Slider

        Spacer()
      } //  vstack
    } // scrollview
    .padding()
    .onAppear {
      requiresFullCalc = false
      showGradient = false
    }
    .onDisappear {
      if requiresFullCalc {
        requiresFullCalc = false
      }
    }
  }
}
