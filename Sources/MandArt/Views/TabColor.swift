import SwiftUI
import UniformTypeIdentifiers

struct TabColor: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  internal var calculatedRightNumber: Int {
    if doc.picdef.leftNumber >= 1 && doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  var body: some View {

    VStack(alignment: .leading) {

      Section(header:
                Text("Choose Your Colors")
        .font(.headline)
        .fontWeight(.medium)
        .padding(.bottom)
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

      }// end section

      Section(header:
                Text("Test Gradient between Adjacent Colors")
        .font(.headline)
        .fontWeight(.medium)
        .padding(.bottom)
      ) {
        HStack {
          Text("From (leftNumber)")

          Picker("Select a color number", selection: $doc.picdef.leftNumber) {
            ForEach(1..<doc.picdef.hues.count + 1, id: \.self) { index in
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

          Spacer() // Adjust layout

          Button("Draw Gradient") {
            activeDisplayState = .Gradient
          }
          .help("Draw a gradient between two adjoining colors.")
        } // end hstack
      } // end section

      Spacer() // Pushes everything above it to take as little space as possible

    } // end vstack
  } // end body

}
