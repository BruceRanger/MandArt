import SwiftUI
import UniformTypeIdentifiers

@available(macOS 12.0, *)
struct PanelUI: View {
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
    VStack {
      Text("MandArt Inputs")
        .font(.title)
        .padding(.top)

      TabbedView(
        doc: doc,
        popupManager: popupManager,
        requiresFullCalc: $requiresFullCalc,
        showGradient: $showGradient
      )
      Spacer()
    }
  }
}
