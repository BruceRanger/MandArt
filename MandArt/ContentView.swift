//
//  ContentView.swift
//  MandArt
//
//  Created by Bruce Johnson on 9/20/21.
//  Edited by Bruce Johnson on 8/7/22.

/*    image = UIImage(named: "example.png") {
        if let data = image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
            try? data.write(to: filename)
        }   */
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }   

 /*   if let image = UIImage(named: "example.jpg") {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
            try? data.write(to: filename)
        }
    }   */

    import SwiftUI
    import Foundation   //for trig functions
//    import CoreImage

struct ContentView: View {
    
/*    struct Config: Codable, Hashable, Identifiable {
        let id: UUID
        let tag: String
        var xC: Double
        var yC: Double
        var scale: Double
  //      var imageWidth: Int
        var drawIt: Bool
    }*/
    
    let instructionBackgroundColor = Color.green.opacity(0.5)
    
    let inputWidth: Double = 290
    
    @State private var showingAlert = false
    @State private var tapX: Double = 0
    @State private var tapY: Double = 0
    
    @State private var tapLocations: [CGPoint] = []
    @State private var moved: Double = 0
    @State private var startTime: Date?
    
    @State private var dragCompleted = false
    @State private var dragOffset = CGSize.zero
    
    @State private var xCStart: Double = -0.74725
    @State private var yCStart: Double =  0.08442
    @State private var scaleStart: Double =  2_880_000.0
    @State private var iMaxStart: Double =  10_000.0
    @State private var rSqLimitStart: Double =  400.0
    @State private var nBlocksStart: Int =  60
    @State private var bEStart: Double =  5.0
    @State private var eEStart: Double =  15.0
    @State private var thetaStart: Double =  0.0
    @State private var imageWidthStart: Int = 1_200
    @State private var imageHeightStart: Int = 1_000
    @State private var nColorsStart: Int = 6
    @State private var leftNumberStart: Int = 1
    
    @State private var number1Start: Int =  1
    @State private var r1Start: Double =  0.0
    @State private var g1Start: Double =  255.0
    @State private var b1Start: Double =  0.0
    
    @State private var number2Start: Int =  2
    @State private var r2Start: Double =  255.0
    @State private var g2Start: Double =  255.0
    @State private var b2Start: Double =  0.0
    
    @State private var number3Start: Int =  3
    @State private var r3Start: Double =  255.0
    @State private var g3Start: Double =  0.0
    @State private var b3Start: Double =  0.0
    
    @State private var number4Start: Int =  4
    @State private var r4Start: Double =  255.0
    @State private var g4Start: Double =  0.0
    @State private var b4Start: Double =  255.0
    
    @State private var number5Start: Int =  5
    @State private var r5Start: Double =  0.0
    @State private var g5Start: Double =  0.0
    @State private var b5Start: Double =  255.0
    
    @State private var number6Start: Int =  6
    @State private var r6Start: Double =  0.0
    @State private var g6Start: Double =  255.0
    @State private var b6Start: Double =  255.0
    
    @State private var number7Start: Int =  7
    @State private var r7Start: Double =  0.0
    @State private var g7Start: Double =  0.0
    @State private var b7Start: Double =  0.0
    
    @State private var number8Start: Int =  8
    @State private var r8Start: Double =  0.0
    @State private var g8Start: Double =  0.0
    @State private var b8Start: Double =  0.0
    
    @State private var number9Start: Int =  9
    @State private var r9Start: Double =  0.0
    @State private var g9Start: Double =  0.0
    @State private var b9Start: Double =  0.0
    
    @State private var number10Start: Int =  10
    @State private var r10Start: Double =  0.0
    @State private var g10Start: Double =  0.0
    @State private var b10Start: Double =  0.0
    
    @State private var number11Start: Int =  11
    @State private var r11Start: Double =  0.0
    @State private var g11Start: Double =  0.0
    @State private var b11Start: Double =  0.0
    
    @State private var number12Start: Int =  12
    @State private var r12Start: Double =  0.0
    @State private var g12Start: Double =  0.0
    @State private var b12Start: Double =  0.0
    
    @State private var number13Start: Int =  13
    @State private var r13Start: Double =  0.0
    @State private var g13Start: Double =  0.0
    @State private var b13Start: Double =  0.0
    
    @State private var number14Start: Int =  14
    @State private var r14Start: Double =  0.0
    @State private var g14Start: Double =  0.0
    @State private var b14Start: Double =  0.0
    
    @State private var number15Start: Int =  15
    @State private var r15Start: Double =  0.0
    @State private var g15Start: Double =  0.0
    @State private var b15Start: Double =  0.0
    
    @State private var number16Start: Int =  16
    @State private var r16Start: Double =  0.0
    @State private var g16Start: Double =  0.0
    @State private var b16Start: Double =  0.0
    
    @State private var number17Start: Int =  17
    @State private var r17Start: Double =  0.0
    @State private var g17Start: Double =  0.0
    @State private var b17Start: Double =  0.0
    
    @State private var number18Start: Int =  18
    @State private var r18Start: Double =  0.0
    @State private var g18Start: Double =  0.0
    @State private var b18Start: Double =  0.0
    
    @State private var number19Start: Int =  19
    @State private var r19Start: Double =  0.0
    @State private var g19Start: Double =  0.0
    @State private var b19Start: Double =  0.0
    
    @State private var number20Start: Int =  20
    @State private var r20Start: Double =  0.0
    @State private var g20Start: Double =  0.0
    @State private var b20Start: Double =  0.0
    
    @State private var drawItStart = true
    @State private var drawItBlankStart = false
    @State private var drawGradientStart = false
    
    @State private var scaleOld: Double =  1.0
    
//    @State private var selectedConfig: Config?

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getCenterXFromTapX(tapX: Double, imageWidthStart:Int) -> Double {
        let tapXDifference = (tapX - Double(imageWidthStart)/2.0)/scaleStart
        let newXC: Double = xCStart + tapXDifference // needs work
        return newXC
    }
    
    func getCenterYFromTapY(tapY: Double, imageHeightStart:Int) -> Double {
        let tapYDifference = ((Double(imageHeightStart) - tapY) - Double(imageHeightStart)/2.0)/scaleStart
        let newYC: Double = (yCStart + tapYDifference) // needs work
        return newYC
    }
    
    func zoomOut(){
        self.scaleOld = self.scaleStart
        self.scaleStart = self.scaleOld / 2.0
    }
    
    func zoomIn(){
        self.scaleOld = self.scaleStart
        self.scaleStart = self.scaleOld * 2.0
    }

    func getImage(drawIt:Bool, drawItBlank: Bool, drawGradient: Bool, leftNumber: Int) -> CGImage { 
   
        if drawIt == true { // draws image
        
        var contextImage: CGImage
        
        var imageWidth: Int = 0
        var imageHeight: Int = 0
        var iMax: Double = 10_000.0
        var rSq: Double = 0.0
        var rSqLimit: Double = 0.0
        var rSqMax: Double = 0.0
        var x0: Double = 0.0
        var y0: Double = 0.0
        imageWidth = self.imageWidthStart
        imageHeight = self.imageHeightStart
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
        
        rSqLimit = 400.0
        scale = self.scaleStart
        xC = self.xCStart
        yC = self.yCStart
        iMax = self.iMaxStart
        rSqLimit = self.rSqLimitStart
        rSqMax = 1.01*(rSqLimit + 2)*(rSqLimit + 2)
        gGML = log( log(rSqMax) ) - log(log(rSqLimit) )
        gGL = log(log(rSqLimit) )
        
        for u in 0...imageWidth - 1 {
            
            for v in 0...imageHeight - 1 {
                
                x0 = xC + (Double(u) - Double(imageWidth/2))/scale
                y0 = yC + (Double(v) - Double(imageHeight/2))/scale
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
        
        // Now we need to generate a bitmap image.
        
        var nBlocks: Int = 0
        nBlocks = self.nBlocksStart
        var fNBlocks: Double = 0.0
        var nColors: Int = 0
        var color: Double = 0.0
        var block0: Int = 0
        var block1: Int = 0
        
        var bE: Double = 0.0
        var eE: Double = 0.0
        var dE: Double = 0.0
        var theta: Double = 0.0
        let pi: Double = 3.14159
        
        var r1: Double = 0.0
        var g1: Double = 0.0
        var b1: Double = 0.0
        var r2: Double = 0.0
        var g2: Double = 0.0
        var b2: Double = 0.0    
        var r3: Double = 0.0
        var g3: Double = 0.0
        var b3: Double = 0.0
        var r4: Double = 0.0
        var g4: Double = 0.0
        var b4: Double = 0.0
        var r5: Double = 0.0
        var g5: Double = 0.0
        var b5: Double = 0.0    
        var r6: Double = 0.0
        var g6: Double = 0.0
        var b6: Double = 0.0
        var r7: Double = 0.0
        var g7: Double = 0.0
        var b7: Double = 0.0
        var r8: Double = 0.0
        var g8: Double = 0.0
        var b8: Double = 0.0    
        var r9: Double = 0.0
        var g9: Double = 0.0
        var b9: Double = 0.0
        var r10: Double = 0.0
        var g10: Double = 0.0
        var b10: Double = 0.0
        var r11: Double = 0.0
        var g11: Double = 0.0
        var b11: Double = 0.0    
        var r12: Double = 0.0
        var g12: Double = 0.0
        var b12: Double = 0.0
        var r13: Double = 0.0
        var g13: Double = 0.0
        var b13: Double = 0.0
        var r14: Double = 0.0
        var g14: Double = 0.0
        var b14: Double = 0.0    
        var r15: Double = 0.0
        var g15: Double = 0.0
        var b15: Double = 0.0
        var r16: Double = 0.0
        var g16: Double = 0.0
        var b16: Double = 0.0
        var r17: Double = 0.0
        var g17: Double = 0.0
        var b17: Double = 0.0    
        var r18: Double = 0.0
        var g18: Double = 0.0
        var b18: Double = 0.0
        var r19: Double = 0.0
        var g19: Double = 0.0
        var b19: Double = 0.0
        var r20: Double = 0.0
        var g20: Double = 0.0
        var b20: Double = 0.0    
        
        bE = self.bEStart
        eE = self.eEStart
        theta = self.thetaStart
        
        nColors = self.nColorsStart
        r1 = self.r1Start
        g1 = self.g1Start
        b1 = self.b1Start
        r2 = self.r2Start
        g2 = self.g2Start
        b2 = self.b2Start
        r3 = self.r3Start
        g3 = self.g3Start
        b3 = self.b3Start
        r4 = self.r4Start
        g4 = self.g4Start
        b4 = self.b4Start
        r5 = self.r5Start
        g5 = self.g5Start
        b5 = self.b5Start
        r6 = self.r6Start
        g6 = self.g6Start
        b6 = self.b6Start
        r7 = self.r7Start
        g7 = self.g7Start
        b7 = self.b7Start
        r8 = self.r8Start
        g8 = self.g8Start
        b8 = self.b8Start
        r9 = self.r9Start
        g9 = self.g9Start
        b9 = self.b9Start
        r10 = self.r10Start
        g10 = self.g10Start
        b10 = self.b10Start
        r11 = self.r11Start
        g11 = self.g11Start
        b11 = self.b11Start
        r12 = self.r12Start
        g12 = self.g12Start
        b12 = self.b12Start
        r13 = self.r13Start
        g13 = self.g13Start
        b13 = self.b13Start
        r14 = self.r14Start
        g14 = self.g14Start
        b14 = self.b14Start
        r15 = self.r15Start
        g15 = self.g15Start
        b15 = self.b15Start
        r16 = self.r16Start
        g16 = self.g16Start
        b16 = self.b16Start
        r17 = self.r17Start
        g17 = self.g17Start
        b17 = self.b17Start
        r18 = self.r18Start
        g18 = self.g18Start
        b18 = self.b18Start
        r19 = self.r19Start
        g19 = self.g19Start
        b19 = self.b19Start
        r20 = self.r20Start
        g20 = self.g20Start
        b20 = self.b20Start
        
        nBlocks = 60
        bE = 5.0
        eE = 15.0
        
        nBlocks = self.nBlocksStart
        bE = self.bEStart
        eE = self.eEStart
        theta = self.thetaStart
        
        fNBlocks = Double(nBlocks)
        
        dE = (iMax - fIterMin - fNBlocks*bE)/pow(fNBlocks, eE)
        
        var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)
        
  //      var colors: [[Double]] = [[0.0, 255.0, 0.0], [255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0], [0.0, 255.0, 255.0]]
  
        let colors: [[Double]] =   [[r1, g1, b1],     [r2, g2, b2],     [r3, g3, b3],
                                    [r4, g4, b4],     [r5, g5, b5],     [r6, g6, b6],
                                    [r7, g7, b7],     [r8, g8, b8],     [r9, g9, b9],
                                    [r10, g10, b10],  [r11, g11, b11],  [r12, g12, b12],
                                    [r13, g13, b13],  [r14, g14, b14],  [r15, g15, b15],
                                    [r16, g16, b16],  [r17, g17, b17],  [r18, g18, b18],
                                    [r19, g19, b19],  [r20, g20, b20]]
          
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
        
/*        UIImage(CGImage: cgImage)
   
        class UIImage : NSObject
        
            let nsContextImage = NSImage(cgImage: contextImage, size: NSMakeSize(Double(width), Double(height)))
        let uiImage = UIImage(cgImage: cgimg)
        
        let image = UIImage(named: "example.jpg") {
        let data = nsContextImage.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent("mandImage.jpg")
            try? data.write(to: filename)
        }   
        }             */
        
  /*      let data = contextImage.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent("mandImage.jpg")
            try? data.write(to: filename)
        }   */
                
        return contextImage
    }   // end if == true

        else if drawItBlank == true { // draws blue image
        
        var contextImageBlank: CGImage
        
        var imageWidth: Int = 0
        var imageHeight: Int = 0
        imageWidth = self.imageWidthStart
        imageHeight = self.imageHeightStart
   
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
        context.addRect(CGRect(x: 0.0, y: 0.0, width: Double(100), height: Double(100)))
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
                
       //         light blue for contextImageBlank
                    pixelAddress.pointee = UInt8(135)         //red
                    (pixelAddress + 1).pointee = UInt8(206)   //green
                    (pixelAddress + 2).pointee = UInt8(255)   //blue
                    (pixelAddress + 3).pointee = UInt8(255) //alpha
                
                 
                    
                    
                    // IMPORTANT:
                    // there is no type checking here and it is up to you to make sure that the
                    // address indexes do not go beyond the memory allocated for the buffer
                
            }    //end for u
            
        }    //end for v
        
        // convert the context into an image - this is what the function will return
        contextImageBlank = context.makeImage()!
        
        // no automatic deallocation for the raster data
        // you need to manage that yourself
        rasterBufferPtr.deallocate()
        
        return contextImageBlank
    }   // end else if  
 
        else {  // draws gradient image
       
        var gradientImage: CGImage
        
        var imageWidth: Int = 0
        var imageHeight: Int = 0
        
        imageWidth = self.imageWidthStart
        imageHeight = self.imageHeightStart
        
        // Now we need to generate a bitmap image.
        
        var nColors: Int = 0
        var leftNumber: Int = 0
        var rightNumber: Int = 0
        var color: Double = 0.0
        
        var r1: Double = 0.0
        var g1: Double = 0.0
        var b1: Double = 0.0
        var r2: Double = 0.0
        var g2: Double = 0.0
        var b2: Double = 0.0    
        var r3: Double = 0.0
        var g3: Double = 0.0
        var b3: Double = 0.0
        var r4: Double = 0.0
        var g4: Double = 0.0
        var b4: Double = 0.0
        var r5: Double = 0.0
        var g5: Double = 0.0
        var b5: Double = 0.0    
        var r6: Double = 0.0
        var g6: Double = 0.0
        var b6: Double = 0.0
        var r7: Double = 0.0
        var g7: Double = 0.0
        var b7: Double = 0.0
        var r8: Double = 0.0
        var g8: Double = 0.0
        var b8: Double = 0.0    
        var r9: Double = 0.0
        var g9: Double = 0.0
        var b9: Double = 0.0
        var r10: Double = 0.0
        var g10: Double = 0.0
        var b10: Double = 0.0
        var r11: Double = 0.0
        var g11: Double = 0.0
        var b11: Double = 0.0    
        var r12: Double = 0.0
        var g12: Double = 0.0
        var b12: Double = 0.0
        var r13: Double = 0.0
        var g13: Double = 0.0
        var b13: Double = 0.0
        var r14: Double = 0.0
        var g14: Double = 0.0
        var b14: Double = 0.0    
        var r15: Double = 0.0
        var g15: Double = 0.0
        var b15: Double = 0.0
        var r16: Double = 0.0
        var g16: Double = 0.0
        var b16: Double = 0.0
        var r17: Double = 0.0
        var g17: Double = 0.0
        var b17: Double = 0.0    
        var r18: Double = 0.0
        var g18: Double = 0.0
        var b18: Double = 0.0
        var r19: Double = 0.0
        var g19: Double = 0.0
        var b19: Double = 0.0
        var r20: Double = 0.0
        var g20: Double = 0.0
        var b20: Double = 0.0    
        
        nColors = self.nColorsStart
        leftNumber = self.leftNumberStart
        r1 = self.r1Start
        g1 = self.g1Start
        b1 = self.b1Start
        r2 = self.r2Start
        g2 = self.g2Start
        b2 = self.b2Start
        r3 = self.r3Start
        g3 = self.g3Start
        b3 = self.b3Start
        r4 = self.r4Start
        g4 = self.g4Start
        b4 = self.b4Start
        r5 = self.r5Start
        g5 = self.g5Start
        b5 = self.b5Start
        r6 = self.r6Start
        g6 = self.g6Start
        b6 = self.b6Start
        r7 = self.r7Start
        g7 = self.g7Start
        b7 = self.b7Start
        r8 = self.r8Start
        g8 = self.g8Start
        b8 = self.b8Start
        r9 = self.r9Start
        g9 = self.g9Start
        b9 = self.b9Start
        r10 = self.r10Start
        g10 = self.g10Start
        b10 = self.b10Start
        r11 = self.r11Start
        g11 = self.g11Start
        b11 = self.b11Start
        r12 = self.r12Start
        g12 = self.g12Start
        b12 = self.b12Start
        r13 = self.r13Start
        g13 = self.g13Start
        b13 = self.b13Start
        r14 = self.r14Start
        g14 = self.g14Start
        b14 = self.b14Start
        r15 = self.r15Start
        g15 = self.g15Start
        b15 = self.b15Start
        r16 = self.r16Start
        g16 = self.g16Start
        b16 = self.b16Start
        r17 = self.r17Start
        g17 = self.g17Start
        b17 = self.b17Start
        r18 = self.r18Start
        g18 = self.g18Start
        b18 = self.b18Start
        r19 = self.r19Start
        g19 = self.g19Start
        b19 = self.b19Start
        r20 = self.r20Start
        g20 = self.g20Start
        b20 = self.b20Start
  
        let colors: [[Double]] =   [[r1, g1, b1],     [r2, g2, b2],     [r3, g3, b3],
                                    [r4, g4, b4],     [r5, g5, b5],     [r6, g6, b6],
                                    [r7, g7, b7],     [r8, g8, b8],     [r9, g9, b9],
                                    [r10, g10, b10],  [r11, g11, b11],  [r12, g12, b12],
                                    [r13, g13, b13],  [r14, g14, b14],  [r15, g15, b15],
                                    [r16, g16, b16],  [r17, g17, b17],  [r18, g18, b18],
                                    [r19, g19, b19],  [r20, g20, b20]]
                                    
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
    
    // ........................................................................
    
//    https://www.hackingwithswift.com/quick-start/swiftui/how-to-format-a-textfield-for-numbers
    
    var body: some View {

        let image: CGImage = getImage(drawIt:drawItStart, drawItBlank: drawItBlankStart, drawGradient: drawGradientStart, leftNumber: leftNumberStart)
        let img = Image(image, scale: 1.0, label: Text("Test"))
        
        HStack{ // this container shows instructions on left / dwg on right
        
            ScrollView(showsIndicators: true) {
            VStack( // the left side is a vertical container with user stuff
                alignment: .center, spacing: 10) // spacing is between VStacks
            {
                Group{
                    Text("")
                    Text("Click in green area to define values.")
                    Text("Double-click in green area to enter the values.")
                    Text("Press in green area for 3 seconds to make a gradient")
                    Text("Click in image to choose new center.\n")
                }   // end of group
                
                Group{
                
                VStack { // use a button to zoom in
                    Button(action: {
                        zoomIn()
                    }) {
                    Text("Zoom In")
                }
                }

                VStack { // use a button to zoom out
                    Button(action: {
                        zoomOut()
                    }) {
                    Text("Zoom Out")
                }
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter center X")
                    Text("Between -2 and 2")
                    TextField("X",value: $xCStart, formatter: ContentView.cgFormatter)
                        .padding(2)
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter center Y")
                    Text("Between -2 and 2")
                    TextField("Y",value: $yCStart, formatter: ContentView.cgFormatter)
                        .padding(2)
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter scale:")
                    TextField("Scale",value: $scaleStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter iMax:")
                    TextField("iMax",value: $iMaxStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                }   
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter rSqLimit:")
                    TextField("rSqLimit",value: $rSqLimitStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter imageWidth:")
                    TextField("imageWidth",value: $imageWidthStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter imageHeight:")
                    TextField("imageHeightStart",value: $imageHeightStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                } 
                
                } // end of group
                
                Group{
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter nBlocks:")
                    TextField("nBlocks",value: $nBlocksStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter bE:")
                    TextField("bE",value: $bEStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter eE:")
                    TextField("eE",value: $eEStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter theta:")
                    TextField("theta",value: $thetaStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter number of colors")
                    TextField("nColors",value: $nColorsStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter left gradient color number")
                    TextField("leftNumber",value: $leftNumberStart, formatter: ContentView.cgUnboundFormatter)
                        .padding(2)
                }
                
                }   // end of group
                
                Group{
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number1",value: $number1Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R1:")
                    TextField("r1",value: $r1Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G1:")
                    TextField("g1",value: $g1Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B1:")
                    TextField("b1",value: $b1Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number2",value: $number2Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R2:")
                    TextField("r2",value: $r2Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G2:")
                    TextField("g2",value: $g2Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B2:")
                    TextField("b2",value: $b2Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number3",value: $number3Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R3:")
                    TextField("r3",value: $r3Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G3:")
                    TextField("g3",value: $g3Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B3:")
                    TextField("b3",value: $b3Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number4",value: $number4Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R4:")
                    TextField("r4",value: $r4Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G4:")
                    TextField("g4",value: $g4Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B4:")
                    TextField("b4",value: $b4Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number5",value: $number5Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R5:")
                    TextField("r5",value: $r5Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G5:")
                    TextField("g5",value: $g5Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B5:")
                    TextField("b5",value: $b5Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number6",value: $number6Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R6:")
                    TextField("r6",value: $r6Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G6:")
                    TextField("g6",value: $g6Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B6:")
                    TextField("b6",value: $b6Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number7",value: $number7Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R7:")
                    TextField("r7",value: $r7Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G7:")
                    TextField("g7",value: $g7Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B7:")
                    TextField("b7",value: $b7Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number8",value: $number8Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R8:")
                    TextField("r8",value: $r8Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G8:")
                    TextField("g8",value: $g8Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B8:")
                    TextField("b8",value: $b8Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
                
                } // end of group
                
                Group{
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number9",value: $number9Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R9:")
                    TextField("r9",value: $r9Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G9:")
                    TextField("g9",value: $g9Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B9:")
                    TextField("b9",value: $b9Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number10",value: $number10Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R10:")
                    TextField("r10",value: $r10Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G10:")
                    TextField("g10",value: $g10Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B10:")
                    TextField("b10",value: $b10Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number11",value: $number11Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R11:")
                    TextField("r11",value: $r11Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G11:")
                    TextField("g11",value: $g11Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B11:")
                    TextField("b11",value: $b11Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number12",value: $number12Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R12:")
                    TextField("r12",value: $r12Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G12:")
                    TextField("g12",value: $g12Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B12:")
                    TextField("b12",value: $b12Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number13",value: $number13Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R13:")
                    TextField("r13",value: $r13Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G13:")
                    TextField("g13",value: $g13Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B13:")
                    TextField("b13",value: $b13Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number14",value: $number14Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R14:")
                    TextField("r14",value: $r14Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G14:")
                    TextField("g14",value: $g14Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B14:")
                    TextField("b14",value: $b14Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number15",value: $number15Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R15:")
                    TextField("r15",value: $r15Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G15:")
                    TextField("g15",value: $g15Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B15:")
                    TextField("b15",value: $b15Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number16",value: $number16Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R16:")
                    TextField("r16",value: $r16Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G16:")
                    TextField("g16",value: $g16Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B16:")
                    TextField("b16",value: $b16Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
                
                } // end of group
                
                Group{
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number17",value: $number17Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R17:")
                    TextField("r17",value: $r17Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G17:")
                    TextField("g17",value: $g17Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B17:")
                    TextField("b17",value: $b17Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number18",value: $number18Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R18:")
                    TextField("r18",value: $r18Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G18:")
                    TextField("g18",value: $g18Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B18:")
                    TextField("b18",value: $b18Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
            
                HStack{
                
                VStack{
                    Text("No:")
                    TextField("number19",value: $number19Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R19:")
                    TextField("r19",value: $r19Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G19:")
                    TextField("g19",value: $g19Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B19:")
                    TextField("b19",value: $b19Start, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
                }
                }   // end HStack
                
                HStack {
                
                VStack{
                    Text("No:")
                    TextField("number20",value: $number20Start, formatter: ContentView.cgUnboundFormatter)
                        .disabled(true)
                        .padding(2)
                }
                
                VStack{
                    Text("Enter R20:")
                    TextField("r20",value: $r20Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G20:")
                    TextField("g20",value: $g20Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B20:")
                    TextField("b20",value: $b20Start, formatter: ContentView.cgUnboundFormatter)
                }
                }
                
                Text("")
                
                } // end of group   */
                

                
      /*          // Then, there is a Picker to list the pre-selected scenes
                Picker(
                    selection:$selectedConfig,
                    label: Text ("Optional: Choose scene"))
                {
                    Text("No scene selected").tag(nil as Config?)
                    ForEach(self.configs, id: \.id) { item in
                        Text(item.tag).tag(item as Config?)
                    }
                    
                }   */
                
                
            } // end VStack for user instructions
            
            .contentShape(Rectangle())
            
            .onTapGesture(count:2){
                drawItStart = true
                drawItBlankStart = false
            }   
            
            .contentShape(Rectangle())
            .onTapGesture(count:1){
                drawItStart = false
                drawItBlankStart = true
            }
            
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: 1){
                drawItStart = false
                drawItBlankStart = false
                drawGradientStart = true
            } 
            
            .background(instructionBackgroundColor)
            .frame(width:inputWidth)
            .padding(10)
        }
            
            GeometryReader {
                geometry in
                ZStack(alignment: .topLeading) {
                    Text("Scene")
                    img
                        .gesture(self.tapGesture)
                        .alert(isPresented: $showingAlert) {
                            // fixed imageWidth & imageHeight
                            xCStart = getCenterXFromTapX(tapX:tapX,imageWidthStart:imageWidthStart)
                            yCStart = getCenterYFromTapY(tapY:tapY,imageHeightStart:imageHeightStart)
                                
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
                // if we haven't moved very much, treat it as a tap event
                if self.moved < 10 && self.moved > -10 {
                    tapX = tap.startLocation.x
                    tapY = tap.startLocation.y
                    showingAlert = false // we don't need it any more but hard to remove
                    self.tapLocations.append(tap.startLocation)
                    // the right place to update
                    xCStart = getCenterXFromTapX(tapX:tapX,imageWidthStart:imageWidthStart)
                    yCStart = getCenterYFromTapY(tapY:tapY,imageHeightStart:imageHeightStart)
                }
                
                // reset tap event states
                self.moved = 0
                self.startTime = nil
            }
    } // end tapGesture
    
    
 /*   var configs = [
        Config( id: UUID(), tag: "Overview",
                xC : 0.0,
                yC : 0.0,
                scale :160.0, drawIt: true
              ),
        Config( id: UUID(), tag: "M15 = N1",
                xC : -0.7649211,
                yC : 0.1018886,
                scale :2_839_040.0, drawIt: true
              ),
        Config( id: UUID(), tag: "M1",
                xC : -0.2985836511290,     // M1
                yC : 0.6580148156626,
                scale : 1.9e12, drawIt: true
              ),
        Config(id: UUID(), tag: "M2",
               xC : -0.5489774042572,     // M2
               yC : 0.6513448574304,
               scale : 6_008_327_554_320.0, drawIt: true
              ),
        Config(id: UUID(), tag: "M3",
               xC : -0.1913046694  ,   // M3
               yC : 0.6502983463,
               scale : 1.9e9, drawIt: true
              ),
        Config(id: UUID(), tag: "M4",
               xC : -0.1690435583 ,   // M4
               yC : 0.6505206291,
               scale : 1.8e9, drawIt: true
              ),
        Config(id: UUID(), tag: "M5",
               xC : -0.183111455812451001,    // M5
               yC : 0.651073847461314001,
               scale : 1.0e13, drawIt: true
              ),
        Config(id: UUID(), tag: "N2",
               xC : 0.345679 ,   // N2
               yC : 0.38838,
               scale : 320_000.0, drawIt: true
              ),
        Config(id: UUID(), tag: "N3",
               xC : -1.250385042 ,  // N3
               yC : 0.007717842,
               scale : 48.0e6, drawIt: true
              ),
        Config(id: UUID(), tag: "N4",
               xC :-0.74344 ,  // N4
               yC : 0.12493,
               scale : 576_000.0, drawIt: true
              ),
        Config(id: UUID(), tag: "N6",
               xC : -0.74725 ,  // N6
               yC : 0.08442,
               scale :  2_880_000.0, drawIt: true
              ),
        Config(id: UUID(), tag: "N8",
               xC : -1.250377295  , // N8
               yC : 0.007719842,
               scale : 928.0e6, drawIt: true
              ),
        Config(id: UUID(), tag: "N9",
               xC : -0.111925 , // N9
               yC : 0.6502587,
               scale : 38.4e6, drawIt: true
              ),
        Config(id: UUID(),  tag: "N10",
               xC : -0.111715 , // N10
               yC : 0.6495112,
               scale : 2.0e7, drawIt: true
              ),
        Config( id: UUID(), tag: "N11",
                xC : -0.148238 , // N11
                yC : 0.651878,
                scale : 26_656_000.0, drawIt: true
              ) 
    ]*/
    
} // end view structbutton


//  var colors: [[Double]] = [[255.0, 128.0, 0.0], [255.0, 255.0, 0.0], [0.0, 255.0, 0.0], [0.0, 128.0, 255.0], [255.0, 0.0, 255.0], [255.0, 0.0, 128.0]]

//  var colors: [[Double]] = [[255.0, 128.0, 0.0], [255.0, 255.0, 0.0], [0.0, 255.0, 0.0], [0.0, 128.0, 255.0], [255.0, 0.0, 255.0], [255.0, 0.0, 128.0]]

//var colors: [[Double]] = [[255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0],[0.0, 255.0, 255.0], [0.0, 255.0, 0.0], [255.0, 255.0, 0.0]]

//var colors: [[Double]] = [[255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, //0.0, 255.0], [0.0, 255.0, 255.0], [0.0, 255.0, 0.0]]

//var colors: [[Double]] = [[0.0, 255.0, 0.0], [255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0], [0.0, 255.0, 255.0]]

//var colors: [[Double]] = [[255.0, 127.0, 0.0], [255.0, 0.0, 127.0], [127.0, 0.0, 255.0],[0.0, 127.0, 255.0], [0.0, 255.0, 127.0], [127.0, 255.0, 0.0]]

//var colors: [[Double]] = [[0.0, 255.0, 0.0], [255.0, 0.0, 0.0], [0.0, 0.0, 255.0]]

//var colors: [[Double]] = [[255.0, 0.0, 255.0], [30,144,255], [61.0, 145.0, 64.0], [255.0, 255.0, 0.0], [255.0, 165.0, 0.0], [255.0, 0.0, 0.0]]



