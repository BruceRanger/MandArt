import SwiftUI

/// ImageViewModel: A ViewModel in the MVVM architecture pattern.
/// A ViewModel serves as an intermediary between the Model (`MandArtDocument`) and the View.
/// It is responsible for all the UI logic needed to prepare data for presentation by the View.
class ImageViewModel: ObservableObject {
  /// The main document that the ViewModel interacts with to get and set data.
  @Published var doc: MandArtDocument

  /// A binding to track the current display state in the UI, e.g., whether the view is showing MandArt, Gradient, or Colors.
  @Binding var activeDisplayState: ActiveDisplayChoice

  /// Initializes a new instance of the ViewModel.
  ///
  /// - Parameters:
  ///   - doc: The main MandArtDocument.
  ///   - activeDisplayState: A binding to the active display state.

  init(doc: MandArtDocument, activeDisplayState: Binding<ActiveDisplayChoice>) {
    self.doc = doc
    self._activeDisplayState = activeDisplayState
  }

  /// Calculates the right color number based on the validity of the left gradient.
  ///
  /// - Parameter leftGradientIsValid: A boolean indicating if the left gradient is valid.
  /// - Returns: The right color number.
  func getCalculatedRightNumber(leftGradientIsValid: Bool) -> Int {
    if leftGradientIsValid, doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  /// Determines if the left gradient is valid based on the left number.
  ///
  /// - Returns: A boolean indicating if the left gradient is valid.
  func getLeftGradientIsValid() -> Bool {
    var isValid = false
    let leftNum = doc.picdef.leftNumber
    let lastPossible = doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  /// Retrieves the appropriate image to display based on the current active display state.
  ///
  /// - Returns: An optional `CGImage` depending on the active display state.
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
