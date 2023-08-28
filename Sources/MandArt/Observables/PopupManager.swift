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


  @Published var showingAllColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iAll: Int?

  @Published var showingAllPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iAP: Int?

  @Published var showingPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iP: Int?

  @Published var showingCube: ShowingCube = .None

  private var cancellables: [AnyCancellable] = []

  init() {
    $showingAllColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iAll, on: self)
      .store(in: &cancellables)

    $showingAllPrintableColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iAP, on: self)
      .store(in: &cancellables)

    $showingPrintableColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iP, on: self)
      .store(in: &cancellables)
  }

  func resetAllPopupsToFalse() {
    showingAllColorsPopups = Array(repeating: false, count: 6)
    showingPrintableColorsPopups = Array(repeating: false, count: 6)
    showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
    showingCube = .None

  }
}
