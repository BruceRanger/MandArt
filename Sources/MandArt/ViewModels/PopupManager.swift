import SwiftUI

/// `PopupManager` is an observable object responsible for managing the display state of popups and other visual
/// components.
///
/// `ObservableObject` is a protocol from the SwiftUI framework. An object that conforms to the `ObservableObject`
/// protocol can be used inside a View and when any of its `@Published` properties change, the UI will update to reflect
/// those changes.
@available(macOS 10.15, *)
class PopupManager: ObservableObject {
  /// Enum representing the various states of the color cube popup shown.
  enum ShowingCube {
    case None
    case APRed
    case APGreen
    case APBlue
    case AllRed
    case AllGreen
    case AllBlue
  }

  /// Enum representing the various states of the printable colors popup shown.
  enum ShowingPrintables {
    case None
    case RGB
    case RBG
    case GRB
    case GBR
    case BRG
    case BGR
  }

  /// Represents the current state of the printables popup being shown.
  @Published var showingPrintables: ShowingPrintables = .None

  /// Represents the current state of the color cube popup being shown.
  @Published var showingCube: ShowingCube = .None

  init() {
    // Initial setup if needed
  }

  /// Resets all popups and cube states to their default values (i.e., not shown).
  func clear() {
    showingPrintables = .None
    showingCube = .None
  }
}
