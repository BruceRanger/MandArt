///
/// ContentView.swift
/// MandArt
///
/// The main view in the MandArt project, responsible for displaying the user interface.
///
///  Created by Bruce Johnson on 9/20/21.
///  Revised and updated 2021-2023
///  All rights reserved.

import AppKit // keypress
import Foundation // trig functions
import SwiftUI // views

// File / Project Settings / Per-user project settings / derived data
// set to project-relative path DerivedData
// now I can see the intermediate build products.

// Declare global variables first (outside the ContentView struct)
var contextImageGlobal: CGImage?
var fIterGlobal = [[Double]]()

@available(macOS 12.0, *)
struct ContentView: View {
    // Get everything we can from MandMath (Swift-only)
    let defaultFileName = MandMath.getDefaultDocumentName()

    // the remaining content should all require SwiftUI
    @EnvironmentObject var doc: MandArtDocument

    // set width of the first column (user inputs)
    let inputWidth: Double = 300

    @State private var testColor = Color.red
    @State private var tapX: Double = 0.0
    @State private var tapY: Double = 0.0
    @State private var tapLocations: [CGPoint] = []
    @State private var moved: Double = 0.0
    @State private var startTime: Date?
    @State private var dragCompleted = false
    @State private var dragOffset = CGSize.zero
    @State private var drawIt = true
    @State private var drawGradient = false
    @State private var drawColors = false
    @State private var activeDisplayState = ActiveDisplayChoice.MandArt
    @State private var textFieldImageWidth: NSTextField = .init()
    @State private var textFieldImageHeight: NSTextField = .init()
    @State private var textFieldX: NSTextField = .init()
    @State private var textFieldY: NSTextField = .init()
    @State private var showingAllColorsPopups = Array(repeating: false, count: 6)
    @State private var showingPrintableColorsPopups = Array(repeating: false, count: 6)
    @State private var showingAllPrintableColorsPopups = Array(repeating: false, count: 6)

    //BHJ: ToDo - set to max number of user input ordered colors (Hues)
    @State private var showingPrintablePopups = Array(repeating: false, count: 100)

    @State private var hoverColorValues: String? = nil
    @State private var hoverColorValueR: String? = nil
    @State private var hoverColorValueG: String? = nil
    @State private var hoverColorValueB: String? = nil

    enum ActiveDisplayChoice {
        case MandArt
        //      case Pause
        case Gradient
        case Color
        case ScreenColors
        case PrintColors
    }

    /// Gets an image to display on the right side of the app
    ///
    /// - Returns: An optional CGImage or nil
    ///
    func getImage() -> CGImage? {
        var colors: [[Double]] = []

        doc.picdef.hues.forEach { hue in
            let arr: [Double] = [hue.r, hue.g, hue.b]
            colors.insert(arr, at: colors.endIndex)
        }

        let imageWidth: Int = doc.picdef.imageWidth
        let imageHeight: Int = doc.picdef.imageHeight

        if activeDisplayState == ActiveDisplayChoice.MandArt, drawIt {
            return getPictureImage(&colors)
        } else if activeDisplayState == ActiveDisplayChoice.Gradient, drawGradient == true, leftGradientIsValid {
            return getGradientImage(imageWidth, imageHeight, doc.picdef.leftNumber, &colors)
        } else if drawColors == true {
            return getColorImage(&colors)
        }

        return nil
    }

    /// Function to create and return a user-created MandArt bitmap
    ///
    /// - Parameters:
    ///   - colors: array of colors
    ///
    /// - Returns: optional CGImage with the bitmap or nil
    ///
    fileprivate func getPictureImage(_ colors: inout [[Double]]) -> CGImage? {
        // draws image
        let imageHeight: Int = doc.picdef.imageHeight
        let imageWidth: Int = doc.picdef.imageWidth
        let iterationsMax: Double = doc.picdef.iterationsMax
        let scale: Double = doc.picdef.scale
        let xCenter: Double = doc.picdef.xCenter
        let yCenter: Double = doc.picdef.yCenter
        let theta: Double = doc.picdef.theta // in degrees
        let dFIterMin: Double = doc.picdef.dFIterMin
        let pi = 3.14159
        let thetaR: Double = pi * theta / 180.0 // R for Radians
        let rSqLimit: Double = doc.picdef.rSqLimit

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

        let nBlocks: Int = doc.picdef.nBlocks
        let nColors: Int = doc.picdef.hues.count
        let spacingColorFar: Double = doc.picdef.spacingColorFar
        let spacingColorNear: Double = doc.picdef.spacingColorNear
        var yY: Double = doc.picdef.yY

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

        // Allocate data for the raster buffer.  I'm using UInt8 so that I can
        // address individual RGBA components easily.
        let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

        // Create a CGBitmapContext for drawing and converting into an image for display
        let context =
        CGContext(data: rasterBufferPtr,
                  width: imageWidth,
                  height: imageHeight,
                  bitsPerComponent: bitsPerComponent,
                  bytesPerRow: bytesPerRow,
                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        // use CG to draw into the context
        // you can use any of the CG drawing routines for drawing into this context
        // here we will just erase the contents of the CGBitmapContext as the
        // raster buffer just contains random uninitialized data at this point.
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // white
        context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
        context.fillPath()

        // in addition to using any of the CG drawing routines, you can draw yourself
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
                                h = blockBound[block] + ((h - blockBound[block]) - yY * (blockBound[block + 1] - blockBound[block])) / (1 - yY)
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
                    // there is no type checking here and it is up to you to make sure that the
                    // address indexes do not go beyond the memory allocated for the buffer
                } // end else
            } // end for u
        } // end for v

        // convert the context into an image - this is what the function will return
        contextImage = context.makeImage()!

        // no automatic deallocation for the raster data
        // you need to manage that yourself
        rasterBufferPtr.deallocate()

        // stash picture in global var for saving
        contextImageGlobal = contextImage
        return contextImage
    }

    /// Function to create and return a gradient bitmap
    ///
    /// - Parameters:
    ///   - imageHeight: Int bitmap image height in pixels
    ///   - imageWidth: Int bitmap image width in pixels
    ///   - nLeft: int number of the left hand color, starting with 1 (not 0)
    ///   - colors: array of colors (for the whole picture)
    ///
    /// - Returns: optional CGImage with the bitmap or nil
    ///
    fileprivate func getGradientImage(_ imageWidth: Int, _ imageHeight: Int, _ nLeft: Int, _ colors: inout [[Double]]) -> CGImage? {
        var yY: Double = doc.picdef.yY

        if yY == 1.0 { yY = yY - 1.0e-10 }

        //      var uU: Double = 0.0

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
        let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
        let bytesPerRow: Int = imageWidth * bytesPerPixel
        let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel

        // Allocate data for the raster buffer.  I'm using UInt8 so that I can
        // address individual RGBA components easily.
        let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

        // Create a CGBitmapContext for drawing and converting into an image for display
        let context =
        CGContext(data: rasterBufferPtr,
                  width: imageWidth,
                  height: imageHeight,
                  bitsPerComponent: bitsPerComponent,
                  bytesPerRow: bytesPerRow,
                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        // use CG to draw into the context
        // you can use any of the CG drawing routines for drawing into this context
        // here we will just erase the contents of the CGBitmapContext as the
        // raster buffer just contains random uninitialized data at this point.
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // white
        context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
        context.fillPath()

        // in addition to using any of the CG drawing routines, you can draw yourself
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

                if Double(u) <= yY * Double(width) { color = colors[leftNumber - 1][0] } else {
                    color = colors[leftNumber - 1][0] + (colors[rightNumber - 1][0] - colors[leftNumber - 1][0]) * (Double(u) - yY * Double(width)) / (Double(width) - yY * Double(width))
                }
                pixelAddress.pointee = UInt8(color) // R

                if Double(u) <= yY * Double(width) { color = colors[leftNumber - 1][1] } else {
                    color = colors[leftNumber - 1][1] + (colors[rightNumber - 1][1] - colors[leftNumber - 1][1]) * (Double(u) - yY * Double(width)) / (Double(width) - yY * Double(width))
                }
                (pixelAddress + 1).pointee = UInt8(color) // G

                if Double(u) <= yY * Double(width) { color = colors[leftNumber - 1][2] } else {
                    color = colors[leftNumber - 1][2] + (colors[rightNumber - 1][2] - colors[leftNumber - 1][2]) * (Double(u) - yY * Double(width)) / (Double(width) - yY * Double(width))
                }
                (pixelAddress + 2).pointee = UInt8(color) // B

                (pixelAddress + 3).pointee = UInt8(255) // alpha

                // IMPORTANT:
                // there is no type checking here and it is up to you to make sure that the
                // address indexes do not go beyond the memory allocated for the buffer
            } // end for u
        } // end for v

        // convert the context into an image - this is what the function will return
        gradientImage = context.makeImage()!

        // no automatic deallocation for the raster data
        // you need to manage that yourself
        rasterBufferPtr.deallocate()

        // stash picture in global var for saving
        contextImageGlobal = gradientImage

        return gradientImage
    }

    /// Function to create and return a user-colored MandArt bitmap
    ///
    /// - Parameters:
    ///   - colors: array of colors
    ///
    /// - Returns: optional CGImage with the colored bitmap or nil
    ///
    fileprivate func getColorImage(_ colors: inout [[Double]]) -> CGImage? {
        // draws image
        let imageHeight: Int = doc.picdef.imageHeight
        let imageWidth: Int = doc.picdef.imageWidth
        let iterationsMax: Double = doc.picdef.iterationsMax
        let dFIterMin: Double = doc.picdef.dFIterMin
        let nBlocks: Int = doc.picdef.nBlocks
        let nColors: Int = doc.picdef.hues.count
        let spacingColorFar: Double = doc.picdef.spacingColorFar
        let spacingColorNear: Double = doc.picdef.spacingColorNear
        var yY: Double = doc.picdef.yY

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
        let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
        let bytesPerRow: Int = imageWidth * bytesPerPixel
        let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel

        // Allocate data for the raster buffer.  I'm using UInt8 so that I can
        // address individual RGBA components easily.
        let rasterBufferPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)

        // Create a CGBitmapContext for drawing and converting into an image for display
        let context =
        CGContext(data: rasterBufferPtr,
                  width: imageWidth,
                  height: imageHeight,
                  bitsPerComponent: bitsPerComponent,
                  bytesPerRow: bytesPerRow,
                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        // use CG to draw into the context
        // you can use any of the CG drawing routines for drawing into this context
        // here we will just erase the contents of the CGBitmapContext as the
        // raster buffer just contains random uninitialized data at this point.
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // white
        context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
        context.fillPath()

        // in addition to using any of the CG drawing routines, you can draw yourself
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

                if fIterGlobal[u][v] >= iterationsMax { // black
                    pixelAddress.pointee = UInt8(0) // red
                    (pixelAddress + 1).pointee = UInt8(0) // green
                    (pixelAddress + 2).pointee = UInt8(0) // blue
                    (pixelAddress + 3).pointee = UInt8(255) // alpha
                } // end if

                else {
                    h = fIterGlobal[u][v] - fIterMin

                    for block in 0 ... nBlocks {
                        block0 = block

                        if h >= blockBound[block], h < blockBound[block + 1] {
                            if (h - blockBound[block]) / (blockBound[block + 1] - blockBound[block]) <= yY {
                                h = blockBound[block]
                            } else {
                                h = blockBound[block] + ((h - blockBound[block]) - yY * (blockBound[block + 1] - blockBound[block])) / (1 - yY)
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
                    // there is no type checking here and it is up to you to make sure that the
                    // address indexes do not go beyond the memory allocated for the buffer
                } // end else
            } // end for u
        } // end for v

        // convert the context into an image - this is what the function will return
        contextImage = context.makeImage()!

        // no automatic deallocation for the raster data
        // you need to manage that yourself
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
                        //  Text("MandArt \(screenWidthStr) x \(screenHeightStr)")
                        Text("MandArt")
                            .font(.title)

                        //  GROUP 1 -  BASICS

                        Group {
                            HStack {
                                Button("Draw pic") { showMandArtBitMap() }
                                    .help("Draw the picture.")

                                Button("Color pic") { readyForColors() }
                                    .help("Color the image using the existing iteration data.")

                                Button("Pause") {
                                    drawIt = false
                                    drawGradient = false
                                    drawColors = false
                                }
                                .help("Pause to change values.")

                                Button("🌅") {
                                    doc.saveImagePictureFromJSONDocument()
                                }
                                .help("Save MandArt image file.")
                            }

                            Divider()
                        } // END SECTION 1 GROUP -  BASICS
                        .fixedSize(horizontal: true, vertical: true)

                        //  GROUP 2 IMAGE SIZE

                        Group {
                            //  Show Row (HStack) of Image Size  Next

                            HStack {
                                VStack {
                                    Text("Image")

                                    Text("width, px:")
                                    TextField("1100",
                                              value: $doc.picdef.imageWidth,
                                              formatter:
                                                ContentView.fmtImageWidthHeight) { isStarted in
                                        if isStarted {
                                            print("editing imageWidth, pausing updates")
                                            self.pauseUpdates()
                                        } /*else {
                                           self.showMandArtBitMap()
                                           }*/
                                    }
                                    //                                        .onSubmit {
                                    //                                            showMandArtBitMap()
                                    //                                        }
                                                .textFieldStyle(.roundedBorder)
                                                .multilineTextAlignment(.trailing)
                                                .frame(maxWidth: 80)
                                                .help("Enter the width, in pixels, of the image.")
                                                .disabled(drawColors)
                                }

                                VStack {
                                    Text("Image")

                                    Text("height, px:")
                                    TextField("1000",
                                              value: $doc.picdef.imageHeight,
                                              formatter: ContentView.fmtImageWidthHeight) { isStarted in
                                        if isStarted {
                                            self.pauseUpdates()
                                        } /*else {
                                           self.showMandArtBitMap()
                                           }*/
                                    }
                                              .onSubmit {
                                                  showMandArtBitMap()
                                                  print("triggering tab from img height")
                                                  self.triggerTab(on: self.textFieldImageHeight)
                                              }
                                              .textFieldStyle(.roundedBorder)
                                              .multilineTextAlignment(.trailing)
                                              .frame(maxWidth: 80)
                                              .help("Enter the height, in pixels, of the image.")
                                              .disabled(drawColors)
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
                                    TextField("-0.75",
                                              value: $doc.picdef.xCenter,
                                              formatter: ContentView.fmtXY) { isStarted in
                                        if isStarted {
                                            print("editing xC, pausing updates")
                                            self.pauseUpdates()
                                        } /*else {
                                           self.showMandArtBitMap()
                                           }*/
                                    }
                                              .onSubmit {
                                                  showMandArtBitMap()
                                              }
                                              .textFieldStyle(.roundedBorder)
                                              .multilineTextAlignment(.trailing)
                                              .padding(4)
                                              .frame(maxWidth: 120)
                                              .help("Enter the x value in the Mandelbrot coordinate system for the center of the image.")
                                              .disabled(drawColors)
                                }

                                VStack { // each input has a vertical container with a Text label & TextField for data
                                    Text("Enter center y")
                                    Text("Between -2 and 2")
                                    TextField("0.0",
                                              value: $doc.picdef.yCenter,
                                              formatter: ContentView.fmtXY) { isStarted in
                                        if isStarted {
                                            self.pauseUpdates()
                                        }
                                    }
                                              .onSubmit {
                                                  showMandArtBitMap()
                                                  print("triggering tab from Y")
                                                  self.triggerTab(on: self.textFieldY)
                                              }
                                              .textFieldStyle(.roundedBorder)
                                              .multilineTextAlignment(.trailing)
                                              .padding(4)
                                              .frame(maxWidth: 120)
                                              .help("Enter the Y value in the Mandelbrot coordinate system for the center of the image.")
                                              .disabled(drawColors)
                                }
                            } // end HStack for XY

                            //  Show Row (HStack) of Scale Next

                            HStack {
                                VStack {
                                    Text("Rotate (º)")

                                    TextField("0",
                                              value: $doc.picdef.theta,
                                              formatter: ContentView.fmtRotationTheta) { isStarted in
                                        if isStarted {
                                            self.pauseUpdates()
                                        }
                                    }
                                              .onSubmit {
                                                  showMandArtBitMap()
                                              }
                                              .textFieldStyle(.roundedBorder)
                                              .multilineTextAlignment(.trailing)
                                              .frame(maxWidth: 50)
                                              .help("Enter the angle to rotate the image clockwise, in degrees.")
                                              .disabled(drawColors)
                                }

                                VStack {
                                    Text("Scale")
                                    TextField("430", value: $doc.picdef.scale, formatter: ContentView.fmtScale) { isStarted in
                                        if isStarted {
                                            //                print("editing scale, pausing updates")
                                            self.pauseUpdates()
                                        }
                                    }
                                    .onSubmit {
                                        //               print("submitted, will update now")
                                        showMandArtBitMap()
                                    }
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 100)
                                    .help("Enter the magnification of the image.")
                                    .disabled(drawColors)
                                }
                                VStack {
                                    Text("Zoom")

                                    HStack {
                                        Button("+") { zoomIn() }
                                            .help("Zoom in by a factor of two.")
                                            .disabled(drawColors)

                                        Button("-") { zoomOut() }
                                            .help("Zoom out by a factor of two.")
                                            .disabled(drawColors)
                                    }
                                }
                            }

                            Divider()

                            HStack {
                                Text("Sharpening (iterationsMax):")

                                TextField("10,000", value: $doc.picdef.iterationsMax, formatter: ContentView.fmtSharpeningItMax) { isStarted in
                                    if isStarted {
                                        //                 print("editing iterationsMax, pausing updates")
                                        self.pauseUpdates()
                                    }
                                }
                                .onSubmit {
                                    //                  print("submitted, will update now")
                                    showMandArtBitMap()
                                }
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.trailing)
                                .help("Enter the maximum number of iterations for a given point in the image. A larger value will increase the resolution, but slow down the calculation.")
                                .disabled(drawColors)
                                .frame(maxWidth: 70)
                            }
                            .padding(.horizontal)

                            HStack {
                                Text("Color smoothing (rSqLimit):")

                                TextField("400", value: $doc.picdef.rSqLimit, formatter: ContentView.fmtSmootingRSqLimit) { isStarted in
                                    if isStarted {
                                        //                 print("editing rSqLimit, pausing updates")
                                        self.pauseUpdates()
                                    }
                                }
                                .onSubmit {
                                    //            print("submitted, will update now")
                                    showMandArtBitMap()
                                }
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 60)
                                .help("Enter the minimum value for the square of the distance from the origin of the Mandelbrot coordinate system. A larger value will smooth the color gradient, but slow down the calculation.")
                                .disabled(drawColors)
                            }

                            Divider()

                            HStack {
                                Text("Hold fraction (yY)")
                            }

                            HStack {
                                Text("0")
                                Slider(value: $doc.picdef.yY, in: 0 ... 1, step: 0.1)
                                    .help("Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient.")
                                Text("1")

                                TextField("0", value: $doc.picdef.yY,
                                          formatter: ContentView.fmtHoldFractionGradient)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 50)
                                .help("Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient.")
                            }
                            .padding(.horizontal)

                            Divider()
                        } // END GROUP 3 X, Y, SCALE

                        // GROUP 4 - GRADIENT

                        Group {
                            //  Show Row (HStack) of Gradient Content Next

                            HStack {
                                Text("Draw gradient from color")

                                TextField("1", value: $doc.picdef.leftNumber,
                                          formatter: ContentView.fmtLeftGradientNumber /* ,
                                                                                        onCommit: {
                                                                                        // do something when text field loses focus
                                                                                        showGradient()
                                                                                        } */ )
                                .frame(maxWidth: 30)
                                .foregroundColor(leftGradientIsValid ? .primary : .red)
                                .help("Select the color number for the left side of a gradient.")

                                Text("to " + String(rightGradientColor))
                                    .help("The color # for the right side of a gradient.")

                                Button("Go") { showGradient() }
                                    .help("Draw a gradient between two adjoining colors.")
                            }

                            Divider()
                        } // END GROUP 4 - GRADIENT

                        // GROUP 5 - COLOR TUNING GROUP

                        Group {
                            HStack {
                                Text("Coloring Options")
                            }

                            Divider()

                            HStack {
                                VStack {
                                    Text("Spacing")
                                    Text("far from MiniMand")
                                    Text("near to edge")

                                    TextField("5", value: $doc.picdef.spacingColorFar, formatter: ContentView.fmtSpacingNearEdge)
                                    /*           { isStarted in
                                     if isStarted {
                                     //                print("editing spacingColorFar, pausing updates")
                                     //          self.pauseUpdates()
                                     }
                                     }
                                     .onSubmit {
                                     showMandArtBitMap()
                                     }*/
                                        .textFieldStyle(.roundedBorder)
                                        .multilineTextAlignment(.trailing)
                                        .frame(maxWidth: 80)
                                        .help("Enter the value for the color spacing near the edges of the image, awwy from MiniMand.")
                                }

                                VStack {
                                    Text("Spacing")
                                    Text("near to MiniMand")
                                    Text("far from edge")

                                    TextField("15", value: $doc.picdef.spacingColorNear, formatter: ContentView.fmtSpacingFarFromEdge)
                                    /*               { isStarted in
                                     if isStarted {
                                     //                  print("editing spacingColorNear, pausing updates")
                                     self.pauseUpdates()
                                     }
                                     }
                                     .onSubmit {
                                     showMandArtBitMap()
                                     }*/
                                        .textFieldStyle(.roundedBorder)
                                        .multilineTextAlignment(.trailing)
                                        .frame(maxWidth: 80)
                                        .help("Enter the value for the color spacing away from the edges of the image, near the MiniMand.")
                                }
                            }

                            HStack {
                                VStack {
                                    Text("Change in minimum iteration:")

                                    TextField("0", value: $doc.picdef.dFIterMin, formatter: ContentView.fmtChangeInMinIteration)
                                        .textFieldStyle(.roundedBorder)
                                        .multilineTextAlignment(.trailing)
                                        .frame(maxWidth: 80)
                                        .help("Enter a value for the change in the minimum number of iterations in the image. This will change the coloring.")
                                }

                                VStack {
                                    Text("nBlocks:")

                                    TextField("60", value: $doc.picdef.nBlocks, formatter: ContentView.fmtNBlocks)
                                        .textFieldStyle(.roundedBorder)
                                        .multilineTextAlignment(.trailing)
                                        .frame(maxWidth: 80)
                                        .help("Enter a value for the number of blocks of color in the image. Each block is the gradient between two adjacent colors. If the number of blocks is greater than the number of colors, the colors will be repeated.")
                                }
                            }


                        } // end GROUP 5 - COLOR TUNING GROUP

                    } // end scroll bar
                    .frame(height: geometry.size.height)
                } // end top scoll bar geometry reader
                .frame(
                    minHeight: 200,
                    maxHeight: .infinity
                )
                .fixedSize(horizontal: false, vertical: false)



       /*         // GROUP FOR SHOWING SCREEN COLORS & PRINT COLORS

                Group {
                    Divider()

                    HStack {
                        Button("Show Screen Colors") { showScreenColors() }
                            .help("Show 512 colors that look good on the screen.")

                        Button("Show Print Colors") { showPrintColors() }
                            .help("Show 292 colors that should print well.")
                    }
                } // END GROUP FOR SHOWING SCREEN COLORS & PRINT COLORS*/



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

                        //Button("Verify Colors") {
                        //    MandMath.getListPrintabilityOfHues(hues: doc.picdef.hues)
                        //    MandMath.getClosestPrintableColors(hues: doc.picdef.hues)
                        //}
                        //.help("Check for printability.")
                        //.padding([.bottom], 2)


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
                            // $hue is a binding - a reference
                            // we could call it hueBinding instead.
                            // we need to get the wrapped value of $hue
                            // to get the the hue itself.
                            // We use the wrappedValue property
                            // of the hueBinding to get the underlying
                            // Hue object.
                            // This is because the hueBinding is a Binding
                            // to a Hue object, not the Hue object itself.
                            // By using the wrappedValue property,
                            // we can get the actual Hue object,
                            // which we use in the call to the
                            // getPrintableDisplayText function.
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
                                        // BHJ: used to get info
                                        // about printable color crayons
                                        // comment out or
                                        // remove if not needed
                                        hue.printColorInfo()
                                    }

                                if !isPrintable {
                                    Button() {
                                        self.showingPrintablePopups[i] = true
                                    } label: {
                                        Image(systemName: "exclamationmark.circle")
                                            .foregroundColor(.blue)
                                    }
                                    .help("See printable options for " + "\(hue.num)")
                                }
                                else {
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

                           //                     Text("Twas brillig and the")
                           //                     Text("slithy toves did")
                           //                     Text("gyre and gimble")
                           //                     Text("in the wabe...")
                                                Text("This color may not print well.")
                            //                    Text("You can try to find a better one,")
                            //                    Text("or you can click on one of the AP orP buttons")
                            //                    Text("to see some colors that should print better.")
                            //                    Text("Click on the color that you want changed,")
                            //                    Text("then click on the eyedropper and on one of the popup colors.")
                                                Text("See the instructions for options.")
                                                



                                                //let printableOptions = MandMath.getPrintableOptions(hue: doc.picdef.hues[i])

                                                //let swiftUIOptions = printableOptions.map { cgColor in
                                                    //Color(cgColor)
                                                //}

                                               // ForEach(swiftUIOptions, id: \.self) { color in
                                                 //   Rectangle()
                                                  //      .fill(color)
                                                  //      .frame(width: 30, height: 30)
                                                 //       .cornerRadius(8)
                                              //  }


                                            }  // end VStack of color options


                                        } // end VStack
                                       // .padding()
                                        .frame(width:150,height:100)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 10)
                                     //   .padding()

                                    } // end ZStack for popup
                                    .transition(.scale)
                                }  // end if self.showingPrintablePopups[i]








                                TextField("r", value: $hue.r, formatter: ContentView.fmt0to255)
                                    .onChange(of: hue.r) { newValue in
                                        doc.updateHueWithColorNumberR(
                                            index: i, newValue: newValue
                                        )
                                    }

                                TextField("g", value: $hue.g, formatter: ContentView.fmt0to255)
                                    .onChange(of: hue.g) { newValue in
                                        doc.updateHueWithColorNumberG(
                                            index: i, newValue: newValue
                                        )
                                    }

                                TextField("b", value: $hue.b, formatter: ContentView.fmt0to255)
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
                            doc.picdef.hues.move(fromOffsets: indices,
                                                 toOffset: hue)
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
            } // end VStack for user instructions - Below refers to the 2 cols
            .frame(width: inputWidth)
            .padding(2)

            // SECOND COLUMN - VSTACK - IS FOR IMAGES

            // RIGHT COLUMN IS FOR IMAGES......................

            ScrollView(showsIndicators: true) {
                VStack {

                    if activeDisplayState == ActiveDisplayChoice.MandArt {
                        let image: CGImage = getImage()!
                        GeometryReader {
                            _ in
                            ZStack(alignment: .topLeading) {
                                Image(image, scale: 1.0, label: Text("Test"))
                                    .gesture(self.tapGesture)
                            }
                        }

                    } else if activeDisplayState == ActiveDisplayChoice.Gradient {
                        let image: CGImage = getImage()!
                        GeometryReader {
                            _ in
                            ZStack(alignment: .topLeading) {
                                Image(image, scale: 1.0, label: Text("Test"))
                            }
                        }
                    } /*else if activeDisplayState == ActiveDisplayChoice.Color {
                        let image: CGImage = getImage()!
                        GeometryReader {
                            _ in
                            ZStack(alignment: .topLeading) {
                                Image(image, scale: 1.0, label: Text("Test"))
                            }
                        }
                    } else if activeDisplayState == ActiveDisplayChoice.ScreenColors {
                        Image("Screen colors")
                            .resizable()
                            .scaledToFit()
                    } else if activeDisplayState == ActiveDisplayChoice.PrintColors {
                        Image("Print colors")
                            .resizable()
                            .scaledToFit()
                    }*/

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
                                    let arrCGs = MandMath.getAllCGColorsList(iSort:iAll!)
                                    let arrColors = arrCGs.map { cgColor in
                                        Color(cgColor)
                                    }
                                    let nColumns = 64
                                    ForEach(0..<arrColors.count/nColumns) { rowIndex in
                                        HStack(spacing: 0) {
                                            ForEach(0..<nColumns) { columnIndex in
                                                let index = rowIndex * nColumns + columnIndex
                                                Rectangle()
                                                    .fill(arrColors[index])
                                                    .frame(width: 17, height: 27)
                                                    .cornerRadius(4)
                                                    .padding(1)
                                            }
                                        }
                                    }
                                }  // end VStack of color options
                                Spacer()
                            } // end VStack
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                            .padding()
                        } // end ZStack for popup
                        .transition(.scale)
                    }  // end if popup


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
                                    let arrCGs = MandMath.getAllPrintableCGColorsList(iSort:iAP!)
                                    let arrColors = arrCGs.map { cgColor in
                                        Color(cgColor)
                                    }
                                    let nColumns = 64
                                    ForEach(0..<arrColors.count/nColumns) { rowIndex in
                                        HStack(spacing: 0) {
                                            ForEach(0..<nColumns) { columnIndex in
                                                let index = rowIndex * nColumns + columnIndex
                                                Rectangle()
                                                    .fill(arrColors[index])
                                                    .frame(width: 17, height: 27)
                                                    .cornerRadius(4)
                                                    .padding(1)
                                            }
                                        }
                                    }
                                }  // end VStack of color options
                                Spacer()
                            } // end VStack
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                            .padding()
                        } // end ZStack for popup
                        .transition(.scale)
                    }  // end if popup



                    // IF USER WANTED TO SEE ONLY PRINTABLE COLORS
                    // * WITHOUT * PLACEHOLDERS

                    if iP  != nil {
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
                                    let arrCGs = MandMath.getPrintableCGColorListSorted(iSort:iP!)
                                    let arrColors = arrCGs.map { cgColor in
                                        Color(cgColor)
                                    }
                                    let nColumns = 32

                                        ForEach(0..<arrColors.count/nColumns) { rowIndex in
                                            HStack(spacing: 0) {
                                                ForEach(0..<nColumns) { columnIndex in
                                                    let index = rowIndex * nColumns + columnIndex
                                                    let color = arrColors[index]
                                                    let nsColor = NSColor(color)
                                                    let red = nsColor.redComponent
                                                    let green = nsColor.greenComponent
                                                    let blue = nsColor.blueComponent
                                                    //let colorValues = "R: \(Int(red*255)), G: \(Int(green*255)), B: \(Int(blue*255))"
                                                    //let colorValues = " \(Int(red*255)), \(Int(green*255)), \(Int(blue*255))"
                                                    let colorValues = " \(String(format: "%03d", Int(red*255))) \(String(format: "%03d", Int(green*255))) \(String(format: "%03d", Int(blue*255)))"

                                                    let colorValueR = "\(Int(red*255))"
                                                    let colorValueG = "\(Int(green*255))"
                                                    let colorValueB = "\(Int(blue*255))"

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

                                                            //Text(colorValues)
                                                               // .font(.system(size: 8))
                                                             //   .padding(1)
                                                             //   .background(Color.white)
                                                               // .cornerRadius(2)
                                                               // .shadow(radius: 2)

                                                    } // end Zstack of rect, rgb values
                                                }// end for each column of colors
                                            } // end HStack of colors

                                        } // end for each color


                                }  // end VStack of color options
                                Spacer()
                            } // end VStack
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 10)
                            .padding()
                        } // end ZStack for popup
                        .transition(.scale)
                    }  // end if popup






                } // end VStack right side (picture space)
                .padding(2)
            } // end image scroll view
            .padding(2)
        } // end HStack
    } // end view body

    /// tapGesture is a variable that defines a drag gesture
    /// for the user interaction in the user interface.
    ///
    /// The gesture is of type some Gesture
    /// and uses the DragGesture struct from the SwiftUI framework.
    ///
    /// The minimum distance for the drag gesture is set to 10 units,
    /// and the coordinate space for the gesture is set to .local.
    ///
    /// The gesture has an onChanged closure that is triggered
    /// whenever the gesture is changed by the user's interaction.
    ///
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
                if self.moved < 1, self.moved > -1 {
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
        formatter.maximum = 10000
        return formatter
    }

    static var fmtXY: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.isPartialStringValidationEnabled = true
        formatter.maximumFractionDigits = 8
        formatter.maximum = 2.0
        formatter.minimum = -2.0
        return formatter
    }

    static var fmtRotationTheta: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimum = -359
        formatter.maximum = 359
        return formatter
    }

    static var fmtScale: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimum = 1
        formatter.maximum = 100_000_000_000
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
        formatter.maximum = 1000
        return formatter
    }

    static var fmtSpacingFarFromEdge: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimum = 1
        formatter.maximum = 1000
        return formatter
    }

    static var fmtChangeInMinIteration: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimum = 0
        formatter.maximum = 1000
        return formatter
    }

    static var fmtNBlocks: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimum = 1
        formatter.maximum = 2000
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


    /// Calculated variable for the image aspect ratio.
    /// Uses user-specified image height and width.
    private var aspectRatio: String {
        let h = Double(doc.picdef.imageHeight)
        let w = Double(doc.picdef.imageWidth)
        let ratioDouble: Double = max(h / w, w / h)
        let ratioString = String(format: "%.2f", ratioDouble)
        return ratioString
    }

    private var leftGradientIsValid: Bool {
        var isValid = false
        let leftNum = doc.picdef.leftNumber
        let lastPossible = doc.picdef.hues.count
        isValid = leftNum >= 1 && leftNum <= lastPossible
        return isValid
    }

    private var rightGradientColor: Int {
        if leftGradientIsValid, doc.picdef.leftNumber < doc.picdef.nColors {
            return doc.picdef.leftNumber + 1
        }
        return 1
    }

    private func getPrintableDisplayText(color: Color, num: Int) -> String {
        if MandMath.isColorInPrintableList(color: color.cgColor!, num: num) {
            return " "
        } else {
            return "!"
        }
    }

    private func getIsPrintable(color: Color, num: Int) -> Bool {
        if MandMath.isColorNearPrintableList(color: color.cgColor!, num: num) {
            return true
        } else {
            return false
        }
    }



    /// Returns the new x to be the picture center x when user drags in the picture.
    ///
    /// - Parameter tap: information about the drag
    ///
    /// - Returns: Double new center x
    ///
    private func getCenterXFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
        let startX = tap.startLocation.x
        let startY = tap.startLocation.y
        let endX = tap.location.x
        let endY = tap.location.y
        let movedX = endX - startX
        let movedY = endY - startY
        let thetaDegrees = Double(doc.picdef.theta)
        let thetaRadians = -3.14159 * thetaDegrees / 180 // change sign since positive angle is clockwise
        let diffX = movedX / doc.picdef.scale
        let diffY = movedY / doc.picdef.scale
        let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
        let newCenter: Double = doc.picdef.xCenter - dCenterX
        return newCenter
    }

    /// Returns the new y to be the picture center y when user drags in the picture.
    ///
    /// - Parameter tap: information about the drag
    ///
    /// - Returns: Double new center y
    ///
    private func getCenterYFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
        let startX = tap.startLocation.x
        let startY = tap.startLocation.y
        let endX = tap.location.x
        let endY = tap.location.y
        let movedX = endX - startX
        let movedY = endY - startY
        let thetaDegrees = Double(doc.picdef.theta)
        let thetaRadians = -3.14159 * thetaDegrees / 180 // change sign since positive angle is clockwise
        let diffX = movedX / doc.picdef.scale
        let diffY = movedY / doc.picdef.scale
        let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
        let newCenter: Double = doc.picdef.yCenter + dCenterY
        return newCenter
    }

    /// Returns the new x to be the picture center x when user clicks on the picture.
    ///
    /// - Parameter tap: information about the tap
    ///
    /// - Returns: Double new center x = current x + (tapX - (imagewidth / 2.0)/ scale
    ///
    private func getCenterXFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
        print("getting x from tap")
        let startX = tap.startLocation.x
        let startY = tap.startLocation.y
        let w = Double(doc.picdef.imageWidth)
        let h = Double(doc.picdef.imageHeight)
        let thetaDegrees = Double(doc.picdef.theta)
        let thetaRadians = -3.14159 * thetaDegrees / 180 // change sign since positive angle is clockwise
        let diffX = (startX - w / 2.0) / doc.picdef.scale
        let diffY = ((h - startY) - h / 2.0) / doc.picdef.scale
        let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
        let newCenter: Double = doc.picdef.xCenter + dCenterX
        return newCenter
    }

    /// Returns the new y to be the picture center y when user clicks on the picture.
    ///
    /// - Parameter tap: information about the tap
    ///
    /// - Returns: Double new center y = current y + ( (imageHeight / 2.0)/ scale - tapY)
    ///
    private func getCenterYFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
        print("getting y from tap")
        let startX = tap.startLocation.x
        let startY = tap.startLocation.y
        let w = Double(doc.picdef.imageWidth)
        let h = Double(doc.picdef.imageHeight)
        let thetaDegrees = Double(doc.picdef.theta)
        let thetaRadians = -3.14159 * thetaDegrees / 180 // change sign since positive angle is clockwise
        let diffX = (startX - w / 2.0) / doc.picdef.scale
        let diffY = ((h - startY) - h / 2.0) / doc.picdef.scale
        let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
        let newCenter: Double = doc.picdef.yCenter + dCenterY
        return newCenter
    }

    /// Return the document directory for this app.
    ///
    /// - Returns: URL to document directory
    ///
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    /// Update hue nums after moviing or deleting
    ///
    fileprivate func updateHueNums() {
        for (index, _) in $doc.picdef.hues.enumerated() {
            doc.picdef.hues[index].num = index + 1
        }
    }

    /// Function to validate all colors in the picdef
    ///
    fileprivate func validateColors() {
        // TODO: communicate with user
    }

    /// Function to validate X or Y input
    ///
    fileprivate func validateX() -> Bool {
        true
    }

    /// Function to move an ordered color (hue) from one place to another in the list
    ///
    fileprivate func moveHue(from source: IndexSet, to destination: Int) {
        doc.picdef.hues.move(fromOffsets: source, toOffset: destination)
    }

    /// Show the screen colors for the user to choose from.
    ///
    /// This function updates the activeDisplayState property
    /// with the value .ScreenColors to indicate that screen colors should be displayed.
    ///
    fileprivate func showScreenColors() {
        activeDisplayState = ActiveDisplayChoice.ScreenColors
    }

    /// Show the print colors for the user to choose from.
    ///
    /// This function updates the activeDisplayState property
    /// with the value .PrintColors to indicate that print colors should be displayed.
    ///
    fileprivate func showPrintColors() {
        activeDisplayState = ActiveDisplayChoice.PrintColors
    }

    /// Get the app ready to draw colors.
    fileprivate func readyForColors() {
        drawIt = false
        drawGradient = false
        drawColors = true
    }

    /// Pause updates to the calculationally-intensive bitmap
    ///  while the user inputs numeric entries.
    fileprivate func pauseUpdates() {
        drawIt = false
        drawGradient = false
        drawColors = false
    }

    fileprivate func showMandArtBitMap() {
        activeDisplayState = ActiveDisplayChoice.MandArt
        readyForPicture()
    }

    fileprivate func showGradient() {
        activeDisplayState = ActiveDisplayChoice.Gradient
        readyForGradient()
    }

    /// Get the app ready to draw a MandArt picture.
    fileprivate func readyForPicture() {
        drawIt = true
        drawColors = false
    }

    /// Get the app ready to draw a gradient.
    fileprivate func readyForGradient() {
        drawIt = false
        drawGradient = true
    }

    fileprivate func resetAllPopupsToFalse() {
        showingAllColorsPopups = Array(repeating: false, count: 6)
        showingPrintableColorsPopups = Array(repeating: false, count: 6)
        showingAllPrintableColorsPopups = Array(repeating: false, count: 6)
    }

    /// Multiplies scale by 2.0.
    func zoomIn() {
        readyForPicture()
        doc.picdef.scale = doc.picdef.scale * 2.0
    }

    /// Divides scale by 2.0.
    func zoomOut() {
        readyForPicture()
        doc.picdef.scale = doc.picdef.scale / 2.0
    }

    /// Trigger a tab key press event
    ///
    ///  TODO:  add this to each numeric field's
    ///  onSubmit() logic so that hitting RETURN
    ///  would also tab to the next field.
    ///
    ///  Not currently used as it doesn't know the TextField it was
    ///  called on, so it can't go to the next field.
    ///
    ///  - Parameter textField: The `NSTextField` to trigger the tab event on.
    ///
    func triggerTab(on textField: NSTextField) {
        print("tab")
        let keyCode = NSEvent.SpecialKey.tab.rawValue
        print(keyCode)
        let keyEvent = NSEvent.keyEvent(with: .keyDown,
                                        location: NSPoint(),
                                        modifierFlags: [],
                                        timestamp: 0,
                                        windowNumber: 0,
                                        context: nil,
                                        characters: "\t",
                                        charactersIgnoringModifiers: "\t",
                                        isARepeat: false,
                                        keyCode: UInt16(keyCode))!
        textField.window?.sendEvent(keyEvent)
        print(keyEvent)
    }
}

