import SwiftUI
import AppKit

struct PopupPrintableColors: View {

  @ObservedObject var popupManager: PopupManager

  @Binding var iP: Int?
  @Binding var showingPrintableColorsPopups: [Bool]

  var hues: [Hue]

  let sortStrings: [String] = ["RGB", "RBG", "GRB", "GBR", "BRG", "BGR"]

  init(
    popupManager: PopupManager,
    hues: [Hue],
    iP: Binding<Int?>, showingPrintableColorsPopups: Binding<[Bool]>
  ) {
    self.popupManager = popupManager
    self.hues = hues
    self._iP = iP
    self._showingPrintableColorsPopups = showingPrintableColorsPopups
  }

  func sortString(for iSort: Int) -> String? {
    guard iSort >= 0 && iSort < sortStrings.count else {
      return nil
    }
    return sortStrings[iSort]
  }

  private var columnCount: Int {
    guard let screenWidth = NSScreen.main?.frame.width else { return 32 } // Default to 32 if screen width cannot be determined
    let boxWidth: CGFloat = 30.0 + 2 // 30 for the rectangle width and 2 for padding
    return Int(screenWidth / boxWidth)
  }

  var body: some View {

    ZStack {
      Color.white
        .opacity(0.5)
        .edgesIgnoringSafeArea(.all)

      VStack {
        HStack(alignment: .center) {
          closeButton
          Text("Showing Selected Colors Likely To Print True Sorted by \(sortStrings[iP!])")
        }
         colorContent
        Spacer()
      }
      .padding()
      .background(Color.white)
      .cornerRadius(8)
      .shadow(radius: 10)
      .padding()
    }
  } // end body

  private var closeButton: some View {
    Button(action: {
      popupManager.showingPrintableColorsPopups = Array(repeating: false, count: 6)
    }) {
      Image(systemName: "xmark.circle")
    }
    .padding(.top, 10)
  }

  private var colorContent: some View {

    ScrollView {

      VStack {

        let arrCGs = MandMath.getPrintableCGColorListSorted(iSort: iP!)

        let nColumns = 32
        ForEach(0 ..< arrCGs.count / nColumns) { rowIndex in
          HStack(spacing: 0) {
            ForEach(0 ..< nColumns) { columnIndex in
              let index = rowIndex * nColumns + columnIndex
              let c = arrCGs[index]

              let components = c.components!
              let colorValueR = "\(Int(components[0] * 255))"
              let colorValueG = "\(Int(components[1] * 255))"
              let colorValueB = "\(Int(components[2] * 255))"

              VStack {
                Rectangle()
                  .fill(Color(red: Double(components[0]), green: Double(components[1]), blue: Double(components[2])))
                  .frame(width: 26, height: 26)
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

    } // end scrollview
  }
}
