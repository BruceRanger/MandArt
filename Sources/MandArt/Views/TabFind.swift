import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFind: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  var body: some View {
    ScrollView {
      VStack {

        TabFindImageSize(doc: doc, activeDisplayState: $activeDisplayState)

        TabFindImageCenter(doc: doc, activeDisplayState: $activeDisplayState)

        TabFindScale(doc: doc, activeDisplayState: $activeDisplayState)

        TabFindRotateAndMore(doc: doc, activeDisplayState: $activeDisplayState)

        Spacer()

      } //  vstack
    } // scrollview
  }
}
