/**

 Hue

 This class is used to manage one color or hue entry in the MandArt project.

 Overview

 The Hue class provides a simple structure to manage one color or hue entry, with properties
 to store the color's num, r, g, and b values. It also conforms to the Codable, Identifiable, and
 ObservableObject protocols, allowing it to be easily encoded and decoded, and to be used
 as an object that can observe and respond to changes.

 Usage

 To use the Hue class, simply create an instance of it, providing values for its properties as desired.
 You can then encode and decode instances of the Hue class using the Encoder and Decoder classes,
 and you can use instances of the Hue class in your user interface, as they are identifiable and observable.

 Note: This class is only available on macOS 12 and higher.
 */

import Foundation
import SwiftUI

/**
 Represents a sorted color used in the MandArt project.

 Each `Hue` instance manages a single color with its RGB components and a corresponding SwiftUI `Color` object.
 It's used for sorting, encoding/decoding, and UI updates within the MandArt project.

 - `Codable`: Allows for JSON encoding/decoding.
 - `Identifiable`: Facilitates tracking and management in collections.
 - `ObservableObject`: Enables SwiftUI views to react to changes in `Hue` properties.

 Available from macOS 12.0 and later.
 */
@available(macOS 12.0, *)
class Hue: Codable, Identifiable, ObservableObject {
  var id = UUID()
  var num: Int = 1
  var r: Double = 0.0
  var g: Double = 255.0
  var b: Double = 0.0
  var color: Color

  /**
    Initializes an instance of `Hue` with default values

   - Returns: A new instance of `Hue` with default values (white)
   */
  init() {
    num = 0
    r = 255
    g = 255
    b = 255
    color = Color(.sRGB, red: r / 255, green: g / 255, blue: b / 255)
  }

  /** Initializes an instance of the `Hue` structure with given values for `num`, `r`, `g` and `b`

   - Parameters:
    - num: The integer value representing the number of the hue.
    - r: The red component of the hue color in the range of 0.0 to 255.0.
    - g: The green component of the hue color in the range of 0.0 to 255.0.
    - b: The blue component of the hue color in the range of 0.0 to 255.0.
   */
  init(num: Int, r: Double, g: Double, b: Double) {
    self.num = num
    self.r = r
    self.g = g
    self.b = b
    color = Color(
      .sRGB,
      red: self.r / 255,
      green: self.g / 255,
      blue: self.b / 255
    )
  }
}
