import SwiftUI
import Foundation

struct PopupColorCube: View {

  @ObservedObject var popupManager: PopupManager
  var hues: [Hue] // Not using Binding here

  init(popupManager: PopupManager, hues: [Hue]) {
    self.popupManager = popupManager
    self.hues = hues
  }

  var body: some View {

    ZStack(alignment: .top) { // Align to top
      Color.white
        .opacity(0.5)
        .edgesIgnoringSafeArea(.all) // Cover the whole screen

      VStack {
        Button(action: {
          popupManager.showingCube = .None
        }) {
          Image(systemName: "xmark.circle")
        }
        .padding(.top, 10)

        VStack {
          var arrCGs: [CGColor] {
            switch popupManager.showingCube {

                // BHJ ALL COLORS (ON THE LEFT) - set the mandmath isort

              case .AllRed:
                return MandMath.getAllCGColorsList(iSort: 6)
              case .AllGreen:
                return MandMath.getAllCGColorsList(iSort: 1)
              case .AllBlue:
                return MandMath.getAllCGColorsList(iSort: 0)

                // BHJ ALL / PRINTABLE COLORS (In the middle)  - set the mandmath isort

              case .APRed:
                return MandMath.getAllPrintableCGColorsList(iSort: 6)
              case .APGreen:
                return MandMath.getAllPrintableCGColorsList(iSort: 1)
              case .APBlue:
                return MandMath.getAllPrintableCGColorsList(iSort: 0)
              case .None:
                return []
            }
          }

          let arrColors = arrCGs.map { cgColor in
            Color(cgColor)
          }

          let nColumns = 8
          let nRows = 8
          let totalSlices = 8

          VStack(spacing: 10) {
            ForEach(0 ..< 2, id: \.self) { rowIndex in // 2 rows
              HStack(spacing: 10) {
                ForEach(0 ..< 4, id: \.self) { columnIndex in // 4 slices/row
                  let sliceIndex = rowIndex * 4 + columnIndex
                  let start = sliceIndex * nRows * nColumns
                  let end = (sliceIndex + 1) * nRows * nColumns

                 PopupColorSlice(arrColors: arrColors, start: start, end: end, nColumns: nColumns, nRows: nRows)
                }
              } // HStack
            } // ForEach
          }  // VStack

        } // vstack
        .padding(.top, 2)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 10)
        .padding()

      } // vstack with close button
     // .transition(.scale)

    } // zstack
    .padding()

  } // body
}
