import SwiftUI
import UniformTypeIdentifiers

struct TabFindScale: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice
  @State private var scale: Double
  @State private var scaleMultiplier: Double = 5.0000
  @State private var didChange: Bool = false
  @State private var scaleString: String = ""

  init(doc: MandArtDocument, activeDisplayState: Binding<ActiveDisplayChoice>) {
    self._doc = ObservedObject(initialValue: doc)
    self._activeDisplayState = activeDisplayState
    self._scale = State(initialValue: doc.picdef.scale)
    _scaleString = State(initialValue: String(format: "%.0f", doc.picdef.scale))
  }

  func zoomIn() {
    scale *= 2.0
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    didChange = !didChange // force redraw
  }

  func zoomOut() {
    scale /= 2.0
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    didChange = !didChange // force redraw
  }

  func zoomInCustom() {
    scale *= scaleMultiplier
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    activeDisplayState = .MandArtFull
  }

  func zoomOutCustom() {
    scale /= scaleMultiplier
    scale = scale.rounded() // Round to the nearest integer
    doc.picdef.scale = scale
    activeDisplayState = .MandArtFull
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
            doc.picdef.scale = newScale.rounded()
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
          print("TabFind: onChange scale")
          // Update scaleString whenever doc changes
          let newScaleString = String(format: "%.0f", doc.picdef.scale)
          if newScaleString != scaleString {
            scaleString = newScaleString
          }
          didChange = !didChange
          activeDisplayState = .MandArtFull
        }
      }
      .padding(.horizontal)

      //  Show Row (HStack) of Rotate and Zoom Next

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
            .frame(minWidth: 60, maxWidth: 80 )
            .onChange(of: doc.picdef.scale) { _ in
              print("TabFind: onChange scale")
              activeDisplayState = .MandArtFull
            }

            Button("-") { zoomOutCustom() }
              .help("Zoom out by multiplier (may take a while).")
          }
        }
      }

      //  Divider()

    }
    Divider()
  }
}
