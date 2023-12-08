import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFindImageSize: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool

  func aspectRatio() -> Double {
    let h = Double(doc.picdef.imageHeight)
    let w = Double(doc.picdef.imageWidth)
    return max(h / w, w / h)
  }

  var body: some View {
    Section(
      header:
      Text("Set Picture Size")
        .font(.headline)
        .fontWeight(.medium)
    ) {
      HStack {
        VStack {
          Text("Width, px:")
          DelayedTextFieldInt(
            placeholder: "1100",
            value: $doc.picdef.imageWidth,
            formatter: MAFormatters.fmtImageWidthHeight
          )
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: 80)
          .padding(10)
          .help("Enter the width, in pixels, of the picture.")
          .onChange(of: doc.picdef.imageWidth) { _ in
            requiresFullCalc = true
          }
        } // end vstack

        VStack {
          Text("Height, px")
          DelayedTextFieldInt(
            placeholder: "1000",
            value: $doc.picdef.imageHeight,
            formatter: MAFormatters.fmtImageWidthHeight
          )
          .frame(maxWidth: 80)
          .padding(10)
          .help("Enter the height, in pixels, of the picture.")
          .onChange(of: doc.picdef.imageHeight) { _ in
            requiresFullCalc = true
          }
        } // end vstack

        VStack {
          Text("Aspect Ratio:")
          Text(String(format: "%.1f", aspectRatio()))
            .padding(10)
            .help("Calculated value of picture width over picture height.")
        }
      }
    }

    Divider()
  }
}
