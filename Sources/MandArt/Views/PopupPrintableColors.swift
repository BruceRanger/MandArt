import SwiftUI

struct PopupPrintableColors: View {

  @Binding var iP: Int?
  @Binding var showingPrintableColorsPopups: [Bool]

  init(iP: Binding<Int?>, showingPrintableColorsPopups: Binding<[Bool]>) {
    self._iP = iP
    self._showingPrintableColorsPopups = showingPrintableColorsPopups
  }

  var body: some View {

    ZStack {
      Color.white
        .opacity(0.5)
      VStack(alignment: .center) {

          Button(action: {
            showingPrintableColorsPopups = Array(repeating: false, count: 6)
          }) {
            Image(systemName: "xmark.circle")
          }

        VStack {
          let arrCGs = MandMath.getPrintableCGColorListSorted(iSort: iP!)
          let arrColors = arrCGs.map { cgColor in
            Color(cgColor)
          }

          let nColumns = 32
          ForEach(0 ..< arrColors.count / nColumns) { rowIndex in
            HStack(spacing: 0) {
              ForEach(0 ..< 32) { columnIndex in
                let index = rowIndex * nColumns + columnIndex
                let color = arrColors[index]
                let nsColor = NSColor(color)
                let red = nsColor.redComponent
                let green = nsColor.greenComponent
                let blue = nsColor.blueComponent

                let colorValueR = "\(Int(red * 255))"
                let colorValueG = "\(Int(green * 255))"
                let colorValueB = "\(Int(blue * 255))"

                VStack {
                  Rectangle()
                    .fill(arrColors[index])
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                    .padding(1)

                  Text(colorValueR)
                    .font(.system(size: 10))
                    .background(Color.white)
                  Text(colorValueG)
                    .font(.system(size: 10))
                    .background(Color.white)
                  Text(colorValueB)
                    .font(.system(size: 10))
                    .background(Color.white)
                } // end Zstack of rect, rgb values
              } // end for each column of colors
            } // end HStack of colors
          } // end for each color
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
