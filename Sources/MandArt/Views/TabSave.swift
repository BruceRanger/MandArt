import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabSave: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()

  var body: some View {

    ScrollView {
      VStack {

        Section(header:
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
        }// end section

        Section(header:
                  Text("Check Colors Before Printing")
          .font(.headline)
          .fontWeight(.medium)
          .padding( .top)
        ) {

          TabSavePopup(popupManager: popupManager)

        } // end second section
        Spacer()

      } //  vstack
    } // scroll
  }
}
