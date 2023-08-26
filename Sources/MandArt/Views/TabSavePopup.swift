


 import SwiftUI
 import UniformTypeIdentifiers

 struct TabSavePopup: View {

 @ObservedObject var popupManager = PopupManager()

 init(
 popupManager: PopupManager) {

 self.popupManager = popupManager
 }


 func resetAllPopupsToFalse() {
 popupManager.showingAllColorsPopups = Array(repeating: false, count: 6)
 popupManager.showingPrintableColorsPopups = Array(repeating: false, count: 6)
 popupManager.showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
 }


 var body: some View {

  


 // HSTACK START WITH RED

 Section(header:
 Text("Start with Reds")
 .font(.headline)
 .fontWeight(.medium)
 .padding([ .top])
 ) {


 HStack {


 Text("Sort by Rgb:")

 Button("All") {
 print("Rgb: Button A tapped")
 resetAllPopupsToFalse()
 popupManager.showingAllColorsPopups[0] = true
 }
 .padding([.bottom], 2)

 Button("All Printable") {
 resetAllPopupsToFalse()
 popupManager.showingAllPrintableColorsPopups[0] = true
 }
 .padding([.bottom], 2)

 Button("Printable") {
 resetAllPopupsToFalse()
 popupManager.showingPrintableColorsPopups[0] = true
 }
 .padding([.bottom], 2)

 }
 HStack {

 Text("Sort by Rbg:")

 Button("All") {
 resetAllPopupsToFalse()
 popupManager.showingAllColorsPopups[1] = true
 }
 .padding([.bottom], 2)

 Button("All Printable") {
 resetAllPopupsToFalse()
 popupManager.showingAllPrintableColorsPopups[1] = true
 }
 .padding([.bottom], 2)

 Button("Printable") {
 resetAllPopupsToFalse()
 popupManager.showingPrintableColorsPopups[1] = true
 }
 .padding([.bottom], 2)
 } // END HSTACK START WITH RED
 } // end section

 // HSTACK START WITH GREEN

 Section(header:
 Text("Start with Greens")
 .font(.headline)
 .fontWeight(.medium)
 .padding([ .top])
 ) {

 HStack {
 Text("Sort by Grb:")
 Button("All") {
 resetAllPopupsToFalse()
 popupManager.showingAllColorsPopups[2] = true
 }
 .padding([.bottom], 2)
 Button("All Printable") {
 resetAllPopupsToFalse()
 popupManager.showingAllPrintableColorsPopups[2] = true
 }
 .padding([.bottom], 2)
 Button("Printable") {
 resetAllPopupsToFalse()
 popupManager.showingPrintableColorsPopups[2] = true
 }
 .padding([.bottom], 2)

 }
 HStack {

 Text("Sort by Gbr:")
 Button("All") {
 resetAllPopupsToFalse()
 popupManager.showingAllColorsPopups[3] = true
 }
 .padding([.bottom], 2)
 Button("All Printable") {
 resetAllPopupsToFalse()
 popupManager.showingAllPrintableColorsPopups[3] = true
 }
 .padding([.bottom], 2)
 Button("Printable") {
 resetAllPopupsToFalse()
 popupManager.showingPrintableColorsPopups[3] = true
 }
 .padding([.bottom], 2)
 } // END HSTACK START WITH GREEN
 } // end section

 // HSTACK START WITH BLUE

 Section(header:
 Text("Start with Blues")
 .font(.headline)
 .fontWeight(.medium)
 .padding([ .top])
 ) {

 HStack {
 Text("Sort by Brg:")
 Button("All") {
 resetAllPopupsToFalse()
 popupManager.showingAllColorsPopups[4] = true
 }
 .padding([.bottom], 2)
 Button("All Printable") {
 resetAllPopupsToFalse()
 popupManager.showingAllPrintableColorsPopups[4] = true
 }
 .padding([.bottom], 2)
 Button("Printable") {
 resetAllPopupsToFalse()
 popupManager.showingPrintableColorsPopups[4] = true
 }
 .padding([.bottom], 2)


 }
 HStack {

 Text("Sort by Bgr:")
 Button("All") {
 resetAllPopupsToFalse()
 popupManager.showingAllColorsPopups[5] = true
 }
 .padding([.bottom], 2)
 Button("All Printable") {
 resetAllPopupsToFalse()
 popupManager.showingAllPrintableColorsPopups[5] = true
 }
 .padding([.bottom], 2)
 Button("Printable") {
 resetAllPopupsToFalse()
 popupManager.showingPrintableColorsPopups[5] = true
 }
 .padding([.bottom], 2)
 } // END  HSTACK START WITH BLUE
 } // end section


 }
 }

