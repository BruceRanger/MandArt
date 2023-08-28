import SwiftUI


struct PopupColorCube: View {

  @ObservedObject var popupManager: PopupManager

  init(popupManager: PopupManager) {
    self.popupManager = popupManager
  }

  
  var body: some View {

    ZStack {
      Color.white
        .opacity(0.5)
      VStack {
        Button(action: {
          popupManager.showingCube = .None

        }) {
          Image(systemName: "xmark.circle")

        }

        VStack {
          var arrCGs: [CGColor] {
            switch popupManager.showingCube {
            case .AllRed:
                return MandMath.getAllPrintableCGColorsList(iSort: 0)
              case .AllGreen:
                return MandMath.getAllPrintableCGColorsList(iSort: 2)
              case .AllBlue:
                return MandMath.getAllPrintableCGColorsList(iSort: 4)
              case .APRed:
                return MandMath.getAllPrintableCGColorsList(iSort: 0)
              case .APGreen:
                return MandMath.getAllPrintableCGColorsList(iSort: 2)
              case .APBlue:
                return MandMath.getAllPrintableCGColorsList(iSort: 4)
              case .None:
                return []  // You might want to handle this case as well
            }
          }


          let arrColors = arrCGs.map { cgColor in
            Color(cgColor)
          }
          let nColumns = 32 // 64
          let nRows = arrColors.count / nColumns
          VStack(spacing: 8) { // Add spacing between sets of 8 rows
            ForEach(0 ..< nRows / 8, id: \.self) { setIndex in
              VStack(spacing: 0) {
                ForEach(0 ..< 8) { rowIndex in
                  HStack(spacing: 0) {
                    ForEach(0 ..< nColumns) { columnIndex in
                      let rowOffset = setIndex * 8
                      let index = (rowIndex + rowOffset) * nColumns + columnIndex
                      Rectangle()
                        .fill(arrColors[index])
                        .frame(width: 27, height: 27) // Make each item square
                        .cornerRadius(4)
                        .padding(1)
                    }
                  }
                }
              }
              .padding(.trailing, 8) // Add spacing between sets of rows
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
