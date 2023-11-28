import SwiftUI
import UniformTypeIdentifiers

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
        CustomIntInputField(title: "Width, px:", value: $doc.picdef.imageWidth, placeholder: "1100", onChangeAction: {
              print("TabFind: onChange width")
              activeDisplayState = .MandArtFull
        })

        CustomIntInputField(title: "Height, px:", value: $doc.picdef.imageHeight, placeholder: "1000", onChangeAction: {
              print("TabFind: onChange height")
              activeDisplayState = .MandArtFull
        })

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

struct CustomIntInputField: View {
  var title: String
  @Binding var value: Int
  var placeholder: String
  var onChangeAction: () -> Void

  var body: some View {
    VStack {
      Text(title)
      DelayedTextFieldInt(
        placeholder: placeholder,
        value: $value,
        formatter: MAFormatters.fmtImageWidthHeight
      )
      .textFieldStyle(.roundedBorder)
      .multilineTextAlignment(.trailing)
      .frame(maxWidth: 80)
      .padding(10)
      .help("Enter \(title.lowercased()), in pixels, of the image.")
    }
  }
}
