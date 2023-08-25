import SwiftUI
import UniformTypeIdentifiers

struct TabbedView: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice
  @State private var selectedTab = 0

  var body: some View {

    TabView(selection: $selectedTab) {

      TabViewSize(doc: doc, activeDisplayState: $activeDisplayState)
              .tabItem {
          Label("1.Size", systemImage: "aspectratio")
        }.tag(0)

      TabViewFind(doc: doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("2.Find", systemImage: "arrow.up")
        }.tag(1)

      TabViewPalette(doc: doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("3.Color", systemImage: "paintbrush")
        }.tag(2)

      TabViewGradient(doc: doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("4.Test", systemImage: "paintbrush")
        }.tag(3)

      TabViewTune(doc: doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("5.Tune", systemImage: "paintpalette")
        }.tag(4)

      TabViewSave(doc: doc)
        .tabItem {
          Label("6.Save", systemImage: "circle")
        }.tag(5)

    } // end tabview
  } // end body
}
