import SwiftUI
import UniformTypeIdentifiers

struct TabbedView: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()

  @Binding var activeDisplayState: ActiveDisplayChoice
  @State private var selectedTab = 0

  init(doc: MandArtDocument,
       popupManager: PopupManager,
       activeDisplayState: Binding<ActiveDisplayChoice>)
  {
    self.doc = doc
    self.popupManager = popupManager
    self._activeDisplayState = activeDisplayState
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      TabFind(doc: doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("1.Find", systemImage: "aspectratio")
        }.tag(0)

      TabColor(doc: doc, popupManager: popupManager, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("2.Color", systemImage: "paintbrush")
        }.tag(1)

      TabTune(doc: doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("3.Tune", systemImage: "paintpalette")
        }.tag(2)

      TabSave(doc: doc, popupManager: popupManager)
        .tabItem {
          Label("4.Save", systemImage: "circle")
        }.tag(3)
    } // end tabview
    .padding(2)
  } // end body
}
