import SwiftUI
import UniformTypeIdentifiers

struct TabbedView: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice
  @State private var selectedTab = 0

  var body: some View {

    TabView(selection: $selectedTab) {

      TabView1Save(doc: doc)
            .tabItem {
          Label("1.Save", systemImage: "circle")
        }.tag(0)


      TabView2Size(doc: doc, activeDisplayState:$activeDisplayState)
              .tabItem {
          Label("2.Size", systemImage: "aspectratio")
        }.tag(1)

      TabView3CenterXYScale(doc:doc,activeDisplayState:$activeDisplayState)
        .tabItem {
          Label("3.XYScale", systemImage: "arrow.up")
        }.tag(2)

      TabView4Gradient(doc:doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("4.Test", systemImage: "paintbrush")
        }.tag(3)

      TabView5ColorTuning(doc:doc, activeDisplayState: $activeDisplayState)
        .tabItem {
          Label("5.Tune", systemImage: "paintpalette")
        }.tag(4)

    }
  }
}
