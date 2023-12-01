import SwiftUI
import UniformTypeIdentifiers

struct TabColorListRow: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var hue: Hue

  @State private var showingPrintablePopups = false

  func updateHueNums() {
    DispatchQueue.main.async {
      for (index, _) in self.doc.picdef.hues.enumerated() {
        self.doc.picdef.hues[index].num = index + 1
      }
    }
  }

  func getIsPrintable(color: Color) -> Bool {
    MandMath.isColorNearPrintableList(color: color.cgColor!, num: hue.num)
  }

  var body: some View {
    HStack {
      TextField("number", value: $hue.num, formatter: MAFormatters.fmtIntColorOrderNumber)
        .disabled(true)
        .frame(maxWidth: 15)

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
        ZStack { // show non printable color popup message
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
          } // end VStack
          .frame(width: 150, height: 100)
          .background(Color.secondary)
          .cornerRadius(8)
          .shadow(radius: 10)
        } //  ZStack for popup information
        .transition(.scale)
      }

      // Red, Green, Blue text fields
      TextField("255", value: $hue.r, formatter: MAFormatters.fmt0to255)
        .onChange(of: hue.r) { newValue in
          doc.updateHueWithColorComponent(index: hue.num - 1, r: newValue)
        }
      TextField("255", value: $hue.g, formatter: MAFormatters.fmt0to255)
        .onChange(of: hue.g) { newValue in
          doc.updateHueWithColorComponent(index: hue.num - 1, g: newValue)
        }
      TextField("255", value: $hue.b, formatter: MAFormatters.fmt0to255)
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
    }
  }
}
