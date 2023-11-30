import SwiftUI
import UniformTypeIdentifiers

/// A view for adjusting and managing the scale of an image in the MandArt project.
///
/// This view provides a user interface for changing the image scale either through
/// direct input, standard zooming (by a factor of 2), or custom zooming based on a multiplier.
@available(macOS 12.0, *)
struct TabFindScale: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @State private var scale: Double
  @State private var scaleMultiplier: Double = 5.0000
  @State private var didChange: Bool = false
  @State private var scaleString: String = ""

  /// Initializes the view with a document and a binding to determine if a full calculation is required.
  ///
  /// - Parameters:
  ///   - doc: The document containing the image and scale data.
  ///   - requiresFullCalc: A binding to a Boolean indicating whether a full recalculation is required.
  init(doc: MandArtDocument, requiresFullCalc: Binding<Bool>) {
    _doc = ObservedObject(initialValue: doc)
    _requiresFullCalc = requiresFullCalc
    _scale = State(initialValue: doc.picdef.scale)
    _scaleString = State(initialValue: String(format: "%.0f", doc.picdef.scale))
  }

  /// Updates the scale value and synchronizes it across the document, the scale state, and the text field.
  ///
  /// - Parameter newScale: The new scale value to be set.
  func updateScale(newScale: Double) {
    scale = newScale.rounded()
    doc.picdef.scale = scale
    scaleString = String(format: "%.0f", scale)
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
    updateScale(newScale: scale * scaleMultiplier)
  }

  /// Decreases the scale by the custom scale multiplier.
  func zoomOutCustom() {
    updateScale(newScale: scale / scaleMultiplier)
  }

  var body: some View {
    Section(
      header:
      Text("Set Scale")
        .font(.headline)
        .fontWeight(.medium)
    ) {
      HStack {
        Text("Scale (scale)")
        TextField("Scale", text: $scaleString, onCommit: {
          if let newScale = Double(scaleString) {
            updateScale(newScale: newScale)
          }
        })
        .textFieldStyle(.roundedBorder)
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: 180)
        .help("Enter the magnification (may take a while).")
        .onAppear {
          scaleString = String(format: "%.0f", doc.picdef.scale)
        }
        .onChange(of: doc.picdef.scale) { _ in
          // Update scaleString whenever doc changes
          let newScaleString = String(format: "%.0f", doc.picdef.scale)
          if newScaleString != scaleString {
            scaleString = newScaleString
          }
          didChange = !didChange
          requiresFullCalc = true
        }
      }
      .padding(.horizontal)

      HStack {
        VStack {
          Text("Zoom By 2")
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
          Text("Custom Zoom")
          HStack {
            Button("+") { zoomInCustom() }
              .help("Zoom in by multiplier (may take a while).")

            DelayedTextFieldDouble(
              placeholder: String(format: "%.4f", scaleMultiplier),
              value: $scaleMultiplier,
              formatter: MAFormatters.fmtScaleMultiplier
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(minWidth: 60, maxWidth: 80)
            .onChange(of: doc.picdef.scale) { _ in
              requiresFullCalc = true
            }

            Button("-") { zoomOutCustom() }
              .help("Zoom out by multiplier (may take a while).")
          }
        }
      }
    }
    Divider()
  }
}
