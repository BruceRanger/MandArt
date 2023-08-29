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

      if popupManager.showingPrintableColorsPopups[0] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[1] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[2] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[3] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[4] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else  if popupManager.showingPrintableColorsPopups[5] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingCube != .None {
        PopupColorCube(popupManager: popupManager, hues: doc.picdef.hues)

      }
    }
    .edgesIgnoringSafeArea(.top) // Cover entire window

  } // body

}
