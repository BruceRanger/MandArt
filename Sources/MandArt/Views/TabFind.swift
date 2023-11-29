import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabFind: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool

  var body: some View {
    ScrollView {
      VStack {
        TabFindImageSize(doc: doc, requiresFullCalc: $requiresFullCalc)

        TabFindImageCenter(doc: doc, requiresFullCalc: $requiresFullCalc)

        TabFindScale(doc: doc, requiresFullCalc: $requiresFullCalc)

        TabFindRotateAndMore(doc: doc, requiresFullCalc: $requiresFullCalc)

        Spacer()
      } //  vstack
    } // scrollview
    .onAppear {
      requiresFullCalc = true
      showGradient = false
    }
    .onDisappear {
      if requiresFullCalc {
        requiresFullCalc = false
      }
    }
  }
}
