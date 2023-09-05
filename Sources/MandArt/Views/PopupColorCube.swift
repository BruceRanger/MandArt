import SwiftUI

struct PopupColorCube: View {

  @ObservedObject var popupManager: PopupManager
  var hues: [Hue] // Not using Binding here

  init(popupManager: PopupManager, hues: [Hue]) {
    self.popupManager = popupManager
    self.hues = hues
  }

// Example of what we know about user colors
  // num (is the sort order)
  // rgb value (need to convert to CGColor)
  // Example below:
  //
//  var hues: [Hue] = [
//    Hue(num: 1, r: 0.0, g: 255.0, b: 0.0),
//    Hue(num: 2, r: 255.0, g: 255.0, b: 0.0),
//    Hue(num: 3, r: 255.0, g: 0.0, b: 0.0),
//    Hue(num: 4, r: 255.0, g: 0.0, b: 255.0),
//    Hue(num: 5, r: 0.0, g: 0.0, b: 255.0),
//    Hue(num: 6, r: 0.0, g: 255.0, b: 255.0),
//  ]

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

        // TODO BHJ - call the mandmath case here (set iSort) .........
      
        
        VStack {
          var arrCGs: [CGColor] {
            switch popupManager.showingCube {
            
            // BHJ ALL COLORS (ON THE LEFT) 
              case .AllRed:
                return MandMath.getAllCGColorsList(iSort: 6)
              case .AllGreen:
                return MandMath.getAllCGColorsList(iSort: 1)
              case .AllBlue:
                return MandMath.getAllCGColorsList(iSort: 0) // BHJ
                
            // BHJ ALL / PRINTABLE COLORS (In the middle)
              
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
        

          let nColumns = 32  // 8 // 32 // 64
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
              .padding(.trailing, 12) // Add spacing between sets of rows
            }
          }
          
          

  /*        
    //     let nColumns = 8 // 32 // 64
    //      let nRows = arrColors.count / 8
          let nRows = arrColors.count / 64
    //      let nRows = 64 / 8
          
          VStack(spacing: 10) { // Add spacing between sets of 8 rows
            ForEach(0 ..< nRows/8, id: \.self) { setIndex in
              VStack(spacing: 0) {
                ForEach(0 ..< 8) { rowIndex in
                  HStack(spacing: 0) {
                    ForEach(0 ..< 8) { columnIndex in
                      let rowOffset = setIndex * 8
                      let index = (rowIndex + rowOffset) * 8 + columnIndex
                      Rectangle()
                        .fill(arrColors[index])
                        .frame(width: 27, height: 27) // Make each item square
                        .cornerRadius(4)
                        .padding(1)
                    }
                  }
                }
              }
              .padding(.trailing, 12) // Add spacing between sets of rows
            }
          }
      */    
          
          

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
