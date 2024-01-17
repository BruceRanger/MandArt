import SwiftUI

@available(macOS 12.0, *)
struct PopupColorSlice: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var selectedColor: (r: Int, g: Int, b: Int)?

  let arrColors: [Color]
  let start: Int
  let end: Int



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

    if arrColors.count == 512 {
      var nColumns = 8
      var nRows = 8

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
    } // end if 512 (8 x 8 x 8)


    if arrColors.count == 729 {
      var nColumns = 9
      var nRows = 9

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
                      .frame(width: 20, height: 20)
                      .cornerRadius(4)
                      .padding(1)
                  } else {
                    Rectangle()
                      .fill(Color.clear) // Transparent Rectangle
                      .frame(width: 20, height: 20)
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
    } // if 729 (9 x 9 x 9)

    else {
      // Return an empty view or some indicator that there's an issue.
      print(arrColors.count)
      print(arrColors)
      return AnyView(Text("Invalid color data").foregroundColor(.red))
    }


  } // end body
}
