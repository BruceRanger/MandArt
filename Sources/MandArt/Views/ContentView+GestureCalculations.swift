import SwiftUI

extension ContentView {

  /**
   Calculates the x-coordinate of the picture's center after a user's drag gesture.

   - Parameter tap: Information about the drag.
   - Returns: The new center x-coordinate, adjusted for the drag position.
   */
  internal func getCenterXFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let movedX = tap.startLocation.x - tap.location.x
    let movedY = tap.location.y - tap.startLocation.y

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale

    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    return self.doc.picdef.xCenter + dCenterX
  }

  /**
   Calculates the y-coordinate of the picture's center after a user's drag gesture.

   - Parameter tap: Information about the drag.
   - Returns: The new center y-coordinate, adjusted for the drag position.
   */
  internal func getCenterYFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let movedX = tap.startLocation.x - tap.location.x
    let movedY = tap.location.y - tap.startLocation.y

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale

    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    return self.doc.picdef.yCenter + dCenterY
  }

  /**
   Calculates the x-coordinate of the picture's center after a user's tap gesture.

   - Parameter tap: Information about the tap.
   - Returns: The new center x-coordinate, adjusted for the tap position.
   */
  internal func getCenterXFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let halfImageWidth = Double(doc.picdef.imageWidth) / 2.0
    let halfImageHeight = Double(doc.picdef.imageHeight) / 2.0

    let movedX = tap.startLocation.x - halfImageWidth
    let movedY = halfImageHeight - (Double(doc.picdef.imageHeight) - tap.startLocation.y)

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale

    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    return self.doc.picdef.xCenter + dCenterX
  }

  /**
   Calculates the y-coordinate of the picture's center after a user's tap gesture.

   - Parameter tap: Information about the tap.
   - Returns: The new center y-coordinate, adjusted for the tap position.
   */
  internal func getCenterYFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let halfImageWidth = Double(doc.picdef.imageWidth) / 2.0
    let halfImageHeight = Double(doc.picdef.imageHeight) / 2.0

    let movedX = tap.startLocation.x - halfImageWidth
    let movedY = halfImageHeight - (Double(doc.picdef.imageHeight) - tap.startLocation.y)

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale

    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    return self.doc.picdef.yCenter + dCenterY
  }

}
