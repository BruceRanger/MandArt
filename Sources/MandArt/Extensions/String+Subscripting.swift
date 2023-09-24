// Helper utility
// Extend String functionality so we can use indexes to get substrings
@available(macOS 12.0, *)
extension String {
  subscript(_ range: CountableRange<Int>) -> String {
    let start = index(startIndex, offsetBy: max(0, range.lowerBound))
    let end = index(start, offsetBy: min(
      count - range.lowerBound,
      range.upperBound - range.lowerBound
    ))
    return String(self[start ..< end])
  }

  subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
    let start = index(startIndex, offsetBy: max(0, range.lowerBound))
    return String(self[start...])
  }
}
