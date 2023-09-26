import SwiftUI
import UniformTypeIdentifiers

struct PanelDisplay: View {

  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice
  @State private var selectedTab = 0
  @State private var moved: Double = 0.0
  @State private var startTime: Date?

  var body: some View {

      VStack(alignment: .leading) {

        if activeDisplayState == .MandArt {

          let viewModel = ImageViewModel(doc: doc, activeDisplayState: $activeDisplayState)
            ZStack(alignment: .topLeading) {
              ScrollView([.horizontal, .vertical], showsIndicators: true) {

                if let cgImage = viewModel.getImage() {
                  Image(decorative: cgImage, scale: 1.0)
                    .frame(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
                    .gesture(self.tapGesture)
                } else {
                  Text("No Image Available")
                    .foregroundColor(.gray)
                }

              } // scrollview
            } // zstack

        } else if activeDisplayState == ActiveDisplayChoice.Gradient {

          let viewModel = ImageViewModel(doc: doc, activeDisplayState: $activeDisplayState)

          ZStack(alignment: .topLeading) {
            ScrollView([.horizontal, .vertical], showsIndicators: true) {

              if let cgImage = viewModel.getImage() {
                Image(decorative: cgImage, scale: 1.0)
                  .frame(width: CGFloat(cgImage.width), alignment: .topLeading)
              } else {
                Text("No Image Available")
                  .foregroundColor(.gray)
              }

            } // scroll
          } // zstack

        } else if activeDisplayState == ActiveDisplayChoice.Colors {

          let viewModel = ImageViewModel(doc: doc, activeDisplayState: $activeDisplayState)

          ZStack(alignment: .topLeading) {
            ScrollView([.horizontal, .vertical], showsIndicators: true) {

              if let cgImage = viewModel.getImage() {
                Image(decorative: cgImage, scale: 1.0)
                  .frame(width: CGFloat(cgImage.width), alignment: .topLeading)
              } else {
                Text("No Image Available")
                  .foregroundColor(.gray)
              }

            } // scroll
          } // zstack

        }

      } // end VStack right side (picture space)
      .padding(2)

  } // body

  /**
   tapGesture is a variable that defines a drag gesture
   for the user interaction in the user interface.

   The gesture is of type some Gesture
   and uses the DragGesture struct from the SwiftUI framework.

   The minimum distance for the drag gesture is set to 0 units,
   and the coordinate space for the gesture is set to .local.

   The onChanged closure is triggered
   when the gesture is changed by the user's interaction.

   The onEnded closure is triggered
   when the user lifts the mouse off the screen,
   indicating the tap gesture has completed.
   */
  var tapGesture: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .local)
      .onChanged { value in
        if self.activeDisplayState == .MandArt {
          // store distance the touch has moved as a sum of all movements
          self.moved += value.translation.width + value.translation.height
          // only set the start time if it's the first event
          if self.startTime == nil {
            self.startTime = value.time
          }
        }
      }
      .onEnded { tap in
        if self.activeDisplayState == .MandArt {
          // if we haven't moved very much, treat it as a tap event
          if self.moved < 2, self.moved > -2 {
            doc.picdef.xCenter = getCenterXFromTap(tap)
            doc.picdef.yCenter = getCenterYFromTap(tap)
            activeDisplayState = .MandArt // redraw after new center
          }
          // if we have moved a lot, treat it as a drag event
          else {
            doc.picdef.xCenter = getCenterXFromDrag(tap)
            doc.picdef.yCenter = getCenterYFromDrag(tap)
            activeDisplayState = .MandArt // redraw after drag
          }
          // reset tap event states
          self.moved = 0
          self.startTime = nil
        }
      }

  }

  /**
   Returns the new x to be the picture center x when user drags in the picture.

   - Parameter tap: information about the drag

   - Returns: Double new center x
   */
  func getCenterXFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let startX = tap.startLocation.x
    let startY = tap.startLocation.y
    let endX = tap.location.x
    let endY = tap.location.y
    let movedX = -(endX - startX)
    let movedY = endY - startY
    let thetaDegrees = Double(doc.picdef.theta)
    let thetaRadians = 3.14159 * thetaDegrees / 180
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale
    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    let newCenterX: Double = self.doc.picdef.xCenter + dCenterX
    return newCenterX
  }

  /**
   Returns the new y to be the picture center y when user drags in the picture.

   - Parameter tap: information about the drag

   - Returns: Double new center y
   */
  func getCenterYFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let startX = tap.startLocation.x
    let startY = tap.startLocation.y
    let endX = tap.location.x
    let endY = tap.location.y
    let movedX = -(endX - startX)
    let movedY = endY - startY
    let thetaDegrees = Double(doc.picdef.theta)
    let thetaRadians = 3.14159 * thetaDegrees / 180
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale
    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    let newCenterY: Double = self.doc.picdef.yCenter + dCenterY
    return newCenterY
  }

  /**
   Returns the new x to be the picture center x when user clicks on the picture.

   - Parameter tap: information about the tap

   - Returns: Double new center x = current x + (tapX - (imagewidth / 2.0)/ scale
   */
  func getCenterXFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let startX = tap.startLocation.x
    let startY = tap.startLocation.y
    let w = Double(doc.picdef.imageWidth)
    let h = Double(doc.picdef.imageHeight)
    let movedX = (startX - w / 2.0)
    let movedY = ((h - startY) - h / 2.0)
    let thetaDegrees = Double(doc.picdef.theta)
    let thetaRadians = 3.14159 * thetaDegrees / 180
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale
    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    let newCenterX: Double = self.doc.picdef.xCenter + dCenterX
    return newCenterX
  }

  /**
   Returns the new y to be the picture center y when user clicks on the picture.

   - Parameter tap: information about the tap

   - Returns: Double new center y = current y + ( (imageHeight / 2.0)/ scale - tapY)
   */
  func getCenterYFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
    let startX = tap.startLocation.x
    let startY = tap.startLocation.y
    let w = Double(doc.picdef.imageWidth)
    let h = Double(doc.picdef.imageHeight)
    let movedX = (startX - w / 2.0)
    let movedY = ((h - startY) - h / 2.0)
    let thetaDegrees = Double(doc.picdef.theta)
    let thetaRadians = 3.14159 * thetaDegrees / 180
    let diffX = movedX / self.doc.picdef.scale
    let diffY = movedY / self.doc.picdef.scale
    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    let newCenterY: Double = self.doc.picdef.yCenter + dCenterY
    return newCenterY
  }

}
