import SwiftUI
import UniformTypeIdentifiers

/// `PanelUI` is a SwiftUI view struct available for macOS 12.0 and later.
/// It provides a user interface panel for managing inputs and settings in the MandArt application.
/// This view allows users to interact with and control
/// the parameters of the Mandelbrot set generation and visualization process.
///
/// The view observes a `MandArtDocument` object for data related to the Mandelbrot set calculations
/// and binds to `requiresFullCalc` and `showGradient` to manage state updates and view rendering.
/// It also manages pop-up interactions through a `PopupManager` object, enhancing the user experience.
///
/// The view consists of a tabbed interface (`TabbedView`) that organizes settings and
/// options, to locate an interesting spot, specify the colors, and tune the way the image is displayed. It provides the
/// critical interface for users to interact with the core aspects of the MandArt application.
///
/// - Parameters:
///   - doc: An observed `MandArtDocument` object containing the current state and data of the Mandelbrot set.
///   - popupManager: An observed `PopupManager` object for managing pop-up interactions within the application.
///   - requiresFullCalc: A binding Bool that indicates whether a full calculation of the Mandelbrot set is needed.
///   - showGradient: A binding Bool that determines whether to display a gradient preview or a fully calculated image.
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
