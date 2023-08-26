import SwiftUI

class ImageViewModel: ObservableObject {
  @Published var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

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

  /**
   Gets an image to display on the right side of the app

   - Returns: An optional CGImage or nil
   */
  func getImage() -> CGImage? {
    var colors: [[Double]] = doc.picdef.hues.map { [$0.r, $0.g, $0.b] }

    switch activeDisplayState {
      case .MandArt:
        let art = ArtImage(picdef: doc.picdef)
        let img = art.getPictureImage(colors: &colors)
        return img
      case .Gradient:
        if getLeftGradientIsValid() {
          return getGradientImage()
        }
        return nil
      case .Colors:
        let art = ArtImage(picdef: doc.picdef)
        let img = art.getColorImage(colors: &colors)
        return img
    }
  }

  func getGradientImage() -> CGImage? {
    print("getGradientImage")
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
