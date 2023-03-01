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

/// Hue is a **sorted color** used in a MandArt image.
/// It includes the user-specified sort order,
/// the individual r, g, and b files, and a
/// [Color](https://developer.apple.com/documentation/swiftui/color)
/// object for use with a
/// [ColorPicker](https://developer.apple.com/documentation/swiftui/colorpicker)
///
/// Conforms to the `Codable`, `Identifiable`, and `ObservableObject` protocols
///
/// Codable: The Codable protocol in Swift allows for easy encoding and decoding
/// of custom data types into various formats such as JSON or Property List (plist).
///
/// This protocol enables us to encode and decode instances of the Hue class
/// to and from an external representation (such as JSON data) for purposes
/// such as storage or transfer of the data.
///
/// Identifiable: The Identifiable protocol in Swift is used to identify objects within a collection.
/// When working with collections of objects in SwiftUI,
///
/// Identifiable objects provide a unique identifier that is used to distinguish each object
/// in the collection. In this case, using the Identifiable protocol in the Hue class
/// helps us to keep track of individual instances of the class within a collection of Hue objects.
///
/// ObservableObject: The ObservableObject protocol in Swift
/// is used to make an object observable by SwiftUI.
///
/// When an object conforms to this protocol,
/// SwiftUI automatically subscribes to any changes made to the object
/// and updates its views whenever the object changes.
/// This is particularly useful when working with data that changes over time,
/// and you want to reflect those changes in your user interface.
///
/// In this case, the Hue class is used as a source of data for views
/// in the MandArt application, and marking the class as ObservableObject
/// allows the views to be updated whenever the data in the Hue instances changes.
///
///
/// This class has features only available in macOS 12.0 and later.
@available(macOS 12.0, *)
class Hue: Codable, Identifiable, ObservableObject {
  var id = UUID()
  var num: Int = 1
  var r: Double = 0.0
  var g: Double = 255.0
  var b: Double = 0.0
  var color: Color

  /// Initializes an instance of `Hue` with default values
  ///
  /// - Returns: A new instance of `Hue` with default values (white)
  ///
  init() {
    self.num = 0
    self.r = 255
    self.g = 255
    self.b = 255
    self.color = Color(.sRGB, red: self.r / 255, green: self.g / 255, blue: self.b / 255)
  }

  /// Initializes an instance of the `Hue` structure with given values for `num`, `r`, `g` and `b`
  ///
  /// - Parameters:
  ///   - num: The integer value representing the number of the hue.
  ///   - r: The red component of the hue color in the range of 0.0 to 255.0.
  ///   - g: The green component of the hue color in the range of 0.0 to 255.0.
  ///   - b: The blue component of the hue color in the range of 0.0 to 255.0.
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

  /// Updates the RGB values of the color based on the `cgColor` parameter.
  ///
  /// - Parameter cgColor: The `CGColor` object
  /// from which to extract the RGB values.
  ///
  func updateColorFromPicker(cgColor: CGColor) {
    if let arr = cgColor.components {
      self.r = arr[0]
      self.g = arr[1]
      self.b = arr[2]
    } else {
      self.r = 0
      self.g = 0
      self.b = 0
    }
  }

  ///  Get the lookup string for this instance of a  Hue
  ///  For example:
  ///  000-027-255
  func getLookupString() -> String {
    let strR = String(format: "%03d", Int(r))
    let strG = String(format: "%03d", Int(g))
    let strB = String(format: "%03d", Int(b))
    let lookupString: String = strR + "-" + strG + "-" + strB
    return lookupString
  }

  /// Print to the console a string representing this Hue
  /// after selecting a new printable color
  /// Use either opton to display the color in either this format:
  ///    000-027-255
  /// Or this format, so we can add to the
  ///    list of printable colors:
  ///    [0, 27, 255], // printable crayon
  func printColorInfo() {
    //      let s = self.getLookupString()
    //       print(s)
    let strR = String(format: "%d", Int(r))
    let strG = String(format: "%d", Int(g))
    let strB = String(format: "%d", Int(b))
    print("[\(strR),\(strG),\(strB)], // printable crayons")
  }
}

// MARK: Equatable

/// Extension that conforms to the `Equatable` protocol for the `Hue` class.
///
/// This extension allows two `Hue` objects to be compared
/// for equality based on their `id`, `num`, `r`, `g`, `b`, and `color` properties.
///
/// - Note:
/// Make sure the `Hue` class has the required properties to be compared for equality.
@available(macOS 12.0, *)
extension Hue: Equatable {
  static func == (lhs: Hue, rhs: Hue) -> Bool {
    lhs.id == rhs.id &&
      lhs.num == rhs.num &&
      lhs.r == rhs.r &&
      lhs.g == rhs.g &&
      lhs.b == rhs.b &&
      lhs.color == rhs.color
  }
}

/// This extension provides a platform-specific implementation
/// for converting a `Color` instance into its red, green, blue, and alpha components.
///
///  Private Extension of `Color` class:
///
/// This extension provides the implementation of the `colorComponents` property,
/// which converts a `Color` instance into its red, green, blue, and alpha components
/// represented as `CGFloat` values.
///
/// The `colorComponents` property uses conditional compilation to
/// handle different platforms, `macOS` and `iOS`.
///
/// - On `macOS`, the `SystemColor` type alias is defined as `NSColor`.
/// - On `iOS`, the `SystemColor` type alias is defined as `UIColor`.
///
/// The implementation of the `colorComponents` property uses the
///  `getRed(_:green:blue:alpha:)` method
///  of the platform-specific `SystemColor` type to extract
///  the red, green, blue, and alpha components of the `Color` instance.
///
/// - On `macOS`, the `getRed(_:green:blue:alpha:)` method
/// of `NSColor` is used to extract the components.
///
/// - On `iOS`, the `getRed(_:green:blue:alpha:)` method
/// of `UIColor` is used to extract the components.
///
/// If the `getRed(_:green:blue:alpha:)` method
/// fails to extract the components (e.g. because the `Color` instance
/// is not in RGB format), the `colorComponents` property returns `nil`.
///
/// Note: The color should be convertible into RGB format.
/// Colors using hue, saturation and brightness won't work.
///
/// See:
/// http://brunowernimont.me/howtos/make-swiftui-color-codable
///
@available(macOS 12.0, *)
private extension Color {
  #if os(macOS)
  typealias SystemColor = NSColor
  #else
  typealias SystemColor = UIColor
  #endif

  var colorComponents: (
    red: CGFloat,
    green: CGFloat,
    blue: CGFloat,
    alpha: CGFloat
  )? {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    #if os(macOS)
    SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
    // Note that non RGB color will raise an exception,
    // don't now how to catch because it is an Objc exception.
    #else
    guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
      // Color should be convertible into RGB format
      // Colors using hue, saturation and brightness won't work
      return nil
    }
    #endif
    return (r, g, b, a)
  }
}

// MARK: - Color + Codable

///
/// Extension of the `Color` class to conform to the `Codable` protocol.
///
/// This allows the `Color` class to be encoded into
/// and decoded from data representation,
/// such as JSON or property list data.
///
@available(macOS 10.15, *)
extension Color: Codable {
  // Define the keys for encoding and decoding the color data.
  enum CodingKeys: String, CodingKey {
    case red
    case green
    case blue
  }

  /*
   Initializer for decoding the `Color` object from data representation.

   - Parameters:
   - decoder: A decoder object that holds the data to be decoded.

   - Throws:
   `DecodingError` if the data representation is invalid
   or cannot be converted to a `Color` object.

   - Returns:
   A `Color` object initialized with the decoded data.
   */
  public init(from decoder: Decoder) throws {
    // Extract color data from the decoder using the defined coding keys.
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let r = try container.decode(Double.self, forKey: .red)
    let g = try container.decode(Double.self, forKey: .green)
    let b = try container.decode(Double.self, forKey: .blue)

    // Initialize a `Color` object with the decoded data.
    self.init(red: r, green: g, blue: b)
  }

  ///
  /// Method for encoding the `Color` object into data representation.
  ///
  ///  - Parameters:
  ///  - encoder: An encoder object that will encode the `Color` object.
  ///
  ///  - Throws:
  ///  `EncodingError` if the `Color` object cannot be encoded
  ///   into the desired data representation.
  ///
  @available(macOS 10.15, *)
  public func encode(to encoder: Encoder) throws {
    // check if mac0S 12 is available

    if #available(macOS 12.0, *) {
      // Check if the color components are available.
      guard let colorComponents else {
        return
      }

      // Create a container for the encoded data.
      var container = encoder.container(keyedBy: CodingKeys.self)

      // Encode the red, green, and blue components of the color.
      try container.encode(colorComponents.red, forKey: .red)
      try container.encode(colorComponents.green, forKey: .green)
      try container.encode(colorComponents.blue, forKey: .blue)

    } else {
      print("Error: macOS 12.0 or later required to use this feature.")
    }
  }
}
