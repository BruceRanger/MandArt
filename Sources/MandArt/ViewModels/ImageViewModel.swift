import SwiftUI

@available(macOS 12.0, *)
class ImageViewModel: ObservableObject {
  @Published var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool

  private var previousPicdef: PictureDefinition?
  private var _cachedArtImage: CGImage?

  var cachedArtImage: CGImage? {
    get {
      if _cachedArtImage == nil || keyVariablesChanged {
        print("Calculating new image")
        var colors: [[Double]] = doc.picdef.hues.map { [$0.r, $0.g, $0.b] }
        let art = ArtImage(picdef: doc.picdef)
        _cachedArtImage = requiresFullCalc ?
          art.getMandArtFullPictureImage(colors: &colors) :
          art.getNewlyColoredImage(colors: &colors)
      }
      return _cachedArtImage
    }
    set {
      _cachedArtImage = newValue
    }
  }

  init(doc: MandArtDocument, requiresFullCalc: Binding<Bool>, showGradient: Binding<Bool>) {
    self.doc = doc
    _requiresFullCalc = requiresFullCalc
    _showGradient = showGradient
  }

  func getCalculatedRightNumber(leftGradientIsValid: Bool) -> Int {
    if leftGradientIsValid, doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  func getLeftGradientIsValid() -> Bool {
    var isValid = false
    let leftNum = doc.picdef.leftNumber
    let lastPossible = doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  private var keyVariablesChanged: Bool {
    guard let previousPicdef = previousPicdef else {
      self.previousPicdef = doc.picdef
      return true
    }

    let hasChanged =
      previousPicdef.imageWidth != doc.picdef.imageWidth ||
      previousPicdef.imageHeight != doc.picdef.imageHeight ||
      previousPicdef.xCenter != doc.picdef.xCenter ||
      previousPicdef.yCenter != doc.picdef.yCenter ||
      previousPicdef.theta != doc.picdef.theta ||
      previousPicdef.scale != doc.picdef.scale ||
      previousPicdef.iterationsMax != doc.picdef.iterationsMax ||
      previousPicdef.rSqLimit != doc.picdef.rSqLimit

    if hasChanged {
      self.previousPicdef = doc.picdef
    }

    return hasChanged
  }

  func getImage() -> CGImage? {
    print("getImage() with full calc=\(requiresFullCalc)")

    if showGradient && getLeftGradientIsValid() {
      print("Showing Gradient")
      return getGradientImage()
    }

    // Now use the computed property
    return cachedArtImage
  }

  /// Generates a gradient image based on the left and right color values.
  ///
  /// - Returns: An optional `CGImage` representing the gradient.
  func getGradientImage() -> CGImage? {
    let leftNumber = doc.picdef.leftNumber
    let rightNumber = getCalculatedRightNumber(leftGradientIsValid: getLeftGradientIsValid())

    guard let leftColorRGBArray = doc.picdef.getColorGivenNumberStartingAtOne(leftNumber) else {
      return nil
    }
    guard let rightColorRGBArray = doc.picdef.getColorGivenNumberStartingAtOne(rightNumber) else {
      return nil
    }

    let gradientParameters = GradientImage.GradientImageInputs(
      imageWidth: 500, // self.doc.picdef.imageWidth,
      imageHeight: 500, // self.doc.picdef.imageHeight,
      leftColorRGBArray: leftColorRGBArray,
      rightColorRGBArray: rightColorRGBArray,
      gradientThreshold: 0.0 // self.doc.picdef.yY
    )
    return GradientImage.createCGImage(using: gradientParameters)
  }
}
