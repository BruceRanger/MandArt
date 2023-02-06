//
//  ContentView.swift
//  MandArt
//
//  Created by Bruce Johnson on 9/20/21.
//  Revised and updated 2021-2
//  All rights reserved.

import Foundation // trig functions
import SwiftUI // views

// File / Project Settings / Per-user project settings / derived data
// set to project-relative path DerivedData
// now I can see the intermediate build products.

// Declare global variables first (outside the ContentView struct)
var contextImageGlobal: CGImage?
var fIterGlobal = [[Double]]()

struct ContentView: View {
    // TODO: move non-SwiftUI functions and logic into MandMath
    // Get everything we can from MandMath (Swift-only)
    let defaultFileName = MandMath.getDefaultDocumentName()
    let printableColorList = MandMath.getPrintableColorList()

    // the remaining content should all require SwiftUI
    @EnvironmentObject var doc: MandArtDocument

    let instructionBackgroundColor = Color.green.opacity(0.5)
    let instructionBackgroundColorLite = Color.green.opacity(0.6)

    let inputWidth: Double = 290

    @StateObject var errdef = ErrorViewModel()
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
    @State private var stringYC: String = ""

    enum ActiveDisplayChoice {
        case MandArt
        //      case Pause
        case Gradient
        case Color
        case ScreenColors
        case PrintColors
    }

    /// Gets an image to display on the right side of the app
    /// - Returns: An optional CGImage or nil
    func getImage() -> CGImage? {
        var colors: [[Double]] = []

        doc.picdef.hues.forEach { hue in
            let arr: [Double] = [hue.r, hue.g, hue.b]
            colors.insert(arr, at: colors.endIndex)
        }

        let imageWidth: Int = doc.picdef.imageWidth
        let imageHeight: Int = doc.picdef.imageHeight

        if activeDisplayState == ActiveDisplayChoice.MandArt && drawIt {
            return getPictureImage(&colors)
        } else if activeDisplayState == ActiveDisplayChoice.Gradient && drawGradient == true && leftGradientIsValid {
            return getGradientImage(imageWidth, imageHeight, doc.picdef.leftNumber, &colors)
        } else if drawColors == true {
            return getColorImage(&colors)
        }

        return nil
    }

    /// Function to create and return a user-created MandArt bitmap
    /// - Parameters:
    ///   - colors: array of colors
    /// - Returns: optional CGImage with the bitmap or nil
    fileprivate func getPictureImage(_ colors: inout [[Double]]) -> CGImage? {
        // draws image
        let imageHeight: Int = doc.picdef.imageHeight
        let imageWidth: Int = doc.picdef.imageWidth
        let iMax: Double = doc.picdef.iMax
        let scale: Double = doc.picdef.scale
        let xC: Double = doc.picdef.xC
        let yC: Double = doc.picdef.yC
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

                x0 = xC + dX * cos(thetaR) - dY * sin(thetaR)
                y0 = yC + dX * sin(thetaR) + dY * cos(thetaR)

                xx = x0
                yy = y0
                rSq = xx * xx + yy * yy
                iter = 0.0

                p = sqrt((xx - 0.25) * (xx - 0.25) + yy * yy)
                test1 = p - 2.0 * p * p + 0.25
                test2 = (xx + 1.0) * (xx + 1.0) + yy * yy

                if xx < test1 || test2 < 0.0625 {
                    fIter[u][v] = iMax // black
                    iter = iMax // black
                } // end if

                else {
                    for i in 1 ... Int(iMax) {
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

                if iter < iMax {
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
        let bE: Double = doc.picdef.bE
        let eE: Double = doc.picdef.eE
        var yY: Double = doc.picdef.yY

        if yY == 1.0 { yY = yY - 1.0e-10 }

        var dE = 0.0
        var fNBlocks = 0.0
        var color = 0.0
        var block0 = 0
        var block1 = 0

        fNBlocks = Double(nBlocks)

        dE = (iMax - fIterMin - fNBlocks * bE) / pow(fNBlocks, eE)

        var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

        var h = 0.0
        var xX = 0.0

        for i in 0 ... nBlocks {
            blockBound[i] = bE * Double(i) + dE * pow(Double(i), eE)
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

                if fIter[u][v] >= iMax { // black
                    pixelAddress.pointee = UInt8(0) // red
                    (pixelAddress + 1).pointee = UInt8(0) // green
                    (pixelAddress + 2).pointee = UInt8(0) // blue
                    (pixelAddress + 3).pointee = UInt8(255) // alpha
                } // end if

                else {
                    h = fIter[u][v] - fIterMin

                    for block in 0 ... nBlocks {
                        block0 = block

                        if h >= blockBound[block] && h < blockBound[block + 1] {
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
    /// - Parameters:
    ///   - imageHeight: Int bitmap image height in pixels
    ///   - imageWidth: Int bitmap image width in pixels
    ///   - nLeft: int number of the left hand color, starting with 1 (not 0)
    ///   - colors: array of colors (for the whole picture)
    /// - Returns: optional CGImage with the bitmap or nil
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

        var xGradient = 0.0

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

                //             h = blockBound[block] + ((h - blockBound[block]) - yY*(blockBound[block + 1] - blockBound[block]))/(1 - yY)

                //            uU = Double(u)

                //            uU = 0.0 + ((uU - 0.0) - yY*(Double(width) - 0.0))/(1 - yY)

                //             xX = (h - blockBound[block])/(blockBound[block + 1] - blockBound[block])

                xGradient = Double(u) / Double(width)

                color = colors[leftNumber - 1][0] + xGradient * (colors[rightNumber - 1][0] - colors[leftNumber - 1][0])
                pixelAddress.pointee = UInt8(color) // R

                color = colors[leftNumber - 1][1] + xGradient * (colors[rightNumber - 1][1] - colors[leftNumber - 1][1])
                (pixelAddress + 1).pointee = UInt8(color) // G

                color = colors[leftNumber - 1][2] + xGradient * (colors[rightNumber - 1][2] - colors[leftNumber - 1][2])
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

        return gradientImage
    }

    /// Function to create and return a user-colored MandArt bitmap
    /// - Parameters:
    ///   - colors: array of colors
    /// - Returns: optional CGImage with the colored bitmap or nil
    fileprivate func getColorImage(_ colors: inout [[Double]]) -> CGImage? {
        // draws image
        let imageHeight: Int = doc.picdef.imageHeight
        let imageWidth: Int = doc.picdef.imageWidth
        let iMax: Double = doc.picdef.iMax
        let dFIterMin: Double = doc.picdef.dFIterMin
        let nBlocks: Int = doc.picdef.nBlocks
        let nColors: Int = doc.picdef.hues.count
        let bE: Double = doc.picdef.bE
        let eE: Double = doc.picdef.eE
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

        var dE = 0.0
        var fNBlocks = 0.0
        var color = 0.0
        var block0 = 0
        var block1 = 0

        fNBlocks = Double(nBlocks)

        dE = (iMax - fIterMin - fNBlocks * bE) / pow(fNBlocks, eE)

        var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

        var h = 0.0
        var xX = 0.0

        for i in 0 ... nBlocks {
            blockBound[i] = bE * Double(i) + dE * pow(Double(i), eE)
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

                if fIterGlobal[u][v] >= iMax { // black
                    pixelAddress.pointee = UInt8(0) // red
                    (pixelAddress + 1).pointee = UInt8(0) // green
                    (pixelAddress + 2).pointee = UInt8(0) // blue
                    (pixelAddress + 3).pointee = UInt8(255) // alpha
                } // end if

                else {
                    h = fIterGlobal[u][v] - fIterMin

                    for block in 0 ... nBlocks {
                        block0 = block

                        if h >= blockBound[block] && h < blockBound[block + 1] {
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
        HStack { // instructions on left, picture on right
            // Left (first) VStack is left side with user stuff
            // Right (second) VStack is for mandart, gradient, or colors
            // Sspacing is between VStacks
            VStack(alignment: .center, spacing: 10) {
                Group { // non scroll group at top
                    Text("MandArt")
                        .font(.title)
                    HStack {
                        VStack {
                            Button("Draw picture") { showMandArtBitMap() }
                        }
                        .help("Draw the picture.")

                        VStack {
                            Button("Pause") {
                                drawIt = false
                                drawGradient = false
                                drawColors = false
                            }
                            .help("Pause to change values.")
                        }

                        VStack {
                            Button("+") { zoomIn() }
                        }
                        .help("Zoom in by a factor of two.")

                        VStack {
                            Button("-") { zoomOut() }
                        }
                        .help("Zoom out by a factot of two.")
                    }

                    HStack {
                        VStack {
                            Button("Show screen colors") { showScreenColors() }
                                .help("Show 512 colors that look good on the screen.")
                        }

                        VStack {
                            Button("Show print colors") { showPrintColors() }
                                .help("Show 292 colors that should print well.")
                        }
                    }

                    HStack {
                        Text("Enter left color #:")
                        TextField("leftNumber", value: $doc.picdef.leftNumber,
                                  formatter: ContentView.cgIintMaxColorsFormatter)
                            .frame(maxWidth: 30)
                            .foregroundColor(leftGradientIsValid ? .primary : .red)
                            .help("Select the color # for the left side of a gradient.")

                        Text("to " + String(rightGradientColor))
                    }

                    HStack {
                        VStack {
                            Button("Make a gradient") { showGradient() }
                                .help("Draw a gradient between two adjoining colors.")
                        }

                        VStack {
                            Button("Color the image") { readyForColors() }
                                .help("Color the image using the existing iteration data.")
                        }
                    }

                    HStack {
                        VStack {
                            Button("Show screen colors") { showScreenColors() }
                                .help("Show 512 colors that look good on the screen.")
                        }

                        VStack {
                            Button("Show print colors") { showPrintColors() }
                                .help("Show 292 colors that should print well.")
                        }
                    }
                } // end non scroll group at top

                Divider()

                ScrollView(showsIndicators: true) {
                    Group { // 1 in scrollbar
                        HStack {
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("Enter center X")

                                Text("Between -2 and 2")
                                TextField("Number", value: $doc.picdef.xC, formatter: ContentView.cgDecimalAbs2Formatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .padding(4)
                                    .frame(maxWidth: 120)
                                    .help("Enter the X value in the Mandelbrot coordinate system for the center of the image.")
                            } // end VStack

                            VStack {
                                Text("Enter center Y")

                                Text("Between -2 and 2")

                                TextField("0.08442",
                                          text: $stringYC)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .padding(4)
                                    .frame(maxWidth: 120)
                                    .help("Enter the Y value in the Mandelbrot coordinate system for the center of the image.")
                                    .onSubmit {
                                        let f = NumberFormatter()
                                        f.numberStyle = .decimal
                                        f.maximumFractionDigits = 8
                                        f.minimumFractionDigits = 8
                                        f.isPartialStringValidationEnabled = false
                                        if let d = f.number(from: stringYC)?.doubleValue {
                                            if d >= -2.00000000 && d <= 2.00000000 {
                                                self.doc.picdef.yC = d
                                            } else {
                                                print("error, invalid YC")
                                            }
                                        } else {
                                            print("error, invalid format for YC")
                                        }
                                    } // end method
                            } // end VStack
                        } // end HStack
                    } // end group 1 in scrollbar

                    Group { // start group 2 in scrollbar
                        HStack {
                            VStack {
                                Text("scale:")

                                TextField("Scale", value: $doc.picdef.scale, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 100)
                                    .help("Enter the magnification of the image.")
                            }

                            VStack {
                                Text("iMax:")

                                TextField("iMax", value: $doc.picdef.iMax, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 60)
                                    .help("Enter the maximum number of iterations for a given point in the image. A larger value will increase the resolution, but slow down the calculation.")
                            }

                            VStack {
                                Text("rSqLimit:")

                                TextField("rSqLimit", value: $doc.picdef.rSqLimit, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 60)
                                    .help("Enter the minimum value for the square of the distance from the origin of the Mandelbrot coordinate system. A larger value will increase the resolution, but slow down the calculation.")
                            }
                        }

                        HStack {
                            VStack {
                                Text("Image")

                                Text("width, px:")
                                TextField("imageWidth", value: $doc.picdef.imageWidth, formatter: ContentView.cgIntPositiveFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter the width, in pixels, of the image.")
                            }
                            VStack {
                                Text("Image")

                                Text("height, px:")
                                TextField("imageHeightStart", value: $doc.picdef.imageHeight, formatter: ContentView.cgIntPositiveFormatter)
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

                        HStack {
                            VStack {
                                Text("bE:")

                                TextField("bE", value: $doc.picdef.bE, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter the value for the color spacing near the edges of the image.")
                            }

                            VStack {
                                Text("eE:")

                                TextField("eE", value: $doc.picdef.eE, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter the value for the color spacing away from the edges of the image.")
                            }

                            VStack {
                                Text("theta:")

                                TextField("theta", value: $doc.picdef.theta, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter the angle to rotate the image clockwise, in degrees.")
                            }
                        }

                        HStack {
                            VStack {
                                Text("nImage:")

                                TextField("nImage", value: $doc.picdef.nImage, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter the number to be applied to a saved image.")
                            }

                            VStack {
                                Text("dFIterMin:")

                                TextField("dFIterMin", value: $doc.picdef.dFIterMin, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter a value for the change in the minimum number of iterations in the image. This will change the coloring.")
                            }
                            VStack {
                                Text("nBlocks:")

                                TextField("nBlocks", value: $doc.picdef.nBlocks, formatter: ContentView.cgIntNBlocksFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter a value for the number of blocks of color in the image. Each block is the gradient between two adjacent colors. If the number of blocks is greater than the number of colors, the colors will be repeated.")
                            }
                        }

                        HStack {
                            VStack {
                                Text("yY:")

                                TextField("yY", value: $doc.picdef.yY, formatter: ContentView.cgDecimalUnboundFormatter)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: 80)
                                    .help("Enter a value for the fraction of a block of colors that will be a solid color before the rest is a gradient.")
                            }
                        }
                    } // end group 2 in scrollbar
                } // end scroll bar

                List {
                    ForEach($doc.picdef.hues, id: \.num) { $hue in
                        HStack {
                            TextField("number", value: $hue.num, formatter: ContentView.cgDecimalUnboundFormatter)
                                .disabled(true)
                                .frame(maxWidth: 50)
                            TextField("r", value: $hue.r, formatter: ContentView.cg255Formatter)
                                .onChange(of: hue.r) { newValue in
                                    let i = hue.num - 1
                                    doc.updateHueWithColorNumberR(
                                        index: i, newValue: newValue
                                    )
                                }
                            TextField("g", value: $hue.g, formatter: ContentView.cg255Formatter)
                                .onChange(of: hue.g) { newValue in
                                    let i = hue.num - 1
                                    doc.updateHueWithColorNumberG(
                                        index: i, newValue: newValue
                                    )
                                }
                            TextField("b", value: $hue.b, formatter: ContentView.cg255Formatter)
                                .onChange(of: hue.b) { newValue in
                                    let i = hue.num - 1
                                    doc.updateHueWithColorNumberB(
                                        index: i, newValue: newValue
                                    )
                                }

                            ColorPicker("", selection: $hue.color, supportsOpacity: false)
                                .onChange(of: hue.color) { newColor in
                                    let i = hue.num - 1
                                    doc.updateHueWithColorPick(
                                        index: i, newColorPick: newColor
                                    )
                                }
                            Button {
                                let i = hue.num - 1
                                doc.deleteHue(index: i)
                                updateHueNums()
                                readyForPicture()
                            } label: {
                                Image(systemName: "trash")
                            }
                            .padding(.trailing, 5)
                            .help("Delete " + "\(hue.num)")
                        }
                        .listRowBackground(instructionBackgroundColor)
                    } // end foreach
                    .onMove { indices, hue in
                        doc.picdef.hues.move(fromOffsets: indices,
                                             toOffset: hue)
                        updateHueNums()
                    }
                } // end list

                HStack {
                    VStack {
                        Button("Add Color") { doc.addHue() }
                            .padding([.bottom], 2)
                    }
                }
            } // end VStack for user instructions
            .background(instructionBackgroundColor)
            .frame(width: inputWidth)
            .padding(10)
            .errorAlert(error: $errdef.errorCustomObject)

            VStack {
                if activeDisplayState == ActiveDisplayChoice.MandArt {
                    let image: CGImage = getImage()!
                    GeometryReader {
                        _ in
                        ZStack(alignment: .topLeading) {
                            Image(image, scale: 1.0, label: Text("Test")).gesture(self.tapGesture)
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
                } else if activeDisplayState == ActiveDisplayChoice.Color {
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
                }
            } // end right side (picture space)
        } // end HStack
    } // end view body

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
                // only respond to taps if this is a picture not gradient
                if drawIt == true {
                    // if we haven't moved very much, treat it as a tap event
                    if self.moved < 1 && self.moved > -1 {
                        doc.picdef.xC = getCenterXFromTap(tap)
                        doc.picdef.yC = getCenterYFromTap(tap)
                        readyForPicture()
                    }
                    // if we have moved a lot, treat it as a drag event
                    else {
                        doc.picdef.xC = getCenterXFromDrag(tap)
                        doc.picdef.yC = getCenterYFromDrag(tap)
                        readyForPicture()
                    }
                    // reset tap event states
                    self.moved = 0
                    self.startTime = nil
                }
            }
    } // end tapGesture

    // HELPER FUNCTIONS AND PRIVATE VARIABLES DOWN HERE......

    /*

     In general, both the text and the value properties of a TextField in SwiftUI will update after each character is entered by the user. This allows you to access the updated value of the text field in real-time as the user is entering text, and to respond to changes in the text field's contents as needed.

     For example, if you have a TextField bound to a String property using the text property, you can observe changes to the text field's contents in real-time, and perform actions such as filtering a list of items or making API requests as the user types. Similarly, if you have a TextField bound to an Int or Double property using the value property and a formatter, you can use the updated value of the text field to perform calculations or validate user input in real-time as the user enters text.

     You can use a Binding<String> with a custom NumberFormatter and the isPartialFormatter property set to true to wait until all characters have been entered, then apply the NumberFormatter:

     The isPartialStringValidationEnabled property of a NumberFormatter in Swift is a Boolean value that determines whether the formatter should validate partial strings as the user enters text into a text field.

     When isPartialStringValidationEnabled is set to true, the formatter will validate each partial string entered by the user and apply the appropriate formatting as the user types. This can be useful if you want to enforce a specific format for the number entered by the user, or if you want to immediately display errors if the user enters an invalid character.

     When isPartialStringValidationEnabled is set to false, the formatter will only validate the final string entered by the user, after the user has finished entering the value. This can be useful if you want to allow the user to enter a partial value without immediately validating it, or if you want to provide more lenient validation and only enforce the desired format once the user has finished entering the value.

     The value of isPartialStringValidationEnabled will depend on your specific use case and how you want to handle user input in your app.

     */

    static var cg255Formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimum = 0
        formatter.maximum = 255
        return formatter
    }

    static var cgDecimalAbs2Formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.isPartialStringValidationEnabled = true
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 8
        formatter.maximum = 2.0
        formatter.minimum = -2.0
        return formatter
    }

    static var cgDecimalUnboundFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        return formatter
    }

    static var cgIntPositiveFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 10000
        formatter.maximumFractionDigits = 0
        return formatter
    }

    static var cgDecimal2Formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }

    static var cgIintMaxColorsFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 20
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2
        return formatter
    }

    static var cgIntNBlocksFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 2000
        formatter.minimumIntegerDigits = 1
        return formatter
    }

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
        if leftGradientIsValid && doc.picdef.leftNumber < doc.picdef.nColors {
            return doc.picdef.leftNumber + 1
        }
        return 1
    }

    /*   /// Returns the new x to be the picture center x when user drags in the picture.
     /// - Parameter tap: information about the drag
     /// - Returns: Double new center x
     private func getCenterXFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
     let start = tap.startLocation.x
     let end = tap.location.x
     let moved = end - start
     let diff = moved / doc.picdef.scale
     let newCenter: Double = doc.picdef.xC - diff
     return newCenter
     }

     /// Returns the new y to be the picture center y when user drags in the picture.
     /// - Parameter tap: information about the drag
     /// - Returns: Double new center y
     private func getCenterYFromDrag(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
     let start = tap.startLocation.y
     let end = tap.location.y
     let moved = end - start
     let diff = moved / doc.picdef.scale
     let newCenter = doc.picdef.yC + diff
     return newCenter
     }   */

    /// Returns the new x to be the picture center x when user drags in the picture.
    /// - Parameter tap: information about the drag
    /// - Returns: Double new center x
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
        let newCenter: Double = doc.picdef.xC - dCenterX
        return newCenter
    }

    /// Returns the new y to be the picture center y when user drags in the picture.
    /// - Parameter tap: information about the drag
    /// - Returns: Double new center y
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
        let newCenter: Double = doc.picdef.yC + dCenterY
        return newCenter
    }

    /// Returns the new x to be the picture center x when user clicks on the picture.
    /// - Parameter tap: information about the tap
    /// - Returns: Double new center x = current x + (tapX - (imagewidth / 2.0)/ scale
    private func getCenterXFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
        let startX = tap.startLocation.x
        let startY = tap.startLocation.y
        let w = Double(doc.picdef.imageWidth)
        let h = Double(doc.picdef.imageHeight)
        let thetaDegrees = Double(doc.picdef.theta)
        let thetaRadians = -3.14159 * thetaDegrees / 180 // change sign since positive angle is clockwise
        let diffX = (startX - w / 2.0) / doc.picdef.scale
        let diffY = ((h - startY) - h / 2.0) / doc.picdef.scale
        let dCenterX = diffY * sin(thetaRadians) + diffX * cos(thetaRadians)
        let newCenter: Double = doc.picdef.xC + dCenterX
        return newCenter
    }

    /// Returns the new y to be the picture center y when user clicks on the picture.
    /// - Parameter tap: information about the tap
    /// - Returns: Double new center y = current y + ( (imageHeight / 2.0)/ scale - tapY)
    private func getCenterYFromTap(_ tap: _ChangedGesture<DragGesture>.Value) -> Double {
        let startX = tap.startLocation.x
        let startY = tap.startLocation.y
        let w = Double(doc.picdef.imageWidth)
        let h = Double(doc.picdef.imageHeight)
        let thetaDegrees = Double(doc.picdef.theta)
        let thetaRadians = -3.14159 * thetaDegrees / 180 // change sign since positive angle is clockwise
        let diffX = (startX - w / 2.0) / doc.picdef.scale
        let diffY = ((h - startY) - h / 2.0) / doc.picdef.scale
        let dCenterY = diffY * cos(thetaRadians) - diffX * sin(thetaRadians)
        let newCenter: Double = doc.picdef.yC + dCenterY
        return newCenter
    }

    /// Return the document directory for this app.
    /// - Returns: URL to document directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    /// Update hue nums after moviing or deleting
    fileprivate func updateHueNums() {
        for (index, _) in $doc.picdef.hues.enumerated() {
            doc.picdef.hues[index].num = index + 1
        }
    }

    /// Function to validate all colors in the picdef
    fileprivate func validateColors() {
        // TODO: communicate with user
    }

    /// Function to validate X or Y input
    fileprivate func validateX() -> Bool {
        return true
    }

    /// Function to move an ordered color (hue) from one place to another in the list
    fileprivate func moveHue(from source: IndexSet, to destination: Int) {
        doc.picdef.hues.move(fromOffsets: source, toOffset: destination)
    }

    fileprivate func showScreenColors() {
        activeDisplayState = ActiveDisplayChoice.ScreenColors
    }

    fileprivate func showPrintColors() {
        activeDisplayState = ActiveDisplayChoice.PrintColors
    }

    /// Get the app ready to draw colors.
    fileprivate func readyForColors() {
        drawIt = false
        drawGradient = false
        drawColors = true
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
    }

    /// Get the app ready to draw a gradient.
    fileprivate func readyForGradient() {
        drawIt = false
        drawGradient = true
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
}

@available(macOS 10.15, *)
extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

/// Handle validation feedback and local alerts
///  Based on
///  https://www.avanderlee.com/swiftui/error-alert-presenting/
///
struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }

    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(document: .constant(MandArtDocument()))
//    }
// }