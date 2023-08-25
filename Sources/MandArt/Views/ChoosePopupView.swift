import SwiftUI
import UniformTypeIdentifiers

struct ChoosePopupView: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupViewModel = PopupViewModel()

  var body: some View {

    Group {
      // HSTACK START WITH RED
      HStack {
        Text("Rgb:")

        Button("A") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllColorsPopups[0] = true
        }
        .padding([.bottom], 2)

        Button("AP") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllPrintableColorsPopups[0] = true
        }
        .padding([.bottom], 2)

        Button("P") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingPrintableColorsPopups[0] = true
        }
        .padding([.bottom], 2)

        Text("Rbg:")

        Button("A") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllColorsPopups[1] = true
        }
        .padding([.bottom], 2)

        Button("AP") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllPrintableColorsPopups[1] = true
        }
        .padding([.bottom], 2)

        Button("P") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingPrintableColorsPopups[1] = true
        }
        .padding([.bottom], 2)
      } // END HSTACK START WITH RED

      // HSTACK START WITH GREEN

      HStack {
        Text("Grb:")
        Button("A") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllColorsPopups[2] = true
        }
        .padding([.bottom], 2)
        Button("AP") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllPrintableColorsPopups[2] = true
        }
        .padding([.bottom], 2)
        Button("P") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingPrintableColorsPopups[2] = true
        }
        .padding([.bottom], 2)
        Text("Gbr:")
        Button("A") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllColorsPopups[3] = true
        }
        .padding([.bottom], 2)
        Button("AP") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllPrintableColorsPopups[3] = true
        }
        .padding([.bottom], 2)
        Button("P") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingPrintableColorsPopups[3] = true
        }
        .padding([.bottom], 2)
      } // END HSTACK START WITH GREEN

      // HSTACK START WITH BLUE

      HStack {
        Text("Brg:")
        Button("A") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllColorsPopups[4] = true
        }
        .padding([.bottom], 2)
        Button("AP") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllPrintableColorsPopups[4] = true
        }
        .padding([.bottom], 2)
        Button("P") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingPrintableColorsPopups[4] = true
        }
        .padding([.bottom], 2)

        Text("Bgr:")
        Button("A") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllColorsPopups[5] = true
        }
        .padding([.bottom], 2)
        Button("AP") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingAllPrintableColorsPopups[5] = true
        }
        .padding([.bottom], 2)
        Button("P") {
          popupViewModel.resetAllPopupsToFalse()
          popupViewModel.showingPrintableColorsPopups[5] = true
        }
        .padding([.bottom], 2)
      } // END  HSTACK START WITH BLUE

    }

  }
}
