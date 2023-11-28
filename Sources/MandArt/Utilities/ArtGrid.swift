import Foundation

@available(macOS 12.0, *)
enum ArtGrid {
  struct ArtGridInputs {
    let xCenter: Double
    let yCenter: Double
    let scale: Double
    let iterationsMax: Double
    let rSqLimit: Double
    let imageWidth: Int
    let imageHeight: Int
    let nBlocks: Int
    let spacingColorFar: Double
    let spacingColorNear: Double
    let yY: Double
    let theta: Double
    let nImage: Int
    let dFIterMin: Double
    let hues: [Hue]
  }
}
