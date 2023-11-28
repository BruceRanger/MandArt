import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabColorListView: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  @State private var showingPrintablePopups = Array(repeating: false, count: 100)

  // Update hue nums after moviing or deleting
  internal func updateHueNums() {
    for (index, _) in self.$doc.picdef.hues.enumerated() {
      self.doc.picdef.hues[index].num = index + 1
    }
  }

  internal func getIsPrintable(color: Color, num: Int) -> Bool {
    if MandMath.isColorNearPrintableList(color: color.cgColor!, num: num) {
      return true
    } else {
      return false
    }
  }

  var body: some View {

    // Wrap the list in a geometry reader so it will
    // shrink when items are deleted
    GeometryReader { geometry in

      List {
        ForEach($doc.picdef.hues, id: \.num) { $hue in
          let i = hue.num - 1
          let isPrintable = getIsPrintable(color: $hue.wrappedValue.color, num: $hue.wrappedValue.num)

          HStack {
            TextField("number", value: $hue.num, formatter: MAFormatters.fmtIntColorOrderNumber)
              .disabled(true)
              .frame(maxWidth: 15)

            ColorPicker("", selection: $hue.color, supportsOpacity: false)
              .onChange(of: hue.color) { newColor in
                doc.updateHueWithColorPick(
                  index: i, newColorPick: newColor
                )
              }

            if !isPrintable {
              Button {
                self.showingPrintablePopups[i] = true
              } label: {
                Image(systemName: "exclamationmark.circle")
                  .foregroundColor(.blue)
              }
              .help("See printable options for " + "\(hue.num)")
            } else {
              Button {
                //
              } label: {
                Image(systemName: "exclamationmark.circle")
              }
              .hidden()
              .disabled(true)
            }
            if self.showingPrintablePopups[i] {
              ZStack {
                Color.white
                  .opacity(0.5)

                VStack {
                  Button(action: {
                    self.showingPrintablePopups[i] = false
                  }) {
                    Image(systemName: "xmark.circle")
                  }

                  VStack {
                    Text("This color may not print well.")
                    Text("See the instructions for options.")
                  } // end VStack of color options
                } // end VStack
                .frame(width: 150, height: 100)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 10)
              } // end ZStack for popup
              .transition(.scale)
            } // end if self.showingPrintablePopups[i]

            // enter red

            TextField("255", value: $hue.r, formatter: MAFormatters.fmt0to255) { isStarted in
              if isStarted {
                activeDisplayState = .Colors
              }
            }
            .onChange(of: hue.r) { newValue in
              doc.updateHueWithColorComponent(index: i, r: newValue)
            }

            // enter green

            TextField("255", value: $hue.g, formatter: MAFormatters.fmt0to255) { isStarted in
              if isStarted {
                activeDisplayState = .Colors
              }
            }
            .onChange(of: hue.g) { newValue in
              doc.updateHueWithColorComponent(index: i, g: newValue)

            }

            // enter blue

            TextField("255", value: $hue.b, formatter: MAFormatters.fmt0to255) { isStarted in
              if isStarted {
                activeDisplayState = .Colors
              }
            }
            .onChange(of: hue.b) { newValue in
              doc.updateHueWithColorComponent(index: i, b: newValue)
            }

            Button(role: .destructive) {
              doc.deleteHue(index: i)
              updateHueNums()
            } label: {
              Image(systemName: "trash")
            }
            .help("Delete " + "\(hue.num)")
          }
        } // end foreach
        .onMove { indices, hue in
          doc.picdef.hues.move(
            fromOffsets: indices,
            toOffset: hue
          )
          updateHueNums()
        }
      } // end list
      .frame(height: geometry.size.height)

    } // end geometry reader
    .frame(maxHeight: .infinity)

  } // end body
}
