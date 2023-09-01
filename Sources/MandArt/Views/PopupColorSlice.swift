import SwiftUI

struct PopupColorSlice: View {

  let arrColors: [Color]
  let start: Int
  let end: Int
  let nColumns: Int
  let nRows: Int

  var body: some View {

    // SHOW SLICE VSTACK (8x8)
    VStack(spacing: 0) {
      ForEach(0 ..< nRows, id: \.self) { row in
       HStack(spacing: 0) {
          ForEach(0 ..< nColumns, id: \.self) { col in
            let index = start + row * nColumns + col
            if index <= end {
              Rectangle()
                .fill(arrColors[index]) // TODO - BHJ - Comment out and close works. leave in and close breaks
                .frame(width: 27, height: 27) // Make each item square
                .cornerRadius(4)
                .padding(1)
            }
          }
        }
      }
    }
    // END SLICE VSTACK 8x8

  } // body
}
