import SwiftUI
import UniformTypeIdentifiers

struct TabColor: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()
  @Binding var activeDisplayState: ActiveDisplayChoice

  var calculatedRightNumber: Int {
    if doc.picdef.leftNumber >= 1 && doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Section(header:
          Text("Choose Your Colors")
            .font(.headline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .center)

        ) {
          HStack {
            Button("Add New Color") { doc.addHue() }
              .help("Add a new color.")
              .padding([.bottom], 2)
          }

          TabColorListView(doc: doc, activeDisplayState: $activeDisplayState)
            .background(Color.red.opacity(0.5))
            .frame(height: 300)
        } // end section

        Section(header:
          Text("Test Gradient between Adjacent Colors")
            .font(.headline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .center)

        ) {
          HStack {
            Text("From:")
              .help("Choose the left color number.")

            Picker("Select a color number", selection: $doc.picdef.leftNumber) {
              ForEach(1 ..< doc.picdef.hues.count + 1, id: \.self) { index in
                Text("\(index)")
              }
            }
            .frame(maxWidth: 50)
            .labelsHidden()
            .help("Select the color number for the left side of a gradient.")
            .onChange(of: doc.picdef.leftNumber) { _ in
              activeDisplayState = .Gradient
            }

            Text("to \(calculatedRightNumber)")
              .help("The color number for the right side of a gradient.")

            Button("Display Gradient") {
              activeDisplayState = .Gradient
            }
            .help("Display a gradient to review the transition between adjoining colors.")

            Button("Display Art") {
              activeDisplayState = .MandArt
            }
            .help("Display art again after checking gradients.")
          } // end hstack
        } // end section

        Divider()

        Section(header:
          Text("")
            .font(.headline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
        ) {
          VStack(alignment: .leading) {
            Text("Click and drag the color number to reorder.")
            Text("Click on the color to modify.")
            Text("Click \(Image(systemName: "exclamationmark.circle")) to learn more.")
            Text("Some colors may not print true. See Tab 4.Save to explore options.")
          }

  //     {
          TabSavePopup(popupManager: popupManager)
   //     }   

        } // end section
      // {
  //        TabSavePopup(popupManager: popupManager)
      // } 

        Spacer() // Pushes everything above it to take as little space as possible
      } // end vstack
    } // end scrollview
  } // end body
} // end View
