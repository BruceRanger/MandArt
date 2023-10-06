import SwiftUI

class ImageViewModel: ObservableObject {
  @Published var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  private var previousPicdef: PictureDefinition?
  private var cachedArtImage: CGImage? {
        didSet {
          if cachedArtImage != nil {
            DispatchQueue.main.async {
              self.activeDisplayState = .Colors
            }
          }
        }
      }

  init(doc: MandArtDocument, activeDisplayState: Binding<ActiveDisplayChoice>) {
    self.doc = doc
    self._activeDisplayState = activeDisplayState
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
    print("getImage() called with \(activeDisplayState)")

    var colors: [[Double]] = doc.picdef.hues.map { [$0.r, $0.g, $0.b] }

    switch activeDisplayState {

      case .MandArtFull:
      print("MandArtFull")
      if  cachedArtImage == nil || keyVariablesChanged {
          print("   YES Full calculation required")
          print("       cachedArtImage nil: TRUE")
          let art = ArtImage(picdef: doc.picdef)
          cachedArtImage = art.getPictureImage(colors: &colors)
          return cachedArtImage
        } else {
          print("  NO Full calculation required")
          return cachedArtImage
        }
      case .Colors:
        print("Colors")
        let art = ArtImage(picdef: doc.picdef)
        cachedArtImage = art.getColorImage(colors: &colors)
        return cachedArtImage

      case .Gradient:
        print("Gradient")
        if getLeftGradientIsValid() {
          return getGradientImage()
        }
    }
    return nil

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
