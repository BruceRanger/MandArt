import SwiftUI

struct PopupAllPrintableColors: View {

  @Binding var iAP: Int?
  @Binding var showingAllPrintableColorsPopups: [Bool]

  init(iAP: Binding<Int?>, showingAllPrintableColorsPopups: Binding<[Bool]>) {
    self._iAP = iAP
    self._showingAllPrintableColorsPopups = showingAllPrintableColorsPopups
  }

  var body: some View {

    ZStack {
      Color.white
        .opacity(0.5)
      VStack {
          Button(action: {
          showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
          }) {
            Image(systemName: "xmark.circle")

          }

        VStack {
          let arrCGs = MandMath.getAllPrintableCGColorsList(iSort: iAP!)
          let arrColors = arrCGs.map { cgColor in
            Color(cgColor)
          }
          let nColumns = 32 // 64
          let nRows = arrColors.count / nColumns
          ForEach(0 ..< nRows) { rowIndex in
            HStack(spacing: 0) {
              ForEach(0 ..< nColumns) { columnIndex in
                let index = rowIndex * nColumns + columnIndex
                Rectangle()
                  .fill(arrColors[index])
                  .frame(width: 17, height: 27)
                  .cornerRadius(4)
                  .padding(1)
              }
            }
          }
        } // end VStack of color options
        Spacer()
      } // end VStack
      .padding()
      .background(Color.white)
      .cornerRadius(8)
      .shadow(radius: 10)
      .padding()
    } // end ZStack for popup
    .transition(.scale)

  } // end body
}
