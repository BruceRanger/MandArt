import SwiftUI

@available(macOS 12.0, *)
extension ContentView {
  /**
   Calculates the x-coordinate of the picture's center after a user's drag gesture.

   - Parameter tap: Information about the drag.
   - Returns: The new center x-coordinate, adjusted for the drag position.
   */
  func getCenterXFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let movedX = tap.startLocation.x - tap.location.x
    let movedY = tap.location.y - tap.startLocation.y

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale

    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    return doc.picdef.xCenter + dCenterX
  }

  /**
   Calculates the y-coordinate of the picture's center after a user's drag gesture.

   - Parameter tap: Information about the drag.
   - Returns: The new center y-coordinate, adjusted for the drag position.
   */
  func getCenterYFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let movedX = tap.startLocation.x - tap.location.x
    let movedY = tap.location.y - tap.startLocation.y

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale

    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    return doc.picdef.yCenter + dCenterY
  }

  /**
   Calculates the x-coordinate of the picture's center after a user's tap gesture.

   - Parameter tap: Information about the tap.
   - Returns: The new center x-coordinate, adjusted for the tap position.
   */
  func getCenterXFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let halfImageWidth = Double(doc.picdef.imageWidth) / 2.0
    let halfImageHeight = Double(doc.picdef.imageHeight) / 2.0

    let movedX = tap.startLocation.x - halfImageWidth
    let movedY = halfImageHeight - (Double(doc.picdef.imageHeight) - tap.startLocation.y)

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale

    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    return doc.picdef.xCenter + dCenterX
  }

  /**
   Calculates the y-coordinate of the picture's center after a user's tap gesture.

   - Parameter tap: Information about the tap.
   - Returns: The new center y-coordinate, adjusted for the tap position.
   */
  func getCenterYFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let halfImageWidth = Double(doc.picdef.imageWidth) / 2.0
    let halfImageHeight = Double(doc.picdef.imageHeight) / 2.0

    let movedX = tap.startLocation.x - halfImageWidth
    let movedY = halfImageHeight - (Double(doc.picdef.imageHeight) - tap.startLocation.y)

    let thetaRadians = Double(doc.picdef.theta) * .pi / 180.0
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale

    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    return doc.picdef.yCenter + dCenterY
  }
}
