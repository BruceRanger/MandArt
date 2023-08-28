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
          popupManager.showingCube = .APBlue
        }
        .padding([.bottom], 2)

        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[0] = true
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
          popupManager.showingCube = .APGreen
        }
        .padding([.bottom], 2)

        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[1] = true
        }
        .padding([.bottom], 2)
      } // END HSTACK


     

    }
    Divider()
    Group {

      HStack(alignment: .top) {
        Text("Sort by Reds")
          .font(.headline)
          .fontWeight(.medium)

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
          popupManager.showingCube = .APRed        }
        .padding([.bottom], 2)
        Button("Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[3] = true
        }
        .padding([.bottom], 2)
      } // END HSTACK


    }

  }
}
