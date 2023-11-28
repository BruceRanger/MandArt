import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabSavePopup: View {
  @ObservedObject var popupManager = PopupManager()

  init(
    popupManager: PopupManager
  ) {
    self.popupManager = popupManager
  }

  var body: some View {
    Divider()

    Text("These colors tend to print true, sorted by:")

    Group {
      HStack {
        Button("r, g, b") {
          popupManager.clear()
          popupManager.showingPrintables = .RGB
        }
        .padding([.bottom], 2)

        Button("r, b, g") {
          popupManager.clear()
          popupManager.showingPrintables = .RBG
        }
        .padding([.bottom], 2)

        Button("g, r, b") {
          popupManager.clear()
          popupManager.showingPrintables = .GRB
        }
        .padding([.bottom], 2)
      } // end HStack

      HStack {
        Button("g, b, r") {
          popupManager.clear()
          popupManager.showingPrintables = .GBR
        }
        .padding([.bottom], 2)

        Button("b, r, g") {
          popupManager.clear()
          popupManager.showingPrintables = .BRG
        }
        .padding([.bottom], 2)

        Button("b, g, r") {
          popupManager.clear()
          popupManager.showingPrintables = .BGR
        }
        .padding([.bottom], 2)
      } // end HStack
    } // end group

    Divider() // ================================

    Group {
      HStack(alignment: .top) {
        Text("Color cube with blue slices")
          .font(.headline)
          .fontWeight(.medium)
      }

      HStack {
        Button("All") {
          popupManager.clear()
          popupManager.showingCube = .AllBlue
        }
        .padding([.bottom], 2)

        Button("All/Printable") {
          popupManager.clear()
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
          popupManager.clear()
          popupManager.showingCube = .AllGreen
        }
        .padding([.bottom], 2)

        Button("All/Printable") {
          popupManager.clear()
          popupManager.showingCube = .APGreen
        }
        .padding([.bottom], 2)
      } // END HSTACK
    }
    Divider()
    Group {
      HStack(alignment: .top) {
        Text("Color cube with green slices")
          .font(.headline)
          .fontWeight(.medium)
      }

      HStack {
        Button("All") {
          popupManager.clear()
          popupManager.showingCube = .AllRed
        }
        .padding([.bottom], 2)
        Button("All/Printable") {
          popupManager.clear()
          popupManager.showingCube = .APRed
        }
        .padding([.bottom], 2)
      } // END HSTACK
    }
  }
}
