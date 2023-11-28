/**
 Exend `Hue` class to meet the `Equatable` protocol.

 Allows two `Hue` objects to be compared
 for equality based on their `id`, `num`, `r`, `g`, `b`, and `color` properties.

 */
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
