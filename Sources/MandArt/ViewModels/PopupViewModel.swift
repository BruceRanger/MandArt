import SwiftUI

class PopupViewModel: ObservableObject {

  @Published var activeDisplayState: ActiveDisplayChoice = .MandArt
  @Published var showingAllColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var showingPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)
  @Published var showingAllPrintableColorsPopups: [Bool] = Array(repeating: false, count: 6)

  func resetAllPopupsToFalse() {
    self.showingAllColorsPopups = Array(repeating: false, count: 6)
    self.showingPrintableColorsPopups = Array(repeating: false, count: 6)
    self.showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
  }
}
