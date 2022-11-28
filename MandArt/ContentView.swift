//
//  ContentView.swift
//  MandArt
//
//  Created by Bruce Johnson on 9/20/21.
//  Edited by Bruce Johnson on 8/7/22.

import SwiftUI
import Foundation   //for trig functions
import ImageIO
import CoreServices

// define some global variables for saving
var contextImageGlobal: CGImage?
var startFile = "default.json"
var countFile = "outcount.json"

struct ContentView: View {
    
    @StateObject private var picdef: PictureDefinition = ModelData.shared.load(startFile)
    
    let instructionBackgroundColor = Color.green.opacity(0.5)
    
    let inputWidth: Double = 290
    
    @State private var showingAlert = false
    @State private var tapX: Double = 0.0
    @State private var tapY: Double = 0.0
    
    @State private var tapLocations: [CGPoint] = []
    @State private var moved: Double = 0.0
    @State private var startTime: Date?
    
    @State private var dragCompleted = false
    @State private var dragOffset = CGSize.zero
    
    @State private var drawItStart = true
    @State private var drawGradientStart = false
    
    @State private var scaleOld: Double =  1.0
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getCenterXFromTapX(tapX: Double, imageWidthStart:Int) -> Double {
        let tapXDifference = (tapX - Double(picdef.imageWidthStart)/2.0)/picdef.scaleStart
        let newXC: Double = picdef.xCStart + tapXDifference // needs work
        print("Clicked on picture, newXC is",newXC)
        return newXC
    }
    
    func getCenterYFromTapY(tapY: Double, imageHeightStart:Int) -> Double {
        let tapYDifference = ((Double(picdef.imageHeightStart) - tapY) - Double(picdef.imageHeightStart)/2.0)/picdef.scaleStart
        let newYC: Double = (picdef.yCStart + tapYDifference) // needs work
        print("Clicked on picture, newYC is",newYC)
        return newYC
    }
    
    func zoomOut(){
        self.scaleOld = picdef.scaleStart
        picdef.scaleStart = self.scaleOld / 2.0
        print("Zoomed out, new scale is",picdef.scaleStart)
    }
    
    func zoomIn(){
        self.scaleOld = picdef.scaleStart
        picdef.scaleStart = self.scaleOld * 2.0
        print("Zoomed in, new scale is",picdef.scaleStart)
    }
    
    func readOutCount() -> Int {
        print("reading the picture count into state")
        var newCount: Int = 0
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent(countFile)
            print("in readOutCount() reading from ", fileURL)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let countdef = try decoder.decode(CountDefinition.self, from: data)
            newCount = countdef.nImages
            print("Just read the new i, it will be", newCount)
            return newCount
        } catch {
            debugPrint(error.localizedDescription)
            return newCount
        }
    }
    
     func saveOutCount(newi: Int) {
        print("Saving the new count for next time as ", newi)
        let encoder = JSONEncoder()
        do {
            // update the object before saving
            let updated:CountDefinition = CountDefinition()
            updated.nImages = newi
            let jsonData = try encoder.encode(updated)
            let fileURL = try FileManager.default
                .url(for: .applicationDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent(countFile)
            print("fileURL for OUTCOUNT JSON is ", fileURL)
            try jsonData.write(to: fileURL)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    fileprivate func saveImageData(i:Int) {
        do {
            let dn:String = "mandart" + String(i) + ".json"
            print("In saveDataFile() data filename = ", dn)
            let fileURL = try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent(dn)
            print("fileURL for JSON is ", dn)
            
            do {
                    // convert the struct to JSON string
                let jsonData = try JSONEncoder().encode(picdef)
                do {
                    try jsonData.write(to: fileURL)
                    print("Wrote json to ", dn)
                    let jsonString = String(data:jsonData, encoding: .utf8)!
                    print(jsonString)
                } catch { print(error)}
            } catch { print(error)}
        } catch { print(error)}
    }
    
    func saveImage(i: Int) -> Bool {
        let fn:String = "mandart" + String(i) + ".png"
        print("In saveImage() image filename = ", fn)
        
        let allocator : CFAllocator = kCFAllocatorDefault
        let filePath: CFString = fn as NSString
        let pathStyle: CFURLPathStyle = CFURLPathStyle.cfurlWindowsPathStyle
        let isDirectory: Bool = false
        
        let url : CFURL = CFURLCreateWithFileSystemPath(allocator, filePath, pathStyle, isDirectory)
        
            // e.g. mandart.png -- file:///Users/denisecase/Library/Containers/Bruce-Johnson.MandArt/Data/
        print("In saveImage(), file url is ", url)
        
            // create an image destination
            // if it doesn't work, return false
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        let imageType: CFString = kUTTypePNG
        let count: Int = 1
        let options: CFDictionary? = nil
        var destination: CGImageDestination
        
        let destinationAttempt: CGImageDestination?  = CGImageDestinationCreateWithURL(url, imageType, count, options)
        if (destinationAttempt == nil) {
            return false
        }
        else {
            destination = destinationAttempt.unsafelyUnwrapped
            CGImageDestinationAddImage(destination,contextImageGlobal!, nil);
            CGImageDestinationFinalize(destination)
            print("Wrote image to ", fn)
            saveImageData(i: i)
            print("In saveImage(), picture and data saved with int ",i)
            let newi = i + 1
            print("In saveImage(), incrementing to ",i)
            saveOutCount(newi: newi)
            return true
        }
    }
    
    func getImage(drawIt:Bool, drawGradient: Bool, leftNumber: Int) -> CGImage? {
        
        if drawIt == true { // draws image
            print("Drawing picture")

            var contextImage: CGImage
            
            var imageWidth: Int = 0
            var imageHeight: Int = 0
            var iMax: Double = 10_000.0
            var rSq: Double = 0.0
            var rSqLimit: Double = 0.0
            var rSqMax: Double = 0.0
            var x0: Double = 0.0
            var y0: Double = 0.0
            var dX: Double = 0.0
            var dY: Double = 0.0
            imageWidth = picdef.imageWidthStart
            imageHeight = picdef.imageHeightStart
            var xx: Double = 0.0
            var yy: Double = 0.0
            var xTemp: Double = 0.0
            var iter: Double = 0.0
            var dIter: Double = 0.0
            var gGML: Double = 0.0
            var gGL: Double = 0.0
            var fIter = [[Double]](repeating: [Double](repeating: 0.0, count: imageHeight), count: imageWidth)
            var fIterMinLeft: Double = 0.0
            var fIterMinRight: Double = 0.0
            var fIterBottom = [Double](repeating: 0.0, count: imageWidth)
            var fIterTop = [Double](repeating: 0.0, count: imageWidth)
            var fIterMinBottom: Double = 0.0
            var fIterMinTop: Double = 0.0
            var fIterMins = [Double](repeating: 0.0, count: 4)
            var fIterMin: Double = 0.0
            var scale: Double = 0.0
            var xC: Double = 0.0
            var yC: Double = 0.0
            var p: Double = 0.0
            var test1: Double = 0.0
            var test2: Double = 0.0
            
            var theta: Double = 0.0
            var thetaR: Double = 0.0
            var dIterMin: Double = 0.0
            let pi: Double = 3.14159
            
            theta = picdef.thetaStart
            dIterMin = picdef.dFIterMinStart
            thetaR = pi*theta/180.0
            
            rSqLimit = 400.0
            scale = picdef.scaleStart
            xC = picdef.xCStart
            yC = picdef.yCStart
            iMax = picdef.iMaxStart
            rSqLimit = picdef.rSqLimitStart
            rSqMax = 1.01*(rSqLimit + 2)*(rSqLimit + 2)
            gGML = log( log(rSqMax) ) - log(log(rSqLimit) )
            gGL = log(log(rSqLimit) )
            
            for u in 0...imageWidth - 1 {
                
                for v in 0...imageHeight - 1 {
                    
                    dX = (Double(u) - Double(imageWidth/2))/scale
                    dY = (Double(v) - Double(imageHeight/2))/scale
                    
                    x0 = xC + dX
                    y0 = yC + dY
                    
                    x0 = xC + dX*cos(thetaR) - dY*sin(thetaR)
                    y0 = yC + dX*sin(thetaR) + dY*cos(thetaR)
                    
                    xx = x0
                    yy = y0
                    rSq = xx*xx + yy*yy
                    iter = 0.0
                    
                    p = sqrt((xx - 0.25)*(xx - 0.25) + yy*yy)
                    test1 = p - 2.0*p*p + 0.25
                    test2 = (xx + 1.0)*(xx + 1.0) + yy*yy
                    
                    if xx < test1 || test2 < 0.0625 {
                        fIter[u][v] = iMax  // black
                        iter = iMax  // black
                    }   //end if
                    
                    else {
                        for i in 1...Int(iMax) {
                            if rSq >= rSqLimit{
                                break
                            }
                            
                            xTemp = xx*xx - yy*yy + x0
                            yy = 2*xx*yy + y0
                            xx = xTemp
                            rSq = xx*xx + yy*yy
                            iter = Double(i)
                        }
                    }   //end else
                    
                    if iter < iMax {
                        
                        dIter = Double(-(  log( log(rSq) ) - gGL  )/gGML)
                        
                        fIter[u][v] = iter + dIter
                    }   //end if
                    
                    else {
                        fIter[u][v] = iter
                    }   //end else
                    
                }    // end first for v
                
            }    // end first for u
            
            for u in 0...imageWidth - 1 {
                
                fIterBottom[u] = fIter[u][0]
                fIterTop[u] = fIter[u][imageHeight - 1]
                
            }    // end second for u
            
            fIterMinLeft = fIter[0].min()!
            fIterMinRight = fIter[imageWidth - 1].min()!
            fIterMinBottom = fIterBottom.min()!
            fIterMinTop = fIterTop.min()!
            fIterMins = [fIterMinLeft, fIterMinRight, fIterMinBottom, fIterMinTop]
            fIterMin = fIterMins.min()!
            
            fIterMin = fIterMin - dIterMin
            
                // Now we need to generate a bitmap image.
            
            var nBlocks: Int = 0
            nBlocks = picdef.nBlocksStart
            var fNBlocks: Double = 0.0
            var nColors: Int = 0
            var color: Double = 0.0
            var block0: Int = 0
            var block1: Int = 0
            
            var bE: Double = 0.0
            var eE: Double = 0.0
            var dE: Double = 0.0
            
            bE = picdef.bEStart
            eE = picdef.eEStart
            
            nColors = picdef.nColorsStart
            nBlocks = 60
            bE = 5.0
            eE = 15.0
            
            nBlocks = picdef.nBlocksStart
            bE = picdef.bEStart
            eE = picdef.eEStart
            
            fNBlocks = Double(nBlocks)
            
            dE = (iMax - fIterMin - fNBlocks*bE)/pow(fNBlocks, eE)
            
            var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)
 
//            let colors: [[Double]] =   [[r1, g1, b1],     [r2, g2, b2],     [r3, g3, b3],
//                                        [r4, g4, b4],     [r5, g5, b5],     [r6, g6, b6],
//                                        [r7, g7, b7],     [r8, g8, b8],     [r9, g9, b9],
//                                        [r10, g10, b10],  [r11, g11, b11],  [r12, g12, b12],
//                                        [r13, g13, b13],  [r14, g14, b14],  [r15, g15, b15],
//                                        [r16, g16, b16],  [r17, g17, b17],  [r18, g18, b18],
//                                        [r19, g19, b19],  [r20, g20, b20]]
//
            
        let colors: [[Double]] = [
                [picdef.hues[0].rStart, picdef.hues[0].gStart, picdef.hues[0].bStart],
                [picdef.hues[1].rStart, picdef.hues[1].gStart, picdef.hues[1].bStart],
                [picdef.hues[2].rStart, picdef.hues[2].gStart, picdef.hues[2].bStart],
                [picdef.hues[3].rStart, picdef.hues[3].gStart, picdef.hues[3].bStart],
                [picdef.hues[4].rStart, picdef.hues[4].gStart, picdef.hues[4].bStart],
                [picdef.hues[5].rStart, picdef.hues[5].gStart, picdef.hues[5].bStart],
                [picdef.hues[6].rStart, picdef.hues[6].gStart, picdef.hues[6].bStart],
                [picdef.hues[7].rStart, picdef.hues[7].gStart, picdef.hues[7].bStart],
                [picdef.hues[8].rStart, picdef.hues[8].gStart, picdef.hues[8].bStart],
                [picdef.hues[9].rStart, picdef.hues[9].gStart, picdef.hues[9].bStart],
                [picdef.hues[10].rStart, picdef.hues[10].gStart, picdef.hues[10].bStart],
                [picdef.hues[11].rStart, picdef.hues[11].gStart, picdef.hues[11].bStart],
                [picdef.hues[12].rStart, picdef.hues[12].gStart, picdef.hues[12].bStart],
                [picdef.hues[13].rStart, picdef.hues[13].gStart, picdef.hues[13].bStart],
                [picdef.hues[14].rStart, picdef.hues[14].gStart, picdef.hues[14].bStart],
                [picdef.hues[15].rStart, picdef.hues[15].gStart, picdef.hues[15].bStart],
                [picdef.hues[16].rStart, picdef.hues[16].gStart, picdef.hues[16].bStart],
                [picdef.hues[17].rStart, picdef.hues[17].gStart, picdef.hues[17].bStart],
                [picdef.hues[18].rStart, picdef.hues[18].gStart, picdef.hues[18].bStart],
                [picdef.hues[19].rStart, picdef.hues[19].gStart, picdef.hues[19].bStart],
               ]
            
            var h: Double = 0.0
            var xX: Double = 0.0
            
            for i in 0...nBlocks {
                blockBound[i] = bE*Double(i) + dE*pow(Double(i), eE)
            }
            
                // set up CG parameters
            let bitsPerComponent: Int = 8   // for UInt8
            let componentsPerPixel: Int = 4  // RGBA = 4 components
            let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
            let bytesPerRow: Int = imageWidth * bytesPerPixel
            let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel
            
                // Allocate data for the raster buffer.  I'm using UInt8 so that I can
                // address individual RGBA components easily.
            let rasterBufferPtr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)
            
                // Create a CGBitmapContext for drawing and converting into an image for display
            let context: CGContext = CGContext(data: rasterBufferPtr,
                                               width: imageWidth,
                                               height: imageHeight,
                                               bitsPerComponent: bitsPerComponent,
                                               bytesPerRow: bytesPerRow,
                                               space: CGColorSpace(name:CGColorSpace.sRGB)!,
                                               bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            
                // use CG to draw into the context
                // you can use any of the CG drawing routines for drawing into this context
                // here we will just erase the contents of the CGBitmapContext as the
                // raster buffer just contains random uninitialized data at this point.
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)   // white
            context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
            context.fillPath()
            
                // in addition to using any of the CG drawing routines, you can draw yourself
                // by accessing individual pixels in the raster image.
                // here we'll draw a square one pixel at a time.
            let xStarting: Int = 0
            let yStarting: Int = 0
            let width: Int = imageWidth
            let height: Int = imageHeight
            
                // iterate over all of the rows for the entire height of the square
            for v in 0...(height - 1) {
                
                    // calculate the offset to the row of pixels in the raster buffer
                    // assume the origin is at the bottom left corner of the raster image.
                    // note, you could also use the top left, but GC uses the bottom left
                    // so this method keeps your drawing and CG in sync in case you wanted
                    // to use the CG methods for drawing too.
                    //
                    // note, you could do this calculation all together inside of the xoffset
                    // loop, but it's a small optimization to pull this part out and do it here
                    // instead of every time through.
                let pixel_vertical_offset: Int = rasterBufferSize - (bytesPerRow*(Int(yStarting)+v+1))
                
                    // iterate over all of the pixels in this row
                for u in 0...(width - 1) {
                    
                        // calculate the horizontal offset to the pixel in the row
                    let pixel_horizontal_offset: Int = ((Int(xStarting) + u) * bytesPerPixel)
                    
                        // sum the horixontal and vertical offsets to get the pixel offset
                    let pixel_offset = pixel_vertical_offset + pixel_horizontal_offset
                    
                        // calculate the offset of the pixel
                    let pixelAddress:UnsafeMutablePointer<UInt8> = rasterBufferPtr + pixel_offset
                    
                    if fIter[u][v] >= iMax  {               //black
                        pixelAddress.pointee = UInt8(0)         //red
                        (pixelAddress + 1).pointee = UInt8(0)   //green
                        (pixelAddress + 2).pointee = UInt8(0)   //blue
                        (pixelAddress + 3).pointee = UInt8(255) //alpha
                        
                    }   // end if
                    
                    else    {
                        h = fIter[u][v] - fIterMin
                        
                        for block in 0...nBlocks {
                            
                            block0 = block
                            
                            if h >= blockBound[block] && h < blockBound[block + 1]   {
                                
                                xX = (h - blockBound[block])/(blockBound[block + 1] - blockBound[block])
                                
                                while block0 > nColors - 1 {
                                    block0 = block0 - nColors
                                }
                                
                                block1 = block0 + 1
                                
                                if block1 == nColors {
                                    block1 = block1 - nColors
                                }
                                
                                color = colors[block0][0] + xX*(colors[block1][0] - colors[block0][0])
                                pixelAddress.pointee = UInt8(color)         // R

                                color = colors[block0][1] + xX*(colors[block1][1] - colors[block0][1])
                                (pixelAddress + 1).pointee = UInt8(color)   // G

                                color = colors[block0][2] + xX*(colors[block1][2] - colors[block0][2])
                                (pixelAddress + 2).pointee = UInt8(color)   // B

                                (pixelAddress + 3).pointee = UInt8(255)     //alpha
                                
                            }
                            
                        }
                        
                            // IMPORTANT:
                            // there is no type checking here and it is up to you to make sure that the
                            // address indexes do not go beyond the memory allocated for the buffer
                    }    //end else
                    
                }    //end for u
                
            }    //end for v
            
                // convert the context into an image - this is what the function will return
            contextImage = context.makeImage()!
            
                // no automatic deallocation for the raster data
                // you need to manage that yourself
            rasterBufferPtr.deallocate()
            
                // SAVEFILE ******************************
            
                // STASH bitmap
                // before returning it, set the global variable
                // in case they want to save
            contextImageGlobal = contextImage
            
                // STASH all the other info needed to recreate it
            
                // SAVEFILE ******************************
            
            return contextImage
        }   // end if == true
        
        
        
        else if drawGradient == true { // draws gradient image
            print("Drawing gradient")
            
            var gradientImage: CGImage
            
            var imageWidth: Int = 0
            var imageHeight: Int = 0
            
            imageWidth = picdef.imageWidthStart
            imageHeight = picdef.imageHeightStart
            
                // Now we need to generate a bitmap image.
            
            var nColors: Int = 0
            var leftNumber: Int = 0
            var rightNumber: Int = 0
            var color: Double = 0.0
             
            nColors = picdef.nColorsStart
            leftNumber = picdef.leftNumberStart
            print("Drawing gradient, left color number is ", leftNumber)
           
            let colors: [[Double]] = [
                [picdef.hues[0].rStart, picdef.hues[0].gStart, picdef.hues[0].bStart],
                [picdef.hues[1].rStart, picdef.hues[1].gStart, picdef.hues[1].bStart],
                [picdef.hues[2].rStart, picdef.hues[2].gStart, picdef.hues[2].bStart],
                [picdef.hues[3].rStart, picdef.hues[3].gStart, picdef.hues[3].bStart],
                [picdef.hues[4].rStart, picdef.hues[4].gStart, picdef.hues[4].bStart],
                [picdef.hues[5].rStart, picdef.hues[5].gStart, picdef.hues[5].bStart],
                [picdef.hues[6].rStart, picdef.hues[6].gStart, picdef.hues[6].bStart],
                [picdef.hues[7].rStart, picdef.hues[7].gStart, picdef.hues[7].bStart],
                [picdef.hues[8].rStart, picdef.hues[8].gStart, picdef.hues[8].bStart],
                [picdef.hues[9].rStart, picdef.hues[9].gStart, picdef.hues[9].bStart],
                [picdef.hues[10].rStart, picdef.hues[10].gStart, picdef.hues[10].bStart],
                [picdef.hues[11].rStart, picdef.hues[11].gStart, picdef.hues[11].bStart],
                [picdef.hues[12].rStart, picdef.hues[12].gStart, picdef.hues[12].bStart],
                [picdef.hues[13].rStart, picdef.hues[13].gStart, picdef.hues[13].bStart],
                [picdef.hues[14].rStart, picdef.hues[14].gStart, picdef.hues[14].bStart],
                [picdef.hues[15].rStart, picdef.hues[15].gStart, picdef.hues[15].bStart],
                [picdef.hues[16].rStart, picdef.hues[16].gStart, picdef.hues[16].bStart],
                [picdef.hues[17].rStart, picdef.hues[17].gStart, picdef.hues[17].bStart],
                [picdef.hues[18].rStart, picdef.hues[18].gStart, picdef.hues[18].bStart],
                [picdef.hues[19].rStart, picdef.hues[19].gStart, picdef.hues[19].bStart],
            ]
            var xGradient: Double = 0.0
            
                // set up CG parameters
            let bitsPerComponent: Int = 8   // for UInt8
            let componentsPerPixel: Int = 4  // RGBA = 4 components
            let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
            let bytesPerRow: Int = imageWidth * bytesPerPixel
            let rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel
            
                // Allocate data for the raster buffer.  I'm using UInt8 so that I can
                // address individual RGBA components easily.
            let rasterBufferPtr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)
            
                // Create a CGBitmapContext for drawing and converting into an image for display
            let context: CGContext = CGContext(data: rasterBufferPtr,
                                               width: imageWidth,
                                               height: imageHeight,
                                               bitsPerComponent: bitsPerComponent,
                                               bytesPerRow: bytesPerRow,
                                               space: CGColorSpace(name:CGColorSpace.sRGB)!,
                                               bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            
                // use CG to draw into the context
                // you can use any of the CG drawing routines for drawing into this context
                // here we will just erase the contents of the CGBitmapContext as the
                // raster buffer just contains random uninitialized data at this point.
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)   // white
            context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(imageWidth), height: Double(imageHeight)))
            context.fillPath()
            
                // in addition to using any of the CG drawing routines, you can draw yourself
                // by accessing individual pixels in the raster image.
                // here we'll draw a square one pixel at a time.
            let xStarting: Int = 0
            let yStarting: Int = 0
            let width: Int = imageWidth
            let height: Int = imageHeight
            
                // iterate over all of the rows for the entire height of the square
            for v in 0...(height - 1) {
                
                    // calculate the offset to the row of pixels in the raster buffer
                    // assume the origin is at the bottom left corner of the raster image.
                    // note, you could also use the top left, but GC uses the bottom left
                    // so this method keeps your drawing and CG in sync in case you wanted
                    // to use the CG methods for drawing too.
                    //
                    // note, you could do this calculation all together inside of the xoffset
                    // loop, but it's a small optimization to pull this part out and do it here
                    // instead of every time through.
                let pixel_vertical_offset: Int = rasterBufferSize - (bytesPerRow*(Int(yStarting)+v+1))
                
                    // iterate over all of the pixels in this row
                for u in 0...(width - 1) {
                    
                        // calculate the horizontal offset to the pixel in the row
                    let pixel_horizontal_offset: Int = ((Int(xStarting) + u) * bytesPerPixel)
                    
                        // sum the horixontal and vertical offsets to get the pixel offset
                    let pixel_offset = pixel_vertical_offset + pixel_horizontal_offset
                    
                        // calculate the offset of the pixel
                    let pixelAddress:UnsafeMutablePointer<UInt8> = rasterBufferPtr + pixel_offset
                    
                    rightNumber = leftNumber + 1
                    
                    if leftNumber >= nColors {
                        rightNumber = 1
                    }
                    
                    xGradient = Double(u)/Double(width)
                    
                    color = colors[leftNumber-1][0] + xGradient*(colors[rightNumber - 1][0] - colors[leftNumber-1][0])
                    pixelAddress.pointee = UInt8(color)         // R
                    
                    color = colors[leftNumber-1][1] + xGradient*(colors[rightNumber - 1][1] - colors[leftNumber-1][1])
                    (pixelAddress + 1).pointee = UInt8(color)   // G
                    
                    color = colors[leftNumber-1][2] + xGradient*(colors[rightNumber - 1][2] - colors[leftNumber-1][2])
                    (pixelAddress + 2).pointee = UInt8(color)   // B
                    
                    (pixelAddress + 3).pointee = UInt8(255)     //alpha
                    
                    
                        // IMPORTANT:
                        // there is no type checking here and it is up to you to make sure that the
                        // address indexes do not go beyond the memory allocated for the buffer
                    
                }    //end for u
                
            }    //end for v
            
                // convert the context into an image - this is what the function will return
            gradientImage = context.makeImage()!
            
                // no automatic deallocation for the raster data
                // you need to manage that yourself
            rasterBufferPtr.deallocate()
            
            return gradientImage
        }   // end else for gradient image
        
        return nil
    }   //  end func
    
    static var cgFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.maximum = 4.0
        formatter.minimum = -4.0
        return formatter
    }
    
    static var cgUnboundFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        return formatter
    }
    
    static var intFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }
    
    func ratio() -> Double{
        let h : Double = Double(picdef.imageHeightStart)
        let w : Double = Double(picdef.imageWidthStart)
        let ratio: Double = max (h/w, w/h)
       return ratio
    }
        
    var body: some View {
        
        let image: CGImage = getImage(drawIt:drawItStart, drawGradient: drawGradientStart, leftNumber: picdef.leftNumberStart)!
        let img = Image(image, scale: 1.0, label: Text("Test"))
        
        HStack{ // this container shows instructions on left / dwg on right
            
            ScrollView(showsIndicators: true) {
                VStack( // the left side is a vertical container with user stuff
                    alignment: .center, spacing: 10) // spacing is between VStacks
                {
                
                Group{
                    
                    HStack {
                        
                        VStack { // use a button to zoom in
                            Button(action: {
                                zoomIn()
                            }) {
                                Text("Zoom In")
                            }
                        }
                        .padding(10)
                        
                        VStack { // use a button to zoom out
                            Button(action: {
                                zoomOut()
                            }) {
                                Text("Zoom Out")
                            }
                        }
                        
                    }
                    
                    
                    VStack {
                        Button("Save as PNG",
                               action: {
                            
                            // read and update the global variable
                            let imageCount = readOutCount()
                            
                            // then save the image (& data)
                            let success = saveImage(i:imageCount)
                            print("successful picture save =",success)
                        }
                        )
                    }
                    HStack {
                        
                        VStack { // use a button to pause to change values
                            Button(action: {
                                drawItStart = false
                                drawGradientStart = false
                                print("Paused. draw, drawGradient=",drawItStart,drawGradientStart)
                            }) {
                                Text("Pause to change values")
                            }
                        }
                        .padding(10)
                        
                        VStack { // use a button to resume
                            Button(action: {
                                drawItStart = true
                                drawGradientStart = false
                                print("Resumed. draw, drawGradient=",drawItStart,drawGradientStart)

                            }) {
                                Text("Resume")
                            }
                        }
                        
                        
                        
                    } // end HStack
                    
                    HStack {
                        
                        VStack { // use a button made a gradient
                            Button(action: {
                                drawItStart = false
                                drawGradientStart = true
                                print("Making gradient. draw, drawGradient=",drawItStart,drawGradientStart)

                            }) {
                                Text("Make a gradient")
                            }
                        }
                        .padding(10)
                        
                        VStack { // use a button to resume
                            Button(action: {
                                drawItStart = true
                                drawGradientStart = false
                                print("Resumed. draw, drawGradient=",drawItStart,drawGradientStart)

                            }) {
                                Text("Resume")
                            }
                        }
                        
                    } // end HStack
                    Group {
                        HStack {
                            
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("Enter center X")
                                Text("Between -2 and 2")
                                TextField("X",value: $picdef.xCStart, formatter: ContentView.cgFormatter)
                                    .padding(2)
                            }
                            
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("Enter center Y")
                                Text("Between -2 and 2")
                                TextField("Y",value: $picdef.yCStart, formatter: ContentView.cgFormatter)
                                    .padding(2)
                            }
                        }
                    }
                    
                    Group {
                        HStack {
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("scale:")
                                TextField("Scale",value: $picdef.scaleStart, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("iMax:")
                                TextField("iMax",value: $picdef.iMaxStart, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("rSqLimit:")
                                TextField("rSqLimit",value: $picdef.rSqLimitStart, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }
                    }
                    
                  
                    
                } // end of group
                
                Group {
                    HStack {
                        VStack {
                            Text("Image width, px:")
                            TextField("imageWidth",value: $picdef.imageWidthStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                        VStack {
                            Text("Image height, px:")
                            TextField("imageHeightStart",value: $picdef.imageHeightStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                        VStack {
                            Text("Aspect ratio:")
                            Text("\(self.ratio())")
                                .padding(3)
                        }
                    }
                }
                
                Group{
                    HStack{
                        
                        VStack {
                            Text("bE:")
                            TextField("bE",value: $picdef.bEStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                        VStack {
                            Text("eE:")
                            TextField("eE",value: $picdef.eEStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                    }
                }
                Group {
                    HStack{
                        VStack {
                            Text("theta:")
                            TextField("theta",value: $picdef.thetaStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                        VStack {
                            Text("nImage:")
                            TextField("nImage",value: $picdef.nImageStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                    }
                }
                Group {
                    HStack {
                        
                        VStack {
                            Text("dFIterMin:")
                            TextField("dFIterMin",value: $picdef.dFIterMinStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                        VStack {
                            Text("nBlocks:")
                            TextField("nBlocks",value: $picdef.nBlocksStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                    }
                }
                Group {
                    HStack {
                        VStack{
                            Text("Number of colors")
                            TextField("nColors",value: $picdef.nColorsStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                        VStack{
                            Text("Left gradient color number")
                            TextField("leftNumber",value: $picdef.leftNumberStart, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                    }
                }   // end of group
                Group{
                    ForEach($picdef.hues, id: \.numberStart) { hue in
                        HStack{
                            VStack{
                                Text("No:")
                                TextField("number",value: hue.numberStart, formatter: ContentView.cgUnboundFormatter)
                                    .disabled(true)
                                    .padding(2)
                            }
                            VStack{
                                Text("Enter R:")
                                TextField("r",value: hue.rStart, formatter: ContentView.cgUnboundFormatter)
                            }
                            VStack{
                                Text("Enter G:")
                                TextField("g",value: hue.gStart, formatter: ContentView.cgUnboundFormatter)
                            }
                            VStack{
                                Text("Enter B:")
                                TextField("b",value: hue.bStart, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }   // end HStack
                    } // end foreach
                } // end colors group
                Text("")
                } // end VStack for user instructions
                .background(instructionBackgroundColor)
                .frame(width:inputWidth)
                .padding(10)
            }
            GeometryReader {
                geometry in
                ZStack(alignment: .topLeading) {
                    Text("")
                    img
                        .gesture(self.tapGesture)
                        .alert(isPresented: $showingAlert) {
                                // fixed imageWidth & imageHeight
                            picdef.xCStart = getCenterXFromTapX(tapX:tapX,imageWidthStart:picdef.imageWidthStart)
                            picdef.yCStart = getCenterYFromTapY(tapY:tapY,imageHeightStart:picdef.imageHeightStart)
                            
                            return Alert(
                                title: Text("  "),
                                message: Text("  "),
                                dismissButton: .default(Text("  ")))
                        }
                }
            } // end GeoReader
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
                print("User clicked on picture x,y:",tap.startLocation)
                    // if we haven't moved very much, treat it as a tap event
                if self.moved < 10 && self.moved > -10 {
                    tapX = tap.startLocation.x
                    tapY = tap.startLocation.y
                    showingAlert = false
                        // we don't need it any more but hard to remove
                    self.tapLocations.append(tap.startLocation)
                        // the right place to update
                    picdef.xCStart = getCenterXFromTapX(tapX:tapX,imageWidthStart:picdef.imageWidthStart)
                    picdef.yCStart = getCenterYFromTapY(tapY:tapY,imageHeightStart:picdef.imageHeightStart)
                }
                    // reset tap event states
                self.moved = 0
                self.startTime = nil
            }
    } // end tapGesture
    
}
