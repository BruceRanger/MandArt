import SwiftUI

#if os(macOS)
  import AppKit
#else
  import UIKit
#endif

@available(macOS 12.0, *)
extension Color {
  #if os(macOS)
    typealias SystemColor = NSColor
  #else
    typealias SystemColor = UIColor
  #endif

  var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    #if os(macOS)
      // Using a do-catch for macOS to catch exceptions if the color isn't in RGB format
      do {
        SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
      }
    #else
      guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
        return nil
      }
    #endif

    return (r, g, b, a)
  }
}
