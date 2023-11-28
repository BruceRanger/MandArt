import SwiftUI
import UniformTypeIdentifiers

/// `ContentViewPopups` is a SwiftUI `View` responsible for displaying specific popups based on the state of the
/// `PopupManager`.
@available(macOS 12.0, *)
struct ContentViewPopups: View {
  /// An observed document object containing the necessary data and state for rendering the content.
  @ObservedObject var doc: MandArtDocument

  /// An observed object responsible for managing the popups' display state.
  @ObservedObject var popupManager: PopupManager

  /// A binding to the state keeping track of whether a full calc (or just a recoloring) is required
  @Binding var requiresFullCalc: Bool

  /// Initializes the `ContentViewPopups` with necessary dependencies.
  /// - Parameters:
  ///   - doc: The main document data source.
  ///   - popupManager: An object managing the popups' display state.
  ///   - requiresFullCalc: A binding to control the calc
  init(
    doc: MandArtDocument,
    popupManager: PopupManager,
    requiresFullCalc: Binding<Bool>
  ) {
    self.doc = doc
    self.popupManager = popupManager
    _requiresFullCalc = requiresFullCalc
  }

  /// The main body of the `ContentViewPopups`.
  var body: some View {
    ScrollView {
      contentForPrintables
      contentForCube
    }
    .edgesIgnoringSafeArea(.top) // Cover entire window
  }

  ///  The printables popup (if any)
  private var contentForPrintables: some View {
    switch popupManager.showingPrintables {
    case .RGB, .RBG, .GBR, .GRB, .BGR, .BRG:
      return AnyView(PopupPrintableColors(doc: doc, popupManager: popupManager, hues: doc.picdef.hues))
    case .None:
      return AnyView(EmptyView())
    }
  }

  /// The color cube popup (if any)
  private var contentForCube: some View {
    switch popupManager.showingCube {
    case .APRed, .APGreen, .APBlue, .AllBlue, .AllRed, .AllGreen:
      return AnyView(PopupColorCube(doc: doc, popupManager: popupManager, hues: doc.picdef.hues))
    case .None:
      return AnyView(EmptyView())
    }
  }
}
