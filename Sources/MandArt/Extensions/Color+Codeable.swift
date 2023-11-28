import SwiftUI

/**
 Extend `Color` class to conform to the `Codable` protocol, allowing encoding to and decoding from data representations.
 */
@available(macOS 12.0, *)
extension Color: Codable {
  enum CodingKeys: String, CodingKey {
    case red, green, blue
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let r = try container.decode(Double.self, forKey: .red)
    let g = try container.decode(Double.self, forKey: .green)
    let b = try container.decode(Double.self, forKey: .blue)
    self.init(red: r, green: g, blue: b)
  }

  public func encode(to encoder: Encoder) throws {
    guard let components = colorComponents else {
      return
    }

    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(components.red, forKey: .red)
    try container.encode(components.green, forKey: .green)
    try container.encode(components.blue, forKey: .blue)
  }
}
