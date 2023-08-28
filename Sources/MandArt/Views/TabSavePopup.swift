import SwiftUI
import UniformTypeIdentifiers

struct TabSavePopup: View {

  @ObservedObject var popupManager = PopupManager()

  init(
    popupManager: PopupManager) {
      self.popupManager = popupManager
    }

 

  var body: some View {


   Divider()
    Group{

      HStack(alignment: .top) {
        Text("Sort by Blues")
          .font(.headline)
          .fontWeight(.medium)
        Button("Cube View"){
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .Blue
        }
      }

      HStack {

        Text("Green-Red:")

        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllColorsPopups[0] = true
        }
        .padding([.bottom], 2)

        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllPrintableColorsPopups[0] = true
        }
        .padding([.bottom], 2)

        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[0] = true
        }
        .padding([.bottom], 2)

      }

      HStack {
        Text("Red-Green:")
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllColorsPopups[2] = true
        }
        .padding([.bottom], 2)
        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllPrintableColorsPopups[2] = true
        }
        .padding([.bottom], 2)
        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[2] = true
        }
        .padding([.bottom], 2)

      }

    }
    Divider()

    Group {

      HStack(alignment: .top) {
        Text("Sort by Greens")
          .font(.headline)
          .fontWeight(.medium)
        Button("Cube View"){
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .Green
        }
      }
      HStack {
        Text("Blue-Red:")
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllColorsPopups[1] = true
        }
        .padding([.bottom], 2)

        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllPrintableColorsPopups[1] = true
        }
        .padding([.bottom], 2)

        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[1] = true
        }
        .padding([.bottom], 2)
      } // END HSTACK

      HStack {
        Text("Red-Blue:")
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllColorsPopups[4] = true
        }
        .padding([.bottom], 2)
        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllPrintableColorsPopups[4] = true
        }
        .padding([.bottom], 2)
        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[4] = true
        }
        .padding([.bottom], 2)
      }
     

    }
    Divider()
    Group {

      HStack(alignment: .top) {
        Text("Sort by Reds")
          .font(.headline)
          .fontWeight(.medium)
        Button("Cube View"){
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .Red
        }
      }

      HStack {

        Text("Blue-Green:")
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllColorsPopups[3] = true
        }
        .padding([.bottom], 2)
        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllPrintableColorsPopups[3] = true
        }
        .padding([.bottom], 2)
        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[3] = true
        }
        .padding([.bottom], 2)
      } // END HSTACK

      HStack {

        Text("Green-Blue:")
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllColorsPopups[5] = true
        }
        .padding([.bottom], 2)
        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingAllPrintableColorsPopups[5] = true
        }
        .padding([.bottom], 2)
        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[5] = true
        }
        .padding([.bottom], 2)
      } // END  HSTACK START WITH BLUE
    }

  }
}
