import SwiftUI
import Combine

class PopupManager: ObservableObject {

  enum ShowingCube {
    case None
    case APRed
    case APGreen
    case APBlue
    case AllRed
    case AllGreen
    case AllBlue
  }

  @Published var showingPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iP: Int?

  @Published var showingCube: ShowingCube = .None

  private var cancellables: [AnyCancellable] = []

  init() {

    $showingPrintableColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iP, on: self)
      .store(in: &cancellables)
  }

  func resetAllPopupsToFalse() {
    showingPrintableColorsPopups = Array(repeating: false, count: 6)
    showingCube = .None

  }
}
