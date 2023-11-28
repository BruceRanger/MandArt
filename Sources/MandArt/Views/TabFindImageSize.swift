import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFindImageSize: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  func aspectRatio() -> Double {
    let h = Double(doc.picdef.imageHeight)
    let w = Double(doc.picdef.imageWidth)
    return max(h / w, w / h)
  }

  var body: some View {
    Section(
      header:
      Text("Set Image Size")
        .font(.headline)
        .fontWeight(.medium)
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
          Text("Aspect Ratio:")
          Text(String(format: "%.1f", aspectRatio()))
            .padding(1)
            .help("Calculated value of image width over image height.")
        }
      }
    }

    Divider()
  }
}
