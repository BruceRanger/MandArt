import SwiftUI
import UniformTypeIdentifiers

struct TabViewSize: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

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

            Text("Image")
            Text("width, px:")
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
            Text("Image")
            Text("height, px")
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

    } // end vstack

  } // end body
}
