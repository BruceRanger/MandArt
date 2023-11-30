import SwiftUI

/// A ViewModel for managing and displaying images in a SwiftUI view.
/// This class handles the logic for calculating images based on the provided document,
/// and manages whether a full calculation is required or if a gradient should be shown.
@available(macOS 12.0, *)
class ImageViewModel: ObservableObject {
  @Published var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool

  private var previousPicdef: PictureDefinition?
  private var _cachedArtImage: CGImage?

  /// A computed property for managing a cached MandArt image.
  /// It checks if a new image calculation is required based on the current document settings.
  var cachedArtImage: CGImage? {
    get {
      if _cachedArtImage == nil || keyVariablesChanged {
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

  /// Initializes a new instance of `ImageViewModel`.
  /// - Parameters:
  ///   - doc: A `MandArtDocument` instance containing the image details.
  ///   - requiresFullCalc: A binding to a Boolean value indicating whether a full image calculation is required.
  ///   - showGradient: A binding to a Boolean value indicating whether to show a gradient.
  init(doc: MandArtDocument, requiresFullCalc: Binding<Bool>, showGradient: Binding<Bool>) {
    self.doc = doc
    _requiresFullCalc = requiresFullCalc
    _showGradient = showGradient
  }

  /// Calculates the right number for gradient display based on whether the left gradient number is valid.
  /// - Parameter leftGradientIsValid: A Boolean indicating whether the left gradient number is valid.
  /// - Returns: The calculated right number for the gradient.
  func getCalculatedRightNumber(leftGradientIsValid: Bool) -> Int {
    if leftGradientIsValid, doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  /// Determines whether the left gradient number is valid.
  /// - Returns: A Boolean indicating whether the left gradient number is valid.
  func getLeftGradientIsValid() -> Bool {
    var isValid = false
    let leftNum = doc.picdef.leftNumber
    let lastPossible = doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  /// A private computed property to check if key variables of the picture definition have changed.
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

  /// Retrieves the current image to be displayed.
  /// This method decides whether to return a cached image, calculate a new image,
  /// or show a gradient based on the current state.
  /// - Returns: An optional `CGImage` representing the current image.
  func getImage() -> CGImage? {
    if showGradient && getLeftGradientIsValid() {
      return getGradientImage()
    }
    return cachedArtImage
  }

  /// Generates a gradient image based on the left and right color values.
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
