extension Double {
  func customFormattedString(maxPlaces: Int = 15) -> String {
    // Check if the number is an integer
    if self.truncatingRemainder(dividingBy: 1) == 0 {
      return String(format: "%.0f", self)
    } else {
      // Find out how many decimal places are needed
      let places = min(maxPlaces, String(self).split(separator: ".").last?.count ?? 0)
      return String(format: "%.\(places)f", self)
    }
  }
}
