import SwiftUI
import UniformTypeIdentifiers

/// `PanelDisplay` is a SwiftUI view struct designed for macOS 12.0 and later.
/// It provides a panel for displaying generated images based on Mandelbrot set calculations.
/// This view manages the display of either a gradient or a bitmap image, depending on user selection,
/// and it supports interactive gestures for user engagement.
///
/// The view observes a `MandArtDocument` object and binds to `requiresFullCalc` and `showGradient`
/// to determine the state and type of image display. It uses a gesture system for interactive
/// image manipulation, allowing users to dynamically adjust the center of the Mandelbrot set rendering
/// by tapping (to specify the new center) and by dragging gestures.
///
/// The view dynamically updates based on changes in the `MandArtDocument`.
///  It can show either a gradient representation between two adjacent colors or a fully calculated Mandelbrot set
/// image.
///
/// - Parameters:
///   - doc: An observed `MandArtDocument` object containing image and calculation data.
///   - requiresFullCalc: A binding Bool indicating whether a full calculation is required for the image.
///   - showGradient: A binding Bool determining whether to show a gradient or a bitmap image.
@available(macOS 12.0, *)
struct PanelDisplay: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool
  @State private var selectedTab = 0
  @State private var moved: Double = 0.0
  @State private var startTime: Date?

  var body: some View {
    VStack(alignment: .leading) {
      let viewModel = ImageViewModel(doc: doc, requiresFullCalc: $requiresFullCalc, showGradient: $showGradient)

      if showGradient {
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
      } else {
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
      } // else art
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

        // store distance touch has moved as a sum of all movements
        self.moved += value.translation.width + value.translation.height
        // only set the start time if it's the first event
        if self.startTime == nil {
          self.startTime = value.time
        }
      }
      .onEnded { tap in

        // if not moved much, treat it as a tap event
        if self.moved < 2, self.moved > -2 {
          self.doc.picdef.xCenter = self.getCenterXFromTap(tap)
          self.doc.picdef.yCenter = self.getCenterYFromTap(tap)
        }
        // if we moved a lot, treat it as a drag event
        else {
          self.doc.picdef.xCenter = self.getCenterXFromDrag(tap)
          self.doc.picdef.yCenter = self.getCenterYFromDrag(tap)
        }
        // reset tap event states
        self.moved = 0
        self.startTime = nil
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
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale
    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    let newCenterX: Double = doc.picdef.xCenter + dCenterX
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
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale
    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    let newCenterY: Double = doc.picdef.yCenter + dCenterY
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
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale
    let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
    let newCenterX: Double = doc.picdef.xCenter + dCenterX
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
    let diffX = movedX / doc.picdef.scale
    let diffY = movedY / doc.picdef.scale
    let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
    let newCenterY: Double = doc.picdef.yCenter + dCenterY
    return newCenterY
  }
}
