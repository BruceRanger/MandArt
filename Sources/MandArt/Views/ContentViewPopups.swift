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
      
      
      if popupManager.showingAllColorsPopups[0] {
        PopupAllColors(iAll: $popupManager.iAll,
                       showingAllColorsPopups: $popupManager.showingAllColorsPopups)
      } else
      if popupManager.showingAllPrintableColorsPopups[0] {
        PopupAllPrintableColors(iAP: $popupManager.iAP,
                                showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[0] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingAllColorsPopups[1] {
        PopupAllColors(iAll: $popupManager.iAll,
                       showingAllColorsPopups: $popupManager.showingAllColorsPopups)
      } else if popupManager.showingAllPrintableColorsPopups[1] {
        PopupAllPrintableColors(iAP: $popupManager.iAP,
                                showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[1] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingAllColorsPopups[2] {
        PopupAllColors(iAll: $popupManager.iAll,
                       showingAllColorsPopups: $popupManager.showingAllColorsPopups)
      } else if popupManager.showingAllPrintableColorsPopups[2] {
        PopupAllPrintableColors(iAP: $popupManager.iAP,
                                showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[2] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingAllColorsPopups[3] {
        PopupAllColors(iAll: $popupManager.iAll,
                       showingAllColorsPopups: $popupManager.showingAllColorsPopups)
      } else if popupManager.showingAllPrintableColorsPopups[3] {
        PopupAllPrintableColors(iAP: $popupManager.iAP,
                                showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[3] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingAllColorsPopups[4] {
        PopupAllColors(iAll: $popupManager.iAll,
                       showingAllColorsPopups: $popupManager.showingAllColorsPopups)
      } else if popupManager.showingAllPrintableColorsPopups[4] {
        PopupAllPrintableColors(iAP: $popupManager.iAP,
                                showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
      } else if popupManager.showingPrintableColorsPopups[4] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      } else if popupManager.showingAllColorsPopups[5] {
        PopupAllColors(iAll: $popupManager.iAll,
                       showingAllColorsPopups: $popupManager.showingAllColorsPopups)
      } else if popupManager.showingAllPrintableColorsPopups[5] {
        PopupAllPrintableColors(iAP: $popupManager.iAP,
                                showingAllPrintableColorsPopups: $popupManager.showingAllPrintableColorsPopups)
      } else  if popupManager.showingPrintableColorsPopups[5] {
        PopupPrintableColors(iP: $popupManager.iP,
                             showingPrintableColorsPopups: $popupManager.showingPrintableColorsPopups)
      }
      else if popupManager.showingCube != .None {
        PopupColorCube(popupManager: popupManager)
      }
    }
    .edgesIgnoringSafeArea(.top) // Cover entire window
    
  } // body
  
}
