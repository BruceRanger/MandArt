import SwiftUI
import UniformTypeIdentifiers

struct ContentViewPopups: View {

  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()

  @Binding var activeDisplayState: ActiveDisplayChoice

  init(doc: MandArtDocument,
       popupManager: PopupManager,
       activeDisplayState: Binding<ActiveDisplayChoice>) {
    self.doc = doc
    self._popupManager = ObservedObject(wrappedValue: popupManager)
    self._activeDisplayState = activeDisplayState
  }

  var body: some View {

    ScrollView {

      // there are 6 printable popups (one for each of 6 sorts)
      ForEach(0..<6) { index in
        if popupManager.showingPrintableColorsPopups[index] {
          PopupPrintableColors(popupManager: popupManager,
                               hues: doc.picdef.hues,
                               iP: $popupManager.iP,
                               showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
        }
      }
    }
    .edgesIgnoringSafeArea(.top) // Cover entire window

  } // body

}
