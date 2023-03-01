/**

 PictureDefinition

 This class is used to manage the user inputs needed to create a MandArt project.

 Overview

 The PictureDefinition class provides a simple structure to manage
 the definition of one instance of MandArt.
 It conforms to the Codable and Identifiable protocols, allowing it to be easily encoded and decoded.
 The information it holds can be stored as a JSON file for reuse and sharing.

 Usage

 To use the PictureDefinition class, simply create an instance of it, providing values for its
 properties as desired. You can then encode and decode instances of the PictureDefinition class
 using the Encoder and Decoder classes, and you can an instance of the PictureDefinition class
 in each document-driven MandArt window.

 Note: This class is only available on macOS 12 and higher.
 */

import Foundation
import SwiftUI

/// The user input information defining a MandArt picture.
@available(macOS 12.0, *)
struct PictureDefinition: Codable, Identifiable {
  var id = UUID()
  var xCenter: Double = -0.75
  var yCenter: Double = 0.0
  var scale: Double = 430.0
  var iterationsMax: Double = 10000.0
  var rSqLimit: Double = 400.0
  var imageWidth: Int = 1100
  var imageHeight: Int = 1000
  var nBlocks: Int = 60
  var spacingColorFar: Double = 5.0
  var spacingColorNear: Double = 15.0
  var yY: Double = 0.0
  var theta: Double = 0.0
  var nImage: Int = 0
  var dFIterMin: Double = 0.0
  var leftNumber: Int = 1
  var hues: [Hue] = [
    Hue(num: 1, r: 0.0, g: 255.0, b: 0.0),
    Hue(num: 2, r: 255.0, g: 255.0, b: 0.0),
    Hue(num: 3, r: 255.0, g: 0.0, b: 0.0),
    Hue(num: 4, r: 255.0, g: 0.0, b: 255.0),
    Hue(num: 5, r: 0.0, g: 0.0, b: 255.0),
    Hue(num: 6, r: 0.0, g: 255.0, b: 255.0),
  ]
  var huesEstimatedPrintPreview: [Hue] = []
  var huesOptimizedForPrinter: [Hue] = []

  /// Initialize with an array of Hues (sorted rgbs)
  /// - Parameter hues: an array of hues
  init(hues: [Hue]) {
    self.hues = hues
  }

  /// Initialize by setting everything.
  /// - Parameters:
  ///   - xCenter: xCenter description
  ///   - yCenter: yC descriptionyCenter
  ///   - scale: <#scale description#>
  ///   - : <# description#>
  ///   - rSqLimit: <#rSqLimit description#>
  ///   - imageWidth: <#imageWidth description#>
  ///   - imageHeight: <#imageHeight description#>
  ///   - nBlocks: <#nBlocks description#>
  ///   - spacingColorFar: spacingColorFar description
  ///   - spacingColorNear: spacingColorNear description
  ///   - theta: <#theta description#>
  ///   - nImage: <#nImage description#>
  ///   - dFIterMin: <#dFIterMin description#>
  ///   - leftNumber: <#leftNumber description#>
  ///   - hues: <#hues description#>
  init(
    xCenter: Double,
    yCenter: Double,
    scale: Double,
    iterationsMax: Double,
    rSqLimit: Double,
    imageWidth: Int,
    imageHeight: Int,
    nBlocks: Int,
    spacingColorFar: Double,
    spacingColorNear: Double,
    yY: Double,
    theta: Double,
    nImage: Int,
    dFIterMin: Double,
    leftNumber: Int,
    hues: [Hue]
  ) {
    self.xCenter = xCenter
    self.yCenter = yCenter
    self.scale = scale
    self.iterationsMax = iterationsMax
    self.rSqLimit = rSqLimit
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.nBlocks = nBlocks
    self.spacingColorFar = spacingColorFar
    self.spacingColorNear = spacingColorNear
    self.yY = yY
    self.theta = theta
    self.nImage = nImage
    self.dFIterMin = dFIterMin
    self.leftNumber = leftNumber
    self.hues = hues
  }

  private func getHueFromLookupResponse(response: String, sortOrder: Int) -> Hue {
    // response is in format "000-000-000" need to get r / g / b
    let rStr: String = response[0 ..< 3]
    let gStr: String = response[4 ..< 7]
    let bStr: String = response[8 ..< 11]
    let red = Double(rStr)!
    let green = Double(gStr)!
    let blue = Double(bStr)!
    return Hue(num: sortOrder, r: red, g: green, b: blue)
  }

  /// Convert from a precise R G B double (0-255)
  ///  To a general bucketed value (0, 34, 68, 102, 136, 170, 204, 238, 255)
  /// - Parameter preciseValue: preciseValue a double from 0 to 255
  /// - Returns: a bucketed Double equal or less than the precise value
  fileprivate func getBucketColorDouble(preciseValue: Double) -> Double {
    var bucketValue = 0.0
    switch preciseValue {
    case 0 ..< 34:
      bucketValue = 0
    case 34 ..< 68:
      bucketValue = 34
    case 68 ..< 102:
      bucketValue = 68
    case 102 ..< 136:
      bucketValue = 102
    case 136 ..< 170:
      bucketValue = 136
    case 170 ..< 204:
      bucketValue = 170
    case 204 ..< 238:
      bucketValue = 204
    case 238 ..< 255:
      bucketValue = 238
    case 255:
      bucketValue = 255
    default:
      fatalError()
    }
    return bucketValue
  }

  fileprivate func getLookupStringFromHue(hue: Hue) -> String {
    let bucketR: Double = self.getBucketColorDouble(preciseValue: hue.r)
    let bucketG: Double = self.getBucketColorDouble(preciseValue: hue.g)
    let bucketB: Double = self.getBucketColorDouble(preciseValue: hue.b)
    let strR = String(format: "%03d", Int(bucketR))
    let strG = String(format: "%03d", Int(bucketG))
    let strB = String(format: "%03d", Int(bucketB))
    let lookupString: String = strR + "-" + strG + "-" + strB
    return lookupString
  }
}
