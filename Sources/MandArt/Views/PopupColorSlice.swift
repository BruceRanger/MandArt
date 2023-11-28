import SwiftUI

@available(macOS 12.0, *)
struct PopupColorSlice: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var selectedColor: (r: Int, g: Int, b: Int)?

  let arrColors: [Color]
  let start: Int
  let end: Int
  let nColumns: Int = 8
  let nRows: Int = 8

  init(
    doc: MandArtDocument,
    selectedColor: Binding<(r: Int, g: Int, b: Int)?>,
    arrColors: [Color],
    start: Int,
    end: Int
  ) {
    self.doc = doc
    _selectedColor = selectedColor
    self.arrColors = arrColors
    self.start = start
    self.end = end
  }

  private func handleColorSelection(color: Color) {
    if let components = color.colorComponents {
      selectedColor = (r: Int(components.red * 255), g: Int(components.green * 255), b: Int(components.blue * 255))
      if let selected = selectedColor {
        doc.addHue(r: Double(selected.r), g: Double(selected.g), b: Double(selected.b))
      }
    }
  }

  var body: some View {
    if arrColors.count != 512 {
      // Return an empty view or some indicator that there's an issue.
      return AnyView(Text("Invalid color data").foregroundColor(.red))
    }

    return AnyView(
      VStack(spacing: 0) {
        ForEach(0 ..< nRows, id: \.self) { row in
          HStack(spacing: 0) {
            ForEach(0 ..< nColumns, id: \.self) { col in
              let index = start + row * nColumns + col

              Button(action: {
                if index <= end {
                  handleColorSelection(color: arrColors[index])
                }
              }) {
                if index <= end {
                  Rectangle()
                    .fill(arrColors[index])
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                    .padding(1)
                } else {
                  Rectangle()
                    .fill(Color.clear) // Transparent Rectangle
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                    .padding(1)
                }
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
        }
      } // vstack
    ) // any view
  }
}
