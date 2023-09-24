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
 Hue is a **sorted color** used in a MandArt image.
 It includes the user-specified sort order,
 the individual r, g, and b files, and a
 [Color](https://developer.apple.com/documentation/swiftui/color)
 object for use with a
 [ColorPicker](https://developer.apple.com/documentation/swiftui/colorpicker)

 Conforms to the `Codable`, `Identifiable`, and `ObservableObject` protocols

 Codable: The Codable protocol in Swift allows for easy encoding and decoding
 of custom data types into various formats such as JSON or Property List (plist).

 This protocol enables us to encode and decode instances of the Hue class
 to and from an external representation (such as JSON data) for purposes
 such as storage or transfer of the data.

 Identifiable: The Identifiable protocol in Swift is used to identify objects within a collection.
 When working with collections of objects in SwiftUI,

 Identifiable objects provide a unique identifier that is used to distinguish each object
 in the collection. In this case, using the Identifiable protocol in the Hue class
 helps us to keep track of individual instances of the class within a collection of Hue objects.

 ObservableObject: The ObservableObject protocol in Swift
 is used to make an object observable by SwiftUI.

 When an object conforms to this protocol,
 SwiftUI automatically subscribes to any changes made to the object
 and updates its views whenever the object changes.
 This is particularly useful when working with data that changes over time,
 and you want to reflect those changes in your user interface.

 In this case, the Hue class is used as a source of data for views
 in the MandArt application, and marking the class as ObservableObject
 allows the views to be updated whenever the data in the Hue instances changes.

 This class has features only available in macOS 12.0 and later.
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
    self.num = 0
    self.r = 255
    self.g = 255
    self.b = 255
    self.color = Color(.sRGB, red: self.r / 255, green: self.g / 255, blue: self.b / 255)
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
    self.color = Color(
      .sRGB,
      red: self.r / 255,
      green: self.g / 255,
      blue: self.b / 255
    )
  }

}
