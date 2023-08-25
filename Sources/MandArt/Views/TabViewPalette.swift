import SwiftUI
import UniformTypeIdentifiers

struct TabViewPalette: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

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

        ColorListView(doc: doc, activeDisplayState: $activeDisplayState)
          .background(Color.red.opacity(0.5))
          .frame(height: 300)

      }// end section

      Spacer() // Pushes everything above it to take as little space as possible

    } // end vstack
  } // end body

}
