/**
 Exend `PictureDefinition` class to meet the `Equatable` protocol.

 Allows two `PictureDefinition` objects to be compared
 for equality based on their properties.

 */
@available(macOS 12.0, *)
extension PictureDefinition: Equatable {
  static func == (lhs: PictureDefinition, rhs: PictureDefinition) -> Bool {
    return lhs.xCenter == rhs.xCenter &&
      lhs.yCenter == rhs.yCenter &&
      lhs.scale == rhs.scale &&
      lhs.iterationsMax == rhs.iterationsMax &&
      lhs.rSqLimit == rhs.rSqLimit &&
      lhs.imageWidth == rhs.imageWidth &&
      lhs.imageHeight == rhs.imageHeight &&
      lhs.nBlocks == rhs.nBlocks &&
      lhs.spacingColorFar == rhs.spacingColorFar &&
      lhs.spacingColorNear == rhs.spacingColorNear &&
      lhs.yY == rhs.yY &&
      lhs.theta == rhs.theta &&
      lhs.nImage == rhs.nImage &&
      lhs.dFIterMin == rhs.dFIterMin &&
      lhs.leftNumber == rhs.leftNumber &&
      lhs.hues == rhs.hues
  }
}
