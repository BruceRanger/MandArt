import Foundation

class MACommaNumberFormatter: NumberFormatter {
  override init() {
    super.init()
    numberStyle = .decimal
    groupingSeparator = ","
    usesGroupingSeparator = true
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func number(from string: String) -> NSNumber? {
    // Try without modification
    if let number = super.number(from: string) {
      return number
    }

    // If that fails, try by stripping out commas
    let noCommas = string.replacingOccurrences(of: groupingSeparator, with: "")
    if let noCommaNumber = super.number(from: noCommas) {
      return noCommaNumber
    }

    // If all fails, return nil
    return nil
  }
}
