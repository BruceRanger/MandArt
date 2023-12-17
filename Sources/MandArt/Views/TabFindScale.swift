import SwiftUI
import UniformTypeIdentifiers

/// A view for adjusting and managing the scale of an image in the MandArt project.
///
/// This view provides a user interface for changing the image scale either through
/// direct input, standard zooming (by a factor of 2), or custom zooming based on a multiplier.
///
/// - Requires: macOS 12.0 or later
@available(macOS 12.0, *)
struct TabFindScale: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @State private var scale: Double
  @State private var scaleMultiplier: Double = 5.0000
  @State private var didChange: Bool = false
  @State private var scaleString: String = ""
  @State private var editedMultiplier: Double = 5.0 {
    didSet {
      if editedMultiplier < 1 {
        editedMultiplier = 1
      }
      scaleMultiplier = editedMultiplier
      didChange.toggle()
    }
  }

  /// Initializes the view with a document and a binding to determine if a full calculation is required.
  ///
  /// - Parameters:
  ///   - doc: The document containing the image and scale data.
  ///   - requiresFullCalc: A binding to a Boolean indicating whether a full recalculation is required.
  init(doc: MandArtDocument, requiresFullCalc: Binding<Bool>) {
    _doc = ObservedObject(initialValue: doc)
    _requiresFullCalc = requiresFullCalc
    _scale = State(initialValue: doc.picdef.scale)
    _scaleString = State(initialValue: doc.picdef.scale.customFormattedString())

  }

  /// Updates the scale value and synchronizes it across the document, the scale state, and the text field.
  ///
  /// - Parameter newScale: The new scale value to be set.
  func updateScale(newScale: Double) {
    scale = newScale
    doc.picdef.scale = scale
    scaleString = scale.customFormattedString()
    didChange = !didChange // Force redraw if needed
    requiresFullCalc = true
  }

  /// Increases the scale by a factor of 2.
  func zoomIn() {
    updateScale(newScale: scale * 2.0)
  }

  /// Decreases the scale by a factor of 2.
  func zoomOut() {
    updateScale(newScale: scale / 2.0)
  }

  /// Increases the scale by the custom scale multiplier.
  func zoomInCustom() {
    requiresFullCalc = true
    updateScale(newScale: scale * scaleMultiplier)
  }

  /// Decreases the scale by the custom scale multiplier.
  func zoomOutCustom() {
    requiresFullCalc = true
    updateScale(newScale: scale / scaleMultiplier)
  }

  var body: some View {
    Section(
      header:
      Text("Set Magnification")
        .font(.headline)
        .fontWeight(.medium)
    ) {
      HStack {
      //  Text("Magnification")
        TextField("",
                  text: $scaleString,
                  onCommit: {
          if let newScale = Double(scaleString) {
            updateScale(newScale: newScale)
          }
        })
        .textFieldStyle(.roundedBorder)
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: 180)
        .help("Enter the magnification (may take a while).")
        .onAppear {
          scaleString = doc.picdef.scale.customFormattedString()

        }
  
        .onChange(of: doc.picdef.scale) { _ in
          // Update scaleString whenever doc changes
          let newScaleString = doc.picdef.scale.customFormattedString()

          if newScaleString != scaleString {
            scaleString = newScaleString
          }
          didChange.toggle()
          requiresFullCalc = true
        }
      }
      .padding(.horizontal)

      HStack {
        VStack {
          Text("Zoom By 2")
          Text("  ")
          HStack {
            Button("+") { zoomIn() }
              .help("Zoom in by factor of 2 (may take a while).")
            Text("2")
            Button("-") { zoomOut() }
              .help("Zoom out by factor of 2 (may take a while).")
          }
        }
        Divider()

        VStack {
          Text("Custom Zoom ")
          Text("(1.0000 to 10.0000)")
          HStack {
            Button("+") { zoomInCustom() }
              .help("Zoom in by multiplier (may take a while).")

            // SCALE MULTIPLIER

            TextField(
              "",
              text: Binding(get: { "\(editedMultiplier)" }, set: { newValue in
                if let newMultiplier = Double(newValue) {
                  editedMultiplier = newMultiplier
                }
              }),
              onCommit: {
                if editedMultiplier < 1 {
                  editedMultiplier = 1
                }
                scaleMultiplier = editedMultiplier
                didChange.toggle()
              }
            )
            .onChange(of: scaleMultiplier) { newValue in
              print("in onchange")
              if newValue < 1 {
                print("updating from one")
                scaleMultiplier = 1
                didChange.toggle()
              }
            }
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(minWidth: 70, maxWidth: 90)
            .help("Maximum value of 10.")

            Button("-") { zoomOutCustom() }
              .help("Zoom out by multiplier (may take a while).")
          }
        }
      }
    }
    Divider()
  }
}
