import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabSave: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool

  var body: some View {
    ScrollView {
      VStack {
        Section(
          header:
          Text("Save Your Art")
            .font(.headline)
            .fontWeight(.medium)
            .padding(.bottom)
        ) {
          Button("Save Image (as .png)") {
            doc.saveMandArtImage()
          }
          .help("Save MandArt image as .png.")

          Button("Save Image Inputs (as data file)") {
            doc.saveMandArtImageInputs()
          }
          .help("Save MandArt image inputs as .mandart.")
        } // end section
      } //  vstack
    } // scroll
    .onAppear {
      requiresFullCalc = false
      showGradient = false
    }
    .onDisappear {
      if requiresFullCalc {
        requiresFullCalc = false
      }
    }
  }
}
