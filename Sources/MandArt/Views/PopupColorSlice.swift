import SwiftUI

struct PopupColorSlice: View {

  let arrColors: [Color]
  let start: Int
  let end: Int
  let nColumns: Int = 8
  let nRows: Int = 8

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
              if index <= end {
                Rectangle()
                  .fill(arrColors[index])
                  .frame(width: 30, height: 30)
                  .cornerRadius(4)
                  .padding(1)
              } else {
                Rectangle()
                  .fill(Color.clear)  // Transparent Rectangle
                  .frame(width: 30, height: 30)
                  .cornerRadius(4)
                  .padding(1)
              }
            }
          }
        }
      } // vstack
    ) // any view
  } // body
}
