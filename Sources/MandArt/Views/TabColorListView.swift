import SwiftUI
import UniformTypeIdentifiers

/// A view that displays and manages a list of color hues.
///
/// This view is responsible for presenting a list of hues, each with options for modifying
/// its properties and checking for printability. Users can reorder, delete, or modify the color properties.
///
/// - Requires:
///   - macOS 12.0 or later.
@available(macOS 12.0, *)
struct TabColorListView: View {
  /// The document object containing MandArt data.
  /// This observable object is used to track and update the state of the MandArt.
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool
  @State private var showingPrintablePopups = Array(repeating: false, count: 100)

  /// Updates the numbering of hues after they have been moved or deleted.
  ///
  /// This function iterates through the hues and assigns each hue a number
  /// corresponding to its position in the list.
  func updateHueNums() {
    for (index, _) in $doc.picdef.hues.enumerated() {
      doc.picdef.hues[index].num = index + 1
    }
  }

  /// Determines if a color is near the printable list.
  ///
  /// This function checks whether a given color is close to a list of printable colors.
  ///
  /// - Parameters:
  ///   - color: The color to be checked.
  ///   - num: The number of the hue being checked.
  /// - Returns: A boolean indicating whether the color is near the printable list.
  func getIsPrintable(color: Color, num: Int) -> Bool {
    if MandMath.isColorNearPrintableList(color: color.cgColor!, num: num) {
      return true
    } else {
      return false
    }
  }

  var body: some View {
    // The main view body, containing a geometry reader and a list of hues.
    // We wrap the list in a geometry reader so it will
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
                  .foregroundColor(.red)
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
              } //  ZStack for popup
              .transition(.scale)
            } //  if self.showingPrintablePopups[i]

            // enter red

            TextField("255", value: $hue.r, formatter: MAFormatters.fmt0to255) { isStarted in
              if isStarted {
                showGradient = false
              }
            }
            .onChange(of: hue.r) { newValue in
              doc.updateHueWithColorComponent(index: i, r: newValue)
            }

            // enter green

            TextField("255", value: $hue.g, formatter: MAFormatters.fmt0to255) { isStarted in
              if isStarted {
                showGradient = false
              }
            }
            .onChange(of: hue.g) { newValue in
              doc.updateHueWithColorComponent(index: i, g: newValue)
            }

            // enter blue

            TextField("255", value: $hue.b, formatter: MAFormatters.fmt0to255) { isStarted in
              if isStarted {
                showGradient = false
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
        } // foreach
        .onMove { indices, hue in
          doc.picdef.hues.move(
            fromOffsets: indices,
            toOffset: hue
          )
          updateHueNums()
        }
      } //  list
      .frame(height: geometry.size.height)
    } // georeader
    .onAppear {
      requiresFullCalc = false
    }
    .frame(maxHeight: .infinity)
  }
}
