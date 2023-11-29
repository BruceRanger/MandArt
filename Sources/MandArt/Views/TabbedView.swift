import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct TabbedView: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool
  @State private var selectedTab = 0

  init(
    doc: MandArtDocument,
    popupManager: PopupManager,
    requiresFullCalc: Binding<Bool>,
    showGradient: Binding<Bool>
  ) {
    self.doc = doc
    self.popupManager = popupManager
    _requiresFullCalc = requiresFullCalc
    _showGradient = showGradient
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      TabFind(doc: doc, requiresFullCalc: $requiresFullCalc, showGradient: $showGradient)
        .tabItem {
          Label("1.Find", systemImage: "aspectratio")
        }.tag(0)

      TabColor(doc: doc, popupManager: popupManager, requiresFullCalc: $requiresFullCalc, showGradient: $showGradient)
        .tabItem {
          Label("2.Color", systemImage: "paintbrush")
        }.tag(1)

      TabTune(doc: doc, requiresFullCalc: $requiresFullCalc, showGradient: $showGradient)
        .tabItem {
          Label("3.Tune", systemImage: "paintpalette")
        }.tag(2)

      TabSave(doc: doc, popupManager: popupManager, requiresFullCalc: $requiresFullCalc, showGradient: $showGradient)
        .tabItem {
          Label("4.Save", systemImage: "circle")
        }.tag(3)
    } // end tabview
    .padding(2)
  }
}
