import SwiftUI
import UniformTypeIdentifiers

/// A view representing a row in the color list.
struct TabColorListRow: View {
  @ObservedObject var doc: MandArtDocument
  @State private var showingPrintablePopups = false
  @State private var didChange = false

  let index: Int

  var hue: Hue {
    doc.picdef.hues[index]
  }

  var rowNumber: Int {
    index + 1
  }

  func updateArt() {
    for (index, _) in doc.picdef.hues.enumerated() {
      doc.picdef.hues[index].num = index + 1
    }
    self.didChange.toggle()
  }

  var isIndexValid: Bool {
    doc.picdef.hues.indices.contains(index)
  }


  /// Updates the hue numbers asynchronously.
  func updateHueNums() {
    DispatchQueue.main.async {
      for (index, _) in self.doc.picdef.hues.enumerated() {
        self.doc.picdef.hues[index].num = index + 1
      }
    }
  }

  /// Estimates whether a color will print true based on its proximity to a printable color.
  /// - Parameter color: The color to check for printability.
  /// - Returns: `true` if the color is likely to print true, `false` otherwise.
  func getIsPrintable(color: Color) -> Bool {
    MandMath.isColorNearPrintableList(color: color.cgColor!, num: hue.num)
  }

  var body: some View {

    if isIndexValid {
      HStack {
        Image(systemName: "line.horizontal.3")
          .foregroundColor(.secondary)

        Text(String(rowNumber))

        ColorPicker("", selection: Binding<Color>(
          get: { self.hue.color },
          set: { newColor in
            var updatedHue = self.hue
            updatedHue.color = newColor
            doc.updateHueWithColorPick(index: index, newColorPick: newColor, undoManager: nil)

          }),          supportsOpacity: false
        )

        Button {
          showingPrintablePopups = true
        } label: {
          Image(systemName: "exclamationmark.circle")
            .opacity(getIsPrintable(color: hue.color) ? 0 : 1)
        }
        .opacity(getIsPrintable(color: hue.color) ? 0 : 1)
        .help("See printable options for " + "\(rowNumber)")

        if showingPrintablePopups {
          // popup message
          ZStack {
            VStack {
              Button(action: {
                self.showingPrintablePopups = false
              }) {
                Image(systemName: "xmark.circle")
              }
              VStack {
                Text("This color may not print well.")
                Text("See the instructions for options.")
              }
            } //  VStack
          } //  ZStack for popup information
          .frame(width: 150, height: 100)
          .background(
            RoundedRectangle(cornerRadius: 15)
              .opacity(0.2)
              .shadow(radius: 5, y: 5)
          )
        }
        Text(String(format: "%03d", Int(hue.r)))
        Text(String(format: "%03d", Int(hue.g)))
        Text(String(format: "%03d", Int(hue.b)))

        Button(role: .destructive) {
          doc.deleteHue(index: index)
          updateArt()
        } label: {
          Image(systemName: "trash")
        }
        .help("Delete " + "\(rowNumber)")

        Spacer()
      }
    }
  }
}
