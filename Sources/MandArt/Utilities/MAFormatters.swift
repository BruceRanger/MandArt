import Foundation

enum MAFormatters {
  // USER INPUT CUSTOM FORMATTERS - BASIC  .........................


  static var fmtImageWidthHeight: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.isPartialStringValidationEnabled = true
    formatter.usesGroupingSeparator = false
    formatter.maximumFractionDigits = 0
    formatter.maximum = 100_000
    return formatter
  }
  
    static var fmtScale: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    //formatter.isPartialStringValidationEnabled = true
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 15
    formatter.minimum = 1
    formatter.maximum = 100_000_000_000_000_000
    return formatter
  }


  static var fmtXY: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 17
    formatter.maximum = 2.0
    formatter.minimum = -2.0
    return formatter
  }

  static var fmtRotationTheta: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    formatter.minimum = -359.9
    formatter.maximum = 359.9
    return formatter
  }

/*  static var fmtScaleMultiplier: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.isPartialStringValidationEnabled = true
    formatter.maximumFractionDigits = 4
    formatter.minimumFractionDigits = 0
    formatter.roundingMode = .halfUp
    formatter.minimum = 0.0001
    formatter.maximum = 99.9999
    return formatter
  }*/

  // USER INPUT CUSTOM FORMATTERS - GRADIENT  ....................

  static var fmtSharpeningItMax: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 8
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtSmootingRSqLimit: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtHoldFractionGradient: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimum = 0.00
    formatter.maximum = 1.00
    return formatter
  }

  static var fmtLeftGradientNumber: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  // USER INPUT CUSTOM FORMATTERS - COLORING  ....................

  static var fmtSpacingNearEdge: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtSpacingFarFromEdge: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtChangeInMinIteration: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 3
    formatter.minimum = -100_000_000
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtNBlocks: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  // USER INPUT CUSTOM FORMATTERS -ORDERED LIST OF COLORS (HUES) ...........

  static var fmtIntColorOrderNumber: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 8
    return formatter
  }

  static var fmt0to255: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 0
    formatter.maximum = 255
    return formatter
  }
}
