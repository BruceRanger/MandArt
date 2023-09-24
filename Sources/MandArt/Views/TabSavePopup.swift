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

    Text("These colors tend to print true, sorted by:")

    Group {

      HStack {

        Button("r, g, b") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[0] = true
        }
        .padding([.bottom], 2)

        Button("r, b, g") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[1] = true
        }
        .padding([.bottom], 2)

        Button("g, r, b") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[2] = true
        }
        .padding([.bottom], 2)

      } // end HStack

      HStack {

        Button("g, b, r") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[3] = true
        }
        .padding([.bottom], 2)

        Button("b, r, g") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[4] = true
        }
        .padding([.bottom], 2)

        Button("b, g, r") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingPrintableColorsPopups[5] = true
        }
        .padding([.bottom], 2)

      } // end HStack

    } // end group

    Divider()

    Group {

      HStack(alignment: .top) {
        Text("Color cube with blue slices")
          .font(.headline)
          .fontWeight(.medium)

      }

      HStack {

        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .AllBlue
        }
        .padding([.bottom], 2)

        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .APBlue
        }
        .padding([.bottom], 2)
      }

    } // end group

    Divider()

    Group {

      HStack(alignment: .top) {
        Text("Color cube with red slices")
          .font(.headline)
          .fontWeight(.medium)

      }
      HStack {
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .AllGreen
        }
        .padding([.bottom], 2)

        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .APGreen
        }
        .padding([.bottom], 2)

      } // END HSTACK

    }
    Divider()
    Group {

      HStack(alignment: .top) {
        Text("Collor cube with green slices")
          .font(.headline)
          .fontWeight(.medium)
      }

      HStack {
        Button("All") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .AllRed
        }
        .padding([.bottom], 2)
        Button("All/Printable") {
          popupManager.resetAllPopupsToFalse()
          popupManager.showingCube = .APRed        }
        .padding([.bottom], 2)

      } // END HSTACK

    }

  }
}
