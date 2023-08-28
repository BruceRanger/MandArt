import SwiftUI
import Combine

class PopupManager: ObservableObject {

  @Published var showingAllColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iAll: Int?
  @Published var showingPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iAP: Int?
  @Published var showingAllPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var iP: Int?

  private var cancellables: [AnyCancellable] = []

  init() {
    $showingAllColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iAll, on: self)
      .store(in: &cancellables)

    $showingPrintableColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iP, on: self)
      .store(in: &cancellables)

    $showingAllPrintableColorsPopups
      .map { $0.firstIndex(of: true) }
      .assign(to: \.iAP, on: self)
      .store(in: &cancellables)
  }
}
