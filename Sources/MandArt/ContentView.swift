/**
 ContentView.swift
 MandArt
 
 The main view in the MandArt project, responsible for displaying the user interface.
 
 Created by Bruce Johnson on 9/20/21.
 Revised and updated 2021-2023
 All rights reserved.
 */
import AppKit // keypress
import Foundation // trig functions
import SwiftUI // views

var contextImageGlobal: CGImage?
var fIterGlobal = [[Double]]()

@available(macOS 12.0, *)
struct ContentView: View {
  @EnvironmentObject var doc: MandArtDocument

  // set width of the first column (user inputs)
  let inputWidth: Double = 340

  @State private var moved: Double = 0.0
  @State private var startTime: Date?
  @State private var drawIt = true
  @State private var drawGradient = false
  @State private var drawColors = false
  @State private var activeDisplayState = ActiveDisplayChoice.MandArt
  @State private var textFieldImageHeight: NSTextField = .init()
  @State private var textFieldY: NSTextField = .init()
  @State private var showingAllColorsPopups = Array(repeating: false, count: 6)
  @State private var showingPrintableColorsPopups = Array(repeating: false, count: 6)
  @State private var showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
  @State private var showingPrintablePopups = Array(repeating: false, count: 100)

  enum ActiveDisplayChoice {
    case MandArt
    case Gradient
  }

  /**
   Gets an image to display on the right side of the app
   
   - Returns: An optional CGImage or nil
   */
  func getImage() -> CGImage? {
    var colors: [[Double]] = []

    self.doc.picdef.hues.forEach { hue in
      let arr: [Double] = [hue.r, hue.g, hue.b]
      colors.insert(arr, at: colors.endIndex)
    }

    let imageWidth: Int = self.doc.picdef.imageWidth
    let imageHeight: Int = self.doc.picdef.imageHeight

    if self.activeDisplayState == ActiveDisplayChoice.MandArt, self.drawIt {
      return self.getPictureImage(&colors)
    } else if self.activeDisplayState == ActiveDisplayChoice.Gradient, self.drawGradient == true,
              self.leftGradientIsValid {
      return self.getGradientImage(imageWidth, imageHeight, self.doc.picdef.leftNumber, &colors)
    } else if self.drawColors == true {
      return self.getColorImage(&colors)
    }

    return nil
  }

  /**
   Function to create and return a user-created MandArt bitmap
   
   - Parameters:
   - colors: array of colors
   
   - Returns: optional CGImage with the bitmap or nil
   */
  fileprivate func getPictureImage(_ colors: inout [[Double]]) -> CGImage? {
    // draws image
    let imageHeight: Int = self.doc.picdef.imageHeight
    let imageWidth: Int = self.doc.picdef.imageWidth
    let iterationsMax: Double = self.doc.picdef.iterationsMax
    let scale: Double = self.doc.picdef.scale
    let xCenter: Double = self.doc.picdef.xCenter
    let yCenter: Double = self.doc.picdef.yCenter
    let theta: Double = -self.doc.picdef.theta // in degrees
    let dFIterMin: Double = self.doc.picdef.dFIterMin
    let pi = 3.14159
    let thetaR: Double = pi * theta / 180.0 // R for Radians
    let rSqLimit: Double = self.doc.picdef.rSqLimit

    var contextImage: CGImage
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

    fIterGlobal = fIter

    for u in 0 ... imageWidth - 1 {
      fIterBottom[u] = fIter[u][0]
      fIterTop[u] = fIter[u][imageHeight - 1]
    } // end second for u

    fIterMinLeft = fIter[0].min()!
    fIterMinRight = fIter[imageWidth - 1].min()!
    fIterMinBottom = fIterBottom.min()!
    fIterMinTop = fIterTop.min()!
    fIterMins = [fIterMinLeft, fIterMinRight, fIterMinBottom, fIterMinTop]
    fIterMin = fIterMins.min()!

    fIterMin = fIterMin - dFIterMin

    // Now we need to generate a bitmap image.

    let nBlocks: Int = self.doc.picdef.nBlocks
    let nColors: Int = self.doc.picdef.hues.count
    let spacingColorFar: Double = self.doc.picdef.spacingColorFar
    let spacingColorNear: Double = self.doc.picdef.spacingColorNear
    var yY: Double = self.doc.picdef.yY

    if yY == 1.0 { yY = yY - 1.0e-10 }

    var spacingColorMid = 0.0
    var fNBlocks = 0.0
    var color = 0.0
    var block0 = 0
    var block1 = 0

    fNBlocks = Double(nBlocks)

    spacingColorMid = (iterationsMax - fIterMin - fNBlocks * spacingColorFar) / pow(fNBlocks, spacingColorNear)

    var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

    var h = 0.0
    var xX = 0.0

    for i in 0 ... nBlocks {
      blockBound[i] = spacingColorFar * Double(i) + spacingColorMid * pow(Double(i), spacingColorNear)
    }

    // set up CG parameters
    let bitsPerComponent = 8 // for UInt8
    let componentsPerPixel = 4 // RGBA = 4 components
    let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
    let bytesPerRow: Int = imageWidth * bytesPerPixel
    let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel

    // Allocate data for the raster buffer.  Use UInt8 to
    // address individual RGBA components easily.
    let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

    // Create CGBitmapContext for drawing and converting into image for display
    let context =
    CGContext(
      data: rasterBufferPtr,
      width: imageWidth,
      height: imageHeight,
      bitsPerComponent: bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: CGColorSpace(name: CGColorSpace.sRGB)!,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!

    // use CG to draw into the context
    // you can use any of the CG drawing routines for drawing into this context
    // here we will just erase the contents of the CGBitmapContext as the
    // raster buffer just contains random uninitialized data at this point.
    context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // white
    context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
    context.fillPath()

    // Use any CG drawing routines, or draw yourself
    // by accessing individual pixels in the raster image.
    // here we'll draw a square one pixel at a time.
    let xStarting = 0
    let yStarting = 0
    let width: Int = imageWidth
    let height: Int = imageHeight

    // iterate over all of the rows for the entire height of the square
    for v in 0 ... (height - 1) {
      // calculate the offset to the row of pixels in the raster buffer
      // assume the origin is at the bottom left corner of the raster image.
      // note, you could also use the top left, but GC uses the bottom left
      // so this method keeps your drawing and CG in sync in case you wanted
      // to use the CG methods for drawing too.
      //
      // note, you could do this calculation all together inside of the xoffset
      // loop, but it's a small optimization to pull this part out and do it here
      // instead of every time through.
      let pixel_vertical_offset: Int = rasterBufferSize - (bytesPerRow * (Int(yStarting) + v + 1))

      // iterate over all of the pixels in this row
      for u in 0 ... (width - 1) {
        // calculate the horizontal offset to the pixel in the row
        let pixel_horizontal_offset: Int = ((Int(xStarting) + u) * bytesPerPixel)

        // sum the horixontal and vertical offsets to get the pixel offset
        let pixel_offset = pixel_vertical_offset + pixel_horizontal_offset

        // calculate the offset of the pixel
        let pixelAddress: UnsafeMutablePointer<UInt8> = rasterBufferPtr + pixel_offset

        if fIter[u][v] >= iterationsMax { // black
          pixelAddress.pointee = UInt8(0) // red
          (pixelAddress + 1).pointee = UInt8(0) // green
          (pixelAddress + 2).pointee = UInt8(0) // blue
          (pixelAddress + 3).pointee = UInt8(255) // alpha
        } // end if

        else {
          h = fIter[u][v] - fIterMin

          for block in 0 ... nBlocks {
            block0 = block

            if h >= blockBound[block], h < blockBound[block + 1] {
              if (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block]) <= yY {
                h = blockBound[block]
              } else {
                h = blockBound[block] +
                ((h - blockBound[block]) - yY * (blockBound[block + 1] - blockBound[block])) /
                (1 - yY)
              }

              xX = (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block])

              while block0 > nColors - 1 {
                block0 = block0 - nColors
              }

              block1 = block0 + 1

              if block1 == nColors {
                block1 = block1 - nColors
              }

              color = colors[block0][0] + xX * (colors[block1][0] - colors[block0][0])
              pixelAddress.pointee = UInt8(color) // R

              color = colors[block0][1] + xX * (colors[block1][1] - colors[block0][1])
              (pixelAddress + 1).pointee = UInt8(color) // G

              color = colors[block0][2] + xX * (colors[block1][2] - colors[block0][2])
              (pixelAddress + 2).pointee = UInt8(color) // B

              (pixelAddress + 3).pointee = UInt8(255) // alpha
            }
          }

          // IMPORTANT:
          // no type checking - make sure
          // address indexes do not go beyond memory allocated for buffer
        } // end else
      } // end for u
    } // end for v

    // convert the context into image - this is what the function returns
    contextImage = context.makeImage()!

    // no automatic deallocation for the raster data
    rasterBufferPtr.deallocate()

    // stash picture in global var for saving
    contextImageGlobal = contextImage
    return contextImage
  }

  /**
   Function to create and return a gradient bitmap
   
   - Parameters:
   - imageHeight: Int bitmap image height in pixels
   - imageWidth: Int bitmap image width in pixels
   - nLeft: int number of the left hand color, starting with 1 (not 0)
   - colors: array of colors (for the whole picture)
   
   - Returns: optional CGImage with the bitmap or nil
   */
  fileprivate func getGradientImage(
    _ imageWidth: Int,
    _ imageHeight: Int,
    _ nLeft: Int,
    _ colors: inout [[Double]]
  ) -> CGImage? {
    var yY: Double = self.doc.picdef.yY

    if yY == 1.0 { yY = yY - 1.0e-10 }

    var gradientImage: CGImage
    let leftNumber: Int = nLeft
    var rightNumber: Int = leftNumber + 1

    if leftNumber == colors.count {
      rightNumber = 1
    }

    var color = 0.0

    // set up CG parameters
    let bitsPerComponent = 8 // for UInt8
    let componentsPerPixel = 4 // RGBA = 4 components
    let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // = 4
    let bytesPerRow: Int = imageWidth * bytesPerPixel
    let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel

    // Allocate data for raster buffer.  Using UInt8 to
    // address individual RGBA components easily.
    let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

    // Create CGBitmapContext for drawing and converting into image for display
    let context =
    CGContext(
      data: rasterBufferPtr,
      width: imageWidth,
      height: imageHeight,
      bitsPerComponent: bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: CGColorSpace(name: CGColorSpace.sRGB)!,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!

    // use CG to draw into the context
    // use any CG drawing routines for drawing into this context
    // here we will erase the contents of the CGBitmapContext as the
    // raster buffer just contains random uninitialized data at this point.
    context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // white
    context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
    context.fillPath()

    // Use any CG drawing routines or draw yourself
    // by accessing individual pixels in the raster image.
    // We draw a square one pixel at a time.
    let xStarting = 0
    let yStarting = 0
    let width: Int = imageWidth
    let height: Int = imageHeight

    // iterate over all rows for the entire height of the square
    for v in 0 ... (height - 1) {
      // calculate the offset to the row of pixels in the raster buffer
      // assume origin is bottom left corner of the raster image.
      // note, you could also use the top left, but GC uses the bottom left
      // so this method keeps your drawing and CG in sync in case you want
      // to use CG methods for drawing too.
      let pixel_vertical_offset: Int = rasterBufferSize - (bytesPerRow * (Int(yStarting) + v + 1))

      // iterate over all pixels in this row
      for u in 0 ... (width - 1) {
        // calculate horizontal offset to the pixel in the row
        let pixel_horizontal_offset: Int = ((Int(xStarting) + u) * bytesPerPixel)

        // sum the horixontal and vertical offsets to get the pixel offset
        let pixel_offset = pixel_vertical_offset + pixel_horizontal_offset

        // calculate the offset of the pixel
        let pixelAddress: UnsafeMutablePointer<UInt8> = rasterBufferPtr + pixel_offset

        if Double(u) <= yY * Double(width) { color = colors[leftNumber - 1][0] } else {
          color = colors[leftNumber - 1][0] + (colors[rightNumber - 1][0] - colors[leftNumber - 1][0]) *
          (Double(u) - yY * Double(width)) / (Double(width) - yY * Double(width))
        }
        pixelAddress.pointee = UInt8(color) // R

        if Double(u) <= yY * Double(width) { color = colors[leftNumber - 1][1] } else {
          color = colors[leftNumber - 1][1] + (colors[rightNumber - 1][1] - colors[leftNumber - 1][1]) *
          (Double(u) - yY * Double(width)) / (Double(width) - yY * Double(width))
        }
        (pixelAddress + 1).pointee = UInt8(color) // G

        if Double(u) <= yY * Double(width) { color = colors[leftNumber - 1][2] } else {
          color = colors[leftNumber - 1][2] + (colors[rightNumber - 1][2] - colors[leftNumber - 1][2]) *
          (Double(u) - yY * Double(width)) / (Double(width) - yY * Double(width))
        }
        (pixelAddress + 2).pointee = UInt8(color) // B
        (pixelAddress + 3).pointee = UInt8(255) // alpha

        // IMPORTANT:
        // no type checking - make sure that address indexes
        // do not go beyond memory allocated for the buffer
      } // end for u
    } // end for v

    // convert context into an image which function will return
    gradientImage = context.makeImage()!

    // no automatic deallocation for the raster data, do so here
    rasterBufferPtr.deallocate()

    // stash picture in global var for saving
    contextImageGlobal = gradientImage
    return gradientImage
  }

  /**
   Function to create and return a user-colored MandArt bitmap
   
   - Parameters:
   - colors: array of colors
   
   - Returns: optional CGImage with the colored bitmap or nil
   */
  fileprivate func getColorImage(_ colors: inout [[Double]]) -> CGImage? {
    // draws image
    let imageHeight: Int = self.doc.picdef.imageHeight
    let imageWidth: Int = self.doc.picdef.imageWidth
    let iterationsMax: Double = self.doc.picdef.iterationsMax
    let dFIterMin: Double = self.doc.picdef.dFIterMin
    let nBlocks: Int = self.doc.picdef.nBlocks
    let nColors: Int = self.doc.picdef.hues.count
    let spacingColorFar: Double = self.doc.picdef.spacingColorFar
    let spacingColorNear: Double = self.doc.picdef.spacingColorNear
    var yY: Double = self.doc.picdef.yY

    if yY == 1.0 { yY = yY - 1.0e-10 }

    var contextImage: CGImage
    var fIterMinLeft = 0.0
    var fIterMinRight = 0.0
    var fIterBottom = [Double](repeating: 0.0, count: imageWidth)
    var fIterTop = [Double](repeating: 0.0, count: imageWidth)
    var fIterMinBottom = 0.0
    var fIterMinTop = 0.0
    var fIterMins = [Double](repeating: 0.0, count: 4)
    var fIterMin = 0.0

    for u in 0 ... imageWidth - 1 {
      fIterBottom[u] = fIterGlobal[u][0]
      fIterTop[u] = fIterGlobal[u][imageHeight - 1]
    } // end second for u

    fIterMinLeft = fIterGlobal[0].min()!
    fIterMinRight = fIterGlobal[imageWidth - 1].min()!
    fIterMinBottom = fIterBottom.min()!
    fIterMinTop = fIterTop.min()!
    fIterMins = [fIterMinLeft, fIterMinRight, fIterMinBottom, fIterMinTop]
    fIterMin = fIterMins.min()!

    fIterMin = fIterMin - dFIterMin

    // Now we need to generate a bitmap image.

    var spacingColorMid = 0.0
    var fNBlocks = 0.0
    var color = 0.0
    var block0 = 0
    var block1 = 0

    fNBlocks = Double(nBlocks)

    spacingColorMid = (iterationsMax - fIterMin - fNBlocks * spacingColorFar) / pow(fNBlocks, spacingColorNear)

    var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

    var h = 0.0
    var xX = 0.0

    for i in 0 ... nBlocks {
      blockBound[i] = spacingColorFar * Double(i) + spacingColorMid * pow(Double(i), spacingColorNear)
    }

    // set up CG parameters
    let bitsPerComponent = 8 // for UInt8
    let componentsPerPixel = 4 // RGBA = 4 components
    let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // = 4
    let bytesPerRow: Int = imageWidth * bytesPerPixel
    let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel

    // Allocate data for the raster buffer.  Using UInt8 so that I can
    // address individual RGBA components easily.
    let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

    // Create CGBitmapContext for drawing and converting into image for display
    let context =
    CGContext(
      data: rasterBufferPtr,
      width: imageWidth,
      height: imageHeight,
      bitsPerComponent: bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: CGColorSpace(name: CGColorSpace.sRGB)!,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!

    // use CG to draw into the context
    // use any CG drawing routines for drawing into this context
    // here we will erase the contents of the CGBitmapContext as the
    // raster buffer just contains random uninitialized data at this point.
    context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // white
    context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
    context.fillPath()

    // Use any CG drawing routines or draw yourself
    // by accessing individual pixels in the raster image.
    // We draw a square one pixel at a time.
    let xStarting = 0
    let yStarting = 0
    let width: Int = imageWidth
    let height: Int = imageHeight

    // iterate over all rows for the entire height of the square
    for v in 0 ... (height - 1) {
      // calculate the offset to the row of pixels in the raster buffer
      // assume origin is bottom left corner of the raster image.
      // note, you could also use the top left, but GC uses the bottom left
      // so this method keeps your drawing and CG in sync in case you want
      // to use CG methods for drawing too.
      let pixel_vertical_offset: Int = rasterBufferSize - (bytesPerRow * (Int(yStarting) + v + 1))

      // iterate over all of the pixels in this row
      for u in 0 ... (width - 1) {
        // calculate the horizontal offset to the pixel in the row
        let pixel_horizontal_offset: Int = ((Int(xStarting) + u) * bytesPerPixel)

        // sum the horixontal and vertical offsets to get the pixel offset
        let pixel_offset = pixel_vertical_offset + pixel_horizontal_offset

        // calculate the offset of the pixel
        let pixelAddress: UnsafeMutablePointer<UInt8> = rasterBufferPtr + pixel_offset

        if fIterGlobal[u][v] >= iterationsMax { // black
          pixelAddress.pointee = UInt8(0) // red
          (pixelAddress + 1).pointee = UInt8(0) // green
          (pixelAddress + 2).pointee = UInt8(0) // blue
          (pixelAddress + 3).pointee = UInt8(255) // alpha
        } else {
          h = fIterGlobal[u][v] - fIterMin

          for block in 0 ... nBlocks {
            block0 = block

            if h >= blockBound[block], h < blockBound[block + 1] {
              if (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block]) <= yY {
                h = blockBound[block]
              } else {
                h = blockBound[block] +
                ((h - blockBound[block]) - yY * (blockBound[block + 1] - blockBound[block])) /
                (1 - yY)
              }

              xX = (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block])

              while block0 > nColors - 1 {
                block0 = block0 - nColors
              }

              block1 = block0 + 1

              if block1 == nColors {
                block1 = block1 - nColors
              }

              color = colors[block0][0] + xX * (colors[block1][0] - colors[block0][0])
              pixelAddress.pointee = UInt8(color) // R

              color = colors[block0][1] + xX * (colors[block1][1] - colors[block0][1])
              (pixelAddress + 1).pointee = UInt8(color) // G

              color = colors[block0][2] + xX * (colors[block1][2] - colors[block0][2])
              (pixelAddress + 2).pointee = UInt8(color) // B

              (pixelAddress + 3).pointee = UInt8(255) // alpha
            }
          }
          // IMPORTANT:
          // no type checking - make sure that address indexes
          // do not go beyond memory allocated for the buffer
        } // end else
      } // end for u
    } // end for v

    // convert the context into an image which function will return
    contextImage = context.makeImage()!

    // no automatic deallocation for the raster data, do it here
    rasterBufferPtr.deallocate()

    // stash picture in global var for saving
    contextImageGlobal = contextImage
    return contextImage
  }

  // To swap a GeometryReader for an Image on button click in SwiftUI,
  // you can use a state variable to keep track of
  // what should be displayed,
  // and change this state variable when buttons are pressed.
  var body: some View {
    HStack(alignment: .top, spacing: 1) {
      // instructions on left, picture on right
      // Left (first) VStack is left side with user stuff
      // Right (second) VStack is for mandart, gradient, or colors
      // Sspacing is between VStacks (the two columns)

      // FIRST COLUMN - VSTACK IS FOR INSTRUCTIONS

      VStack(alignment: .center, spacing: 5) {
        // Wrap in GEOMETRY READER TO GAIN SPACE FROM COLORS

        GeometryReader { geometry in

          ScrollView(showsIndicators: true) {
            Text("MandArt")
              .font(.title)

            //  GROUP 1 -  BASICS

            Group {
              HStack {
                Button("Save Data") {
                  doc.saveMandArtDataFile()
                }
                .help("Save MandArt data file.")

                Button("Save Image") {
                  doc.saveMandArtImage()
                }
                .help("Save MandArt image file.")
              }

              Divider()
            } // END SECTION 1 GROUP -  BASICS
            .fixedSize(horizontal: true, vertical: true)

            //  GROUP 2 IMAGE SIZE

            Group {
              //  Show Row (HStack) of Image Size Next

              HStack {
                VStack {
                  Text("Image")

                  Text("width, px:")
                  TextField(
                    "1100",
                    value: $doc.picdef.imageWidth,
                    formatter:
                      ContentView.fmtImageWidthHeight
                  ) { isStarted in
                    isStarted ? pauseUpdates() : showMandArtBitMap()
                  }
                  .onSubmit {
                    showMandArtBitMap()
                    self.triggerTab(on: self.textFieldImageHeight)
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 80)
                  .help("Enter the width, in pixels, of the image.")
                }

                VStack {
                  Text("Image")

                  Text("height, px:")
                  TextField(
                    "1000",
                    value: $doc.picdef.imageHeight,
                    formatter: ContentView.fmtImageWidthHeight
                  ) { isStarted in
                    isStarted ? pauseUpdates() : showMandArtBitMap()
                  }
                  .onSubmit {
                    showMandArtBitMap()
                    self.triggerTab(on: self.textFieldImageHeight)
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 80)
                  .help("Enter the height, in pixels, of the image.")
                }

                VStack {
                  Text("Aspect")
                  Text("ratio:")

                  Text("\(aspectRatio)")
                    .padding(1)
                    .help("Calculated value of image width over image height.")
                }
              }

              Divider()
            } // END GROUP 2 IMAGE SIZE

            //  GROUP 3 X, Y and Scale

            Group {
              //  Show Row (HStack) of x, y

              HStack {
                VStack { // each input has a vertical container with a Text label & TextField for data
                  Text("Enter center x")
                  Text("Between -2 and 2")
                  TextField(
                    "-0.75",
                    value: $doc.picdef.xCenter,
                    formatter: ContentView.fmtXY
                  ) { isStarted in
                    isStarted ? pauseUpdates() : showMandArtBitMap()
                  }
                  .onSubmit {
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .padding(4)
                  .frame(maxWidth: 120)
                  .help(
                    "Enter the x value in the Mandelbrot coordinate system for the center of the image."
                  )
                }

                VStack { // each input has a vertical container with a Text label & TextField for data
                  Text("Enter center y")
                  Text("Between -2 and 2")
                  TextField(
                    "0.0",
                    value: $doc.picdef.yCenter,
                    formatter: ContentView.fmtXY
                  ) { isStarted in
                    isStarted ? pauseUpdates() : showMandArtBitMap()
                  }
                  .onSubmit {
                    showMandArtBitMap()
                    self.triggerTab(on: self.textFieldY)
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .padding(4)
                  .frame(maxWidth: 120)
                  .help(
                    "Enter the Y value in the Mandelbrot coordinate system for the center of the image."
                  )
                }
              } // end HStack for XY

              //  Show Row (HStack) of Scale Next

              HStack {
                VStack {
                  Text("Rotate (º)")

                  TextField(
                    "0",
                    value: $doc.picdef.theta,
                    formatter: ContentView.fmtRotationTheta
                  ) { isStarted in
                    isStarted ? pauseUpdates() : showMandArtBitMap()
                  }
                  .onSubmit {
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 60)
                  .help("Enter the angle to rotate the image clockwise, in degrees.")
                }

                VStack {
                  Text("Scale")
                  TextField(
                    "430",
                    value: $doc.picdef.scale,
                    formatter: ContentView.fmtScale
                  ) { isStarted in
                    isStarted ? pauseUpdates() : showMandArtBitMap()
                  }
                  .onSubmit {
                    print ("onSubmit: scale")
                    showMandArtBitMap()
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 160)
                  .help("Enter the magnification of the image.")
                }

                VStack {
                  Text("Zoom")

                  HStack {
                    Button("+") { zoomIn() }
                      .help("Zoom in by a factor of two.")

                    Button("-") { zoomOut() }
                      .help("Zoom out by a factor of two.")
                  }
                }
              }

              Divider()

              HStack {
                Text("Sharpening (iterationsMax):")

                TextField(
                  "10,000",
                  value: $doc.picdef.iterationsMax,
                  formatter: ContentView.fmtSharpeningItMax
                ) { isStarted in
                  isStarted ? pauseUpdates() : showMandArtBitMap()
                }
                .onSubmit {
                  showMandArtBitMap()
                }
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .help(
                  "Enter the maximum number of iterations for a given point in the image. A larger value will increase the resolution, but slow down the calculation."
                )
                .frame(maxWidth: 70)
              }
              .padding(.horizontal)

              HStack {
                Text("Color smoothing (rSqLimit):")

                TextField(
                  "400",
                  value: $doc.picdef.rSqLimit,
                  formatter: ContentView.fmtSmootingRSqLimit
                ) { isStarted in
                  isStarted ? pauseUpdates() : showMandArtBitMap()
                }
                .onSubmit {
                  showMandArtBitMap()
                }
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 60)
                .help(
                  "Enter min value for square of distance from origin. A larger value will smooth the color gradient, but slow down the calculation."
                )
              }

              Divider()

              // Hold fraction with Slider
              HStack {
                Text("Hold fraction (yY)")
              }
              HStack {
                Text("0")
                Slider(value: $doc.picdef.yY, in: 0 ... 1, step: 0.1)
                  .help(
                    "Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient."
                  )
                Text("1")

                TextField(
                  "0",
                  value: $doc.picdef.yY,
                  formatter: ContentView.fmtHoldFractionGradient
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 50)
                .help(
                  "Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient."
                )
              }
              .padding(.horizontal)
              // END Hold fraction with Slider

              Divider()
            } // END GROUP 3 X, Y, SCALE

            // GROUP 4 - GRADIENT

            Group {
              //  Show Row (HStack) of Gradient Content Next

              HStack {
                Text("Draw gradient from color")

                TextField(
                  "1",
                  value: $doc.picdef.leftNumber,
                  formatter: ContentView.fmtLeftGradientNumber
                )
                .frame(maxWidth: 30)
                .foregroundColor(leftGradientIsValid ? .primary : .red)
                .help("Select the color number for the left side of a gradient.")

                Text("to " + String(rightGradientColor))
                  .help("The color number for the right side of a gradient.")

                Button("Go") { showGradient() }
                  .help("Draw a gradient between two adjoining colors.")
              }

              Divider()
            } // END GROUP 4 - GRADIENT

            // GROUP 5 - COLOR TUNING GROUP

            Group {
              Text("Coloring Options")

              Divider()

              Group { // NEAR FAR GROUP
                // Spacing 1 with Slider
                Text("Spacing far from MiniMand (near to edge)")
                HStack {
                  Text("1")

                  Slider(value: $doc.picdef.spacingColorFar, in: 1 ... 20, step: 1) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .accentColor(Color.blue)

                  Text("20")

                  TextField(
                    "5",
                    value: $doc.picdef.spacingColorFar,
                    formatter: ContentView.fmtSpacingNearEdge
                  ) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                  .help(
                    "Enter the value for the color spacing near the edges of the image, away from MiniMand."
                  )
                }

                // END  Slider

                // Spacing 2 with Slider
                Text("Spacing near to MiniMand (far from edge)")
                HStack {
                  Text("5")

                  Slider(value: $doc.picdef.spacingColorNear, in: 5 ... 50, step: 5) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .accentColor(Color.blue)

                  Text("50")

                  TextField(
                    "15",
                    value: $doc.picdef.spacingColorNear,
                    formatter: ContentView.fmtSpacingFarFromEdge
                  ) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                }
                .padding(.horizontal)
                .help(
                  "Enter the value for the color spacing away from the edges of the image, near the MiniMand."
                )
                // END  Slider

                Divider()
              } // END NEAR FAR GROUP

              Group {
                // Min Iterations with Slider
                Text("Change in minimum iteration:")
                HStack {
                  Text("-5")

                  Slider(value: $doc.picdef.dFIterMin, in: -5 ... 20, step: 1) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }

                  Text("20")

                  TextField(
                    "0",
                    value: $doc.picdef.dFIterMin,
                    formatter: ContentView.fmtChangeInMinIteration
                  ) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                }
                .padding(.horizontal)
                .help(
                  "Enter a value for the change in the minimum number of iterations in the image. This will change the coloring."
                )
                // END Min Iterations with Slider

                // nblocks with slider
                Text("Number of Color Blocks:")

                HStack {
                  Text("10")

                  Slider(value: Binding(
                    get: { Double(doc.picdef.nBlocks) },
                    set: { doc.picdef.nBlocks = Int($0) }
                  ), in: 10 ... 100, step: 10) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .accentColor(Color.green)

                  Text("100")

                  TextField(
                    "60",
                    value: $doc.picdef.nBlocks,
                    formatter: ContentView.fmtNBlocks
                  ) { isStarted in
                    if isStarted {
                      self.readyForColors()
                    }
                  }
                  .textFieldStyle(.roundedBorder)
                  .multilineTextAlignment(.trailing)
                  .frame(maxWidth: 50)
                }
                .padding(.horizontal)
                .help(
                  "Enter a value for the number of blocks of color in the image. Each block is the gradient between two adjacent colors. If the number of blocks is greater than the number of colors, the colors will be repeated."
                )

                Divider()
              } // END GROUP of last 2 slider inputs
            } // end GROUP 5 - COLOR TUNING GROUP
          } // end scroll bar
          .frame(height: geometry.size.height)
        } // end top scoll bar geometry reader
        .frame(
          minHeight: 200,
          maxHeight: .infinity
        )
        .fixedSize(horizontal: false, vertical: false)

        // GROUP FOR POPUPS BUTTONS AND VERIFY AND ADD NEW COLOR

        Group {
          // HSTACK START WITH RED
          HStack {
            Text("Rgb:")

            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[0] = true
            }
            .padding([.bottom], 2)

            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[0] = true
            }
            .padding([.bottom], 2)

            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[0] = true
            }
            .padding([.bottom], 2)

            Text("Rbg:")

            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[1] = true
            }
            .padding([.bottom], 2)

            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[1] = true
            }
            .padding([.bottom], 2)

            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[1] = true
            }
            .padding([.bottom], 2)
          } // END HSTACK START WITH RED

          // HSTACK START WITH GREEN

          HStack {
            Text("Grb:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[2] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[2] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[2] = true
            }
            .padding([.bottom], 2)
            Text("Gbr:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[3] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[3] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[3] = true
            }
            .padding([.bottom], 2)
          } // END HSTACK START WITH GREEN

          // HSTACK START WITH BLUE

          HStack {
            Text("Brg:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[4] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[4] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[4] = true
            }
            .padding([.bottom], 2)

            Text("Bgr:")
            Button("A") {
              self.resetAllPopupsToFalse()
              self.showingAllColorsPopups[5] = true
            }
            .padding([.bottom], 2)
            Button("AP") {
              self.resetAllPopupsToFalse()
              self.showingAllPrintableColorsPopups[5] = true
            }
            .padding([.bottom], 2)
            Button("P") {
              self.resetAllPopupsToFalse()
              self.showingPrintableColorsPopups[5] = true
            }
            .padding([.bottom], 2)
          } // END  HSTACK START WITH BLUE

          HStack {
            Button("Add New Color") { doc.addHue() }
              .help("Add a new color.")
              .padding([.bottom], 2)
          }
        } // END  GROUP FOR POPUPS BUTTONS AND VERIFY AND ADD NEW COLOR

        // Wrap the list in a geometry reader so it will
        // shrink when items are deleted
        GeometryReader { geometry in

          List {
            ForEach($doc.picdef.hues, id: \.num) { $hue in
              let i = hue.num - 1
              let isPrintable = getIsPrintable(color: $hue.wrappedValue.color, num: $hue.wrappedValue.num)

              HStack {
                TextField("number", value: $hue.num, formatter: ContentView.fmtIntColorOrderNumber)
                  .disabled(true)
                  .frame(maxWidth: 15)

                ColorPicker("", selection: $hue.color, supportsOpacity: false)
                  .onChange(of: hue.color) { newColor in
                    doc.updateHueWithColorPick(
                      index: i, newColorPick: newColor
                    )
                  }

                if !isPrintable {
                  Button {
                    self.showingPrintablePopups[i] = true
                  } label: {
                    Image(systemName: "exclamationmark.circle")
                      .foregroundColor(.blue)
                  }
                  .help("See printable options for " + "\(hue.num)")
                } else {
                  Button {
                    //
                  } label: {
                    Image(systemName: "exclamationmark.circle")
                  }
                  .hidden()
                  .disabled(true)
                }
                if self.showingPrintablePopups[i] {
                  ZStack {
                    Color.white
                      .opacity(0.5)

                    VStack {
                      Button(action: {
                        self.showingPrintablePopups[i] = false
                      }) {
                        Image(systemName: "xmark.circle")
                      }

                      VStack {
                        Text("This color may not print well.")
                        Text("See the instructions for options.")
                      } // end VStack of color options
                    } // end VStack
                    .frame(width: 150, height: 100)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 10)
                  } // end ZStack for popup
                  .transition(.scale)
                } // end if self.showingPrintablePopups[i]

                // enter red

                TextField("255", value: $hue.r, formatter: ContentView.fmt0to255) { isStarted in
                  if isStarted {
                    self.readyForColors()
                  }
                }
                .onChange(of: hue.r) { newValue in
                    doc.updateHueWithColorNumberR(
                      index: i, newValue: newValue
                    )
                  }

                // enter green

                TextField("255", value: $hue.g, formatter: ContentView.fmt0to255) { isStarted in
                  if isStarted {
                    self.readyForColors()
                  }
                }
                  .onChange(of: hue.g) { newValue in
                    doc.updateHueWithColorNumberG(
                      index: i, newValue: newValue
                    )
                  }

                // enter blue

                TextField("255", value: $hue.b, formatter: ContentView.fmt0to255) { isStarted in
                  if isStarted {
                    self.readyForColors()
                  }
                }
                  .onChange(of: hue.b) { newValue in
                    doc.updateHueWithColorNumberB(
                      index: i, newValue: newValue
                    )
                  }

                Button(role: .destructive) {
                  doc.deleteHue(index: i)
                  updateHueNums()
                  readyForPicture()
                } label: {
                  Image(systemName: "trash")
                }
                .help("Delete " + "\(hue.num)")
              }
            } // end foreach
            .onMove { indices, hue in
              doc.picdef.hues.move(
                fromOffsets: indices,
                toOffset: hue
              )
              updateHueNums()
            }
          } // end list
          .frame(height: geometry.size.height)
        } // end color list geometry reader
        .frame(
          minHeight: 0,
          maxHeight: 220
        )
        .fixedSize(horizontal: false, vertical: false)

        // } // END COLOR LIST VSTACK
      } // end VStack for user instructions, rest is 2nd col
      .frame(width: inputWidth)
      .padding(2)

      // SECOND COLUMN - VSTACK - IS FOR IMAGES

      // RIGHT COLUMN IS FOR IMAGES......................

      ScrollView(showsIndicators: true) {
        VStack {
          if activeDisplayState == ActiveDisplayChoice.MandArt {
            let image: CGImage = getImage()!
            GeometryReader {_ in
              ZStack(alignment: .topLeading) {
                Image(image, scale: 1.0, label: Text("Test"))
                  .gesture(self.tapGesture)
              }
            }

          } else if activeDisplayState == ActiveDisplayChoice.Gradient {
            let image: CGImage = getImage()!
            GeometryReader { _ in
              ZStack(alignment: .topLeading) {
                Image(image, scale: 1.0, label: Text("Test"))
              }
            }
          }

          // User will click buttons on the user input side
          // of the main screen, but we'll show the colors on the
          // right side of the main screen (here)

          // this checks to see which button the user clicked
          // it will set one of the following to "true"
          // and that's the one we'll show.

          // There are six of each - depending on the sort order
          // for example
          // RGB is the first (index = 0)
          // RBG (blue & green reversed) is the second or index 1

          // THere are 3 buttons for each color sort order (e.g. RGB)
          // ALL screen colors
          // ALL PRINTABLE colors (uses white squares as placeholders)
          // just the PRINTABLE colors (no white square placeholders)
          let iAll = showingAllColorsPopups.firstIndex(of: true)
          let iAP = showingAllPrintableColorsPopups.firstIndex(of: true)
          let iP = showingPrintableColorsPopups.firstIndex(of: true)

          // IF USER WANTED TO SEE ALL SCREEN COLORS
          if iAll != nil {
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  showingAllColorsPopups[iAll!] = false
                }) {
                  Image(systemName: "xmark.circle")
                }
                VStack {
                  let arrCGs = MandMath.getAllCGColorsList(iSort: iAll!)
                  let arrColors = arrCGs.map { cgColor in
                    Color(cgColor)
                  }
                  let nColumns = 64
                  let nRows = arrColors.count / nColumns
                  ForEach(0 ..< nRows) { rowIndex in
                    HStack(spacing: 0) {
                      ForEach(0 ..< 64) { columnIndex in
                        let index = rowIndex * nColumns + columnIndex
                        Rectangle()
                          .fill(arrColors[index])
                          .frame(width: 17, height: 27)
                          .cornerRadius(4)
                          .padding(1)
                      }
                    }
                  }
                } // end VStack of color options
                Spacer()
              } // end VStack
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(radius: 10)
              .padding()
            } // end ZStack for popup
            .transition(.scale)
          } // end if popup

          // IF USER WANTED TO SEE ALL PRINTABLE COLORS
          // WITH PLACEHOLDERS

          if iAP != nil {
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  showingAllPrintableColorsPopups[iAP!] = false
                }) {
                  Image(systemName: "xmark.circle")
                }
                VStack {
                  let arrCGs = MandMath.getAllPrintableCGColorsList(iSort: iAP!)
                  let arrColors = arrCGs.map { cgColor in
                    Color(cgColor)
                  }
                  let nColumns = 64
                  let nRows = arrColors.count / nColumns
                  ForEach(0 ..< nRows) { rowIndex in
                    HStack(spacing: 0) {
                      ForEach(0 ..< 64) { columnIndex in
                        let index = rowIndex * nColumns + columnIndex
                        Rectangle()
                          .fill(arrColors[index])
                          .frame(width: 17, height: 27)
                          .cornerRadius(4)
                          .padding(1)
                      }
                    }
                  }
                } // end VStack of color options
                Spacer()
              } // end VStack
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(radius: 10)
              .padding()
            } // end ZStack for popup
            .transition(.scale)
          } // end if popup

          // IF USER WANTED TO SEE ONLY PRINTABLE COLORS
          // * WITHOUT * PLACEHOLDERS

          if iP != nil {
            ZStack {
              Color.white
                .opacity(0.5)
              VStack {
                Button(action: {
                  showingPrintableColorsPopups[iP!] = false
                }) {
                  Image(systemName: "xmark.circle")
                }
                VStack {
                  let arrCGs = MandMath.getPrintableCGColorListSorted(iSort: iP!)
                  let arrColors = arrCGs.map { cgColor in
                    Color(cgColor)
                  }

                  let nColumns = 32
                  ForEach(0 ..< arrColors.count / nColumns) { rowIndex in
                    HStack(spacing: 0) {
                      ForEach(0 ..< 32) { columnIndex in
                        let index = rowIndex * nColumns + columnIndex
                        let color = arrColors[index]
                        let nsColor = NSColor(color)
                        let red = nsColor.redComponent
                        let green = nsColor.greenComponent
                        let blue = nsColor.blueComponent

                        let colorValueR = "\(Int(red * 255))"
                        let colorValueG = "\(Int(green * 255))"
                        let colorValueB = "\(Int(blue * 255))"

                        VStack {
                          Rectangle()
                            .fill(arrColors[index])
                            .frame(width: 30, height: 30)
                            .cornerRadius(4)
                            .padding(1)

                          Text(colorValueR)
                            .font(.system(size: 10))
                            .background(Color.white)
                          Text(colorValueG)
                            .font(.system(size: 10))
                            .background(Color.white)
                          Text(colorValueB)
                            .font(.system(size: 10))
                            .background(Color.white)
                        } // end Zstack of rect, rgb values
                      } // end for each column of colors
                    } // end HStack of colors
                  } // end for each color
                } // end VStack of color options
                Spacer()
              } // end VStack
              .padding()
              .background(Color.white)
              .cornerRadius(8)
              .shadow(radius: 10)
              .padding()
            } // end ZStack for popup
            .transition(.scale)
          } // end if popup
        } // end VStack right side (picture space)
        .padding(2)
      } // end image scroll view
      .padding(2)
    } // end HStack
  } // end view body

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
        // store distance the touch has moved as a sum of all movements
        self.moved += value.translation.width + value.translation.height
        // only set the start time if it's the first event
        if self.startTime == nil {
          self.startTime = value.time
        }
      }
      .onEnded { tap in
        // if we haven't moved very much, treat it as a tap event
        if self.moved < 2, self.moved > -2 {
          doc.picdef.xCenter = getCenterXFromTap(tap)
          doc.picdef.yCenter = getCenterYFromTap(tap)
          showMandArtBitMap() // redraw after new center
        }
        // if we have moved a lot, treat it as a drag event
        else {
          doc.picdef.xCenter = getCenterXFromDrag(tap)
          doc.picdef.yCenter = getCenterYFromDrag(tap)
          showMandArtBitMap() // redraw after drag
        }
        // reset tap event states
        self.moved = 0
        self.startTime = nil
      }
  } // end tapGesture

  // USER INPUT CUSTOM FORMATTERS - BASIC  .........................

  static var fmtImageWidthHeight: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 10_000
    return formatter
  }

  static var fmtXY: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.isPartialStringValidationEnabled = true
    formatter.maximumFractionDigits = 16
    formatter.maximum = 2.0
    formatter.minimum = -2.0
    return formatter
  }

  static var fmtRotationTheta: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    formatter.minimum = -359.9
    formatter.maximum = 359.9
    return formatter
  }

  static var fmtScale: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
 //   formatter.maximumFractionDigits = 8
    formatter.minimum = 1
    formatter.maximum = 10_000_000_000_000_000
    return formatter
  }

  // USER INPUT CUSTOM FORMATTERS - GRADIENT  ....................

  static var fmtSharpeningItMax: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 8
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtSmootingRSqLimit: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100_000_000
    return formatter
  }

  static var fmtHoldFractionGradient: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimum = 0.00
    formatter.maximum = 1.00
    return formatter
  }

  static var fmtLeftGradientNumber: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100
    return formatter
  }

  // USER INPUT CUSTOM FORMATTERS - COLORING  ....................

  static var fmtSpacingNearEdge: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100
    return formatter
  }

  static var fmtSpacingFarFromEdge: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100
    return formatter
  }

  static var fmtChangeInMinIteration: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 0
    formatter.maximum = 100
    return formatter
  }

  static var fmtNBlocks: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    formatter.minimum = 1
    formatter.maximum = 100
    return formatter
  }

  // USER INPUT CUSTOM FORMATTERS -ORDERED LIST OF COLORS (HUES) ...........

  static var fmtIntColorOrderNumber: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 8
    return formatter
  }

  static var fmt0to255: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimum = 0
    formatter.maximum = 255
    return formatter
  }

  // HELPER FUNCTIONS ..................................

  // Calculated variable for the image aspect ratio.
  // Uses user-specified image height and width.
  private var aspectRatio: String {
    let h = Double(doc.picdef.imageHeight)
    let w = Double(doc.picdef.imageWidth)
    let ratioDouble: Double = max(h / w, w / h)
    let ratioString = String(format: "%.2f", ratioDouble)
    return ratioString
  }

  private var leftGradientIsValid: Bool {
    var isValid = false
    let leftNum = self.doc.picdef.leftNumber
    let lastPossible = self.doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  private var rightGradientColor: Int {
    if self.leftGradientIsValid, self.doc.picdef.leftNumber < self.doc.picdef.hues.count {
      return self.doc.picdef.leftNumber + 1
    }
    return 1
  }

  private func getIsPrintable(color: Color, num: Int) -> Bool {
    if MandMath.isColorNearPrintableList(color: color.cgColor!, num: num) {
      return true
    } else {
      return false
    }
  }

  /**
   Returns the new x to be the picture center x when user drags in the picture.
   
   - Parameter tap: information about the drag
   
   - Returns: Double new center x
   */
  private func getCenterXFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
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
  private func getCenterYFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
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
  private func getCenterXFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
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
  private func getCenterYFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
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

  // Update hue nums after moviing or deleting
  fileprivate func updateHueNums() {
    for (index, _) in self.$doc.picdef.hues.enumerated() {
      self.doc.picdef.hues[index].num = index + 1
    }
  }

  // Get the app ready to draw colors.
  fileprivate func readyForColors() {
    self.drawIt = false
    self.drawGradient = false
    self.drawColors = true
  }

  // Pause updates to the calculationally-intensive bitmap
  // while the user inputs numeric entries.
  fileprivate func pauseUpdates() {
    self.drawIt = false
    self.drawGradient = false
    self.drawColors = false
  }

  fileprivate func showMandArtBitMap() {
    print("showMandArtBitMap")
    self.activeDisplayState = ActiveDisplayChoice.MandArt
    self.readyForPicture()
  }

  fileprivate func showGradient() {
    self.activeDisplayState = ActiveDisplayChoice.Gradient
    self.readyForGradient()
  }

  // Get the app ready to draw a MandArt picture.
  fileprivate func readyForPicture() {
    self.drawIt = true
    self.drawColors = false
  }

  // Get the app ready to draw a gradient.
  fileprivate func readyForGradient() {
    self.drawIt = false
    self.drawGradient = true
  }

  fileprivate func resetAllPopupsToFalse() {
    self.showingAllColorsPopups = Array(repeating: false, count: 6)
    self.showingPrintableColorsPopups = Array(repeating: false, count: 6)
    self.showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
  }

  // Multiplies scale by 2.0.
  func zoomIn() {
    self.readyForPicture()
    self.doc.picdef.scale = self.doc.picdef.scale * 2.0
    self.showMandArtBitMap()
  }

  // Divides scale by 2.0.
  func zoomOut() {
    self.readyForPicture()
    self.doc.picdef.scale = self.doc.picdef.scale / 2.0
    self.showMandArtBitMap()
  }

  /**
   Trigger a tab key press event
   
   You can add this to each numeric field's
   onSubmit() logic so that hitting RETURN
   would also tab to the next field.
   
   Not currently used as it doesn't know the TextField it was
   called on, so it can't go to the next field.
   
   - Parameter textField: The `NSTextField` to trigger the tab event on.
   */
  func triggerTab(on textField: NSTextField) {
    let keyCode = NSEvent.SpecialKey.tab.rawValue
    let keyEvent = NSEvent.keyEvent(
      with: .keyDown,
      location: NSPoint(),
      modifierFlags: [],
      timestamp: 0,
      windowNumber: 0,
      context: nil,
      characters: "\t",
      charactersIgnoringModifiers: "\t",
      isARepeat: false,
      keyCode: UInt16(keyCode)
    )!
    textField.window?.sendEvent(keyEvent)
  }
}
