

import Foundation

struct ArtPixelGridBuilder {

  static func calculatePixelGridForArt(
    _ picdef: PictureDefinition,
    _ colors: inout [[Double]]
  ) -> [[Double]] {
    var artPixels = [[Double]](repeating: [Double](repeating: 0.0, count: picdef.imageHeight),count: picdef.imageWidth)
    
    let imageHeight: Int = picdef.imageHeight
    let imageWidth: Int = picdef.imageWidth
    let iterationsMax: Double = picdef.iterationsMax
    let scale: Double = picdef.scale
    let xCenter: Double = picdef.xCenter
    let yCenter: Double = picdef.yCenter
    let theta: Double = -picdef.theta // in degrees
    let dFIterMin: Double = picdef.dFIterMin
    let pi = 3.14159
    let thetaR: Double = pi * theta / 180.0 // R for Radians
    let rSqLimit: Double = picdef.rSqLimit
    var rSq = 0.0
    var rSqMax = 0.0
    var x0 = 0.0
    var y0 = 0.0
    var dX = 0.0
    var dY = 0.0
    var xx = 0.0
    var yy = 0.0
    var xTemp = 0.0
    var iter = 0.0
    var dIter = 0.0
    var gGML = 0.0
    var gGL = 0.0
    var fIter = [[Double]](repeating: [Double](repeating: 0.0, count: imageHeight), count: imageWidth)
    var fIterMinLeft = 0.0
    var fIterMinRight = 0.0
    var fIterBottom = [Double](repeating: 0.0, count: imageWidth)
    var fIterTop = [Double](repeating: 0.0, count: imageWidth)
    var fIterMinBottom = 0.0
    var fIterMinTop = 0.0
    var fIterMins = [Double](repeating: 0.0, count: 4)
    var fIterMin = 0.0
    var p = 0.0
    var test1 = 0.0
    var test2 = 0.0

    rSqMax = 1.01 * (rSqLimit + 2) * (rSqLimit + 2)
    gGML = log(log(rSqMax)) - log(log(rSqLimit))
    gGL = log(log(rSqLimit))

    for u in 0 ... imageWidth - 1 {
      for v in 0 ... imageHeight - 1 {
        dX = (Double(u) - Double(imageWidth / 2)) / scale
        dY = (Double(v) - Double(imageHeight / 2)) / scale

        x0 = xCenter + dX * cos(thetaR) - dY * sin(thetaR)
        y0 = yCenter + dX * sin(thetaR) + dY * cos(thetaR)

        xx = x0
        yy = y0
        rSq = xx * xx + yy * yy
        iter = 0.0

        p = sqrt((xx - 0.25) * (xx - 0.25) + yy * yy)
        test1 = p - 2.0 * p * p + 0.25
        test2 = (xx + 1.0) * (xx + 1.0) + yy * yy

        if xx < test1 || test2 < 0.0625 {
          fIter[u][v] = iterationsMax // black
          iter = iterationsMax // black
        } // end if

        else {
          for i in 1 ... Int(iterationsMax) {
            if rSq >= rSqLimit {
              break
            }

            xTemp = xx * xx - yy * yy + x0
            yy = 2 * xx * yy + y0
            xx = xTemp
            rSq = xx * xx + yy * yy
            iter = Double(i)
          }
        } // end else

        if iter < iterationsMax {
          dIter = Double(-(log(log(rSq)) - gGL) / gGML)

          fIter[u][v] = iter + dIter
        } // end if

        else {
          fIter[u][v] = iter
        } // end else
      } // end first for v
    } // end first for u

    return artPixels
  }
}
