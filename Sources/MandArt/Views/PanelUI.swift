import SwiftUI
import UniformTypeIdentifiers

struct PanelUI: View {

  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()

  @Binding var activeDisplayState: ActiveDisplayChoice

  @State private var selectedTab = 0

  init(doc: MandArtDocument,
       popupManager: PopupManager,
       activeDisplayState: Binding<ActiveDisplayChoice>) {

    self.doc = doc
    self.popupManager = popupManager
    _activeDisplayState = activeDisplayState
  }

  var body: some View {
      VStack {
        Text("MandArt Inputs")
          .font(.title)
          .padding(.top)

        TabbedView(doc: doc, popupManager: popupManager,
                   activeDisplayState: $activeDisplayState
                  )
        Spacer()
      }
      .frame(width: .infinity)

  }
}
