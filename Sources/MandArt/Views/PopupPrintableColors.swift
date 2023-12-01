import AppKit
import SwiftUI

@available(macOS 12.0, *)
struct PopupPrintableColors: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager: PopupManager

  @State private var selectedColor: (r: Int, g: Int, b: Int)?

  var hues: [Hue]

  init(
    doc: MandArtDocument,
    popupManager: PopupManager,
    hues: [Hue]
  ) {
    self.doc = doc
    self.popupManager = popupManager
    self.hues = hues
  }

  /// Convert the current showingPrintables value to a string for display purposes.
  var currentSort: String {
    return "\(popupManager.showingPrintables)"
  }

  private var columnCount: Int {
    guard let screenWidth = NSScreen.main?.frame.width
    else { return 32 } // Default to 32 if screen width cannot be determined
    let boxWidth: CGFloat = 30.0 + 2 // 30 for the rectangle width and 2 for padding
    return Int(screenWidth / boxWidth)
  }

  private func handleColorSelection(components: [CGFloat]) {
    selectedColor = (r: Int(components[0] * 255), g: Int(components[1] * 255), b: Int(components[2] * 255))
    if let selected = selectedColor {
      doc.addHue(r: Double(selected.r), g: Double(selected.g), b: Double(selected.b))
    }
  }

  var body: some View {
    ZStack {
      Color(NSColor.windowBackgroundColor)
        .edgesIgnoringSafeArea(.all)

      VStack {
        HStack(alignment: .bottom) {
          closeButton
          Text("Click to add a color to your list. Showing Colors Likely To Print True Sorted by \(currentSort)")

          if let selected = selectedColor {
            Text("Added: (\(selected.r), \(selected.g), \(selected.b))")
          }
        } // hstack for button

        colorContent

        Spacer()
      } // vstack
      .padding()
      .cornerRadius(8)
      .shadow(radius: 10)
      .padding()
    }
    // .edgesIgnoringSafeArea(.all)
  } // end body

  private var closeButton: some View {
    Button(action: {
      popupManager.showingPrintables = .None
    }) {
      Image(systemName: "xmark.circle")
    }
    .padding(.top, 10)
  }

  private var colorContent: some View {
    ScrollView {
      VStack {
        let arrCGs = MandMath.getPrintableCGColorListSorted(sortType: popupManager.showingPrintables)

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

              Button(action: {
                handleColorSelection(components: c.components!)
              }) {
                VStack {
                  Rectangle()
                    .fill(Color(red: Double(components[0]), green: Double(components[1]), blue: Double(components[2])))
                    .frame(width: 26, height: 26)
                    .cornerRadius(4)
                    .padding(1)
                  Text(colorValueR)
                    .font(.system(size: 10))
                  Text(colorValueG)
                    .font(.system(size: 10))
                  Text(colorValueB)
                    .font(.system(size: 10))
                } // end vstack of rect, rgb values
              }
              .buttonStyle(PlainButtonStyle())
            } // column of colors
          } //  HStack of colors
        } //  each color
      } //  VStack of color options
    } //  scrollview
  } //  color content
}
