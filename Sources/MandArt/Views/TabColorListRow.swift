import SwiftUI
import UniformTypeIdentifiers

/// A view representing a row in the color list.
struct TabColorListRow: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var hue: Hue

  @State private var showingPrintablePopups = false

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

    HStack(spacing: 10) {
      Image(systemName: "line.horizontal.3")
        .foregroundColor(.secondary) // Set the color as needed

      TextField("number", value: $hue.num, formatter: MAFormatters.fmtIntColorOrderNumber)
        .disabled(true)

      ColorPicker("", selection: $hue.color, supportsOpacity: false)
        .onChange(of: hue.color) { newColor in
          doc.updateHueWithColorPick(
            index: hue.num - 1, newColorPick: newColor
          )
        }

      Button {
        showingPrintablePopups = true
      } label: {
        Image(systemName: "exclamationmark.circle")
          .opacity(getIsPrintable(color: hue.color) ? 0 : 1) // Set opacity
      }
      .opacity(getIsPrintable(color: hue.color) ? 0 : 1) // Set opacity
      .help("See printable options for " + "\(hue.num)")

      if showingPrintablePopups {
        ZStack { // popup message
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

      // Red, Green, Blue just text display all 3 char
      Text(String(format: "%03d", Int(hue.r)))
        .onChange(of: hue.r) { newValue in
          doc.updateHueWithColorComponent(index: hue.num - 1, r: newValue)
        }
      Text(String(format: "%03d", Int(hue.g)))
        .onChange(of: hue.g) { newValue in
          doc.updateHueWithColorComponent(index: hue.num - 1, g: newValue)
        }
      Text(String(format: "%03d", Int(hue.b)))
        .onChange(of: hue.b) { newValue in
          doc.updateHueWithColorComponent(index: hue.num - 1, b: newValue)
        }

      Button(role: .destructive) {
        doc.deleteHue(index: hue.num - 1)
        updateHueNums()
      } label: {
        Image(systemName: "trash")
      }
      .help("Delete " + "\(hue.num)")


      Spacer()

    }
  }
}
