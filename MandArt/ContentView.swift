//
//  ContentView.swift
//  MandArt
//
//  Created by Bruce Johnson on 9/20/21.
//  Edited by Bruce Johnson on 8/7/22.

import SwiftUI

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
    
    let instructionBackgroundColor = Color.green
    let inputWidth: Double = 250
    
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
    @State private var imageWidthStart: Int = 1_200
    @State private var imageHeightStart: Int = 1_000
    @State private var nColorsStart: Int = 2
    
    @State private var rR1Start: Double =  255.0
    @State private var gG1Start: Double =  255.0
    @State private var bB1Start: Double =  0.0
    
    @State private var rR2Start: Double =  255.0
    @State private var gG2Start: Double =  0.0
    @State private var bB2Start: Double =  0.0
    
    @State private var rR3Start: Double =  0.0
    @State private var gG3Start: Double =  0.0
    @State private var bB3Start: Double =  0.0
    
    @State private var drawItStart = true
    @State private var drawItPlainStart = true
    
    @State private var scaleOld: Double =  1.0
    
//    @State private var selectedConfig: Config?
    
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

    func getContextImage(drawIt:Bool) -> CGImage { 
   
        if drawIt == true {
        
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
        imageWidth = self.imageWidthStart
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
   //     var colorGradient: Double = 0.0
        var b0: Int = 0
        var b1: Int = 0
        
        var bE: Double = 0.0
        var eE: Double = 0.0
        var dE: Double = 0.0
        
        var rR1: Double = 0.0
        var gG1: Double = 0.0
        var bB1: Double = 0.0
        var rR2: Double = 0.0
        var gG2: Double = 0.0
        var bB2: Double = 0.0    
        var rR3: Double = 0.0
        var gG3: Double = 0.0
        var bB3: Double = 0.0    
        
        bE = self.bEStart
        eE = self.eEStart
        
        nColors = self.nColorsStart
        rR1 = self.rR1Start
        gG1 = self.gG1Start
        bB1 = self.bB1Start
        rR2 = self.rR2Start
        gG2 = self.gG2Start
        bB2 = self.bB2Start
        rR3 = self.rR3Start
        gG3 = self.gG3Start
        bB3 = self.bB3Start
        
        nBlocks = 60
        bE = 5.0
        eE = 15.0
        
        nBlocks = self.nBlocksStart
        bE = self.bEStart
        eE = self.eEStart
        
        fNBlocks = Double(nBlocks)
        
        dE = (iMax - fIterMin - fNBlocks*bE)/pow(fNBlocks, eE)
        
        var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)
        
  //      var colors: [[Double]] = [[0.0, 255.0, 0.0], [255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0], [0.0, 255.0, 255.0]]
  
        let colors: [[Double]] = [[rR1, gG1, bB1], [rR2, gG2, bB2], [rR3, gG3, bB3]]
        
        let colorsR: [Double] = [rR1, rR2, rR3]
    
   //     nColors = colorsR.filter{$0 < 300}.count
   //     nColors = 2
        print(nColors)
          
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
                    
                }   //end if
                
                else    {
                    h = fIter[u][v] - fIterMin
                    
                    for b in 0...nBlocks {
                        
                        b0 = b
                        
                        if h >= blockBound[b] && h < blockBound[b + 1]   {
                            
                            xX = (h - blockBound[b])/(blockBound[b + 1] - blockBound[b])
                            
                            while b0 > nColors - 1 {
                                b0 = b0 - nColors
                            }
                            
                            b1 = b0 + 1
                            
                            if b1 == nColors {
                                b1 = b1 - nColors
                            }
                            
                            color = colors[b0][0] + xX*(colors[b1][0] - colors[b0][0])
                            pixelAddress.pointee = UInt8(color)         // R
                            
                            color = colors[b0][1] + xX*(colors[b1][1] - colors[b0][1])
                            (pixelAddress + 1).pointee = UInt8(color)   // G
                            
                            color = colors[b0][2] + xX*(colors[b1][2] - colors[b0][2])
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
        
        return contextImage
    }   //end if == true

        else {
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
                
       //         light blue for contexrImageBlank
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
    }   // end else
    }   //  end func
    
    func getColorImage(rRLeft:Double, gGLeft:Double, bBLeft:Double, rRRight:Double, gGRight:Double, bBRight:Double) -> CGImage { 
   
        var colorImage: CGImage
        
        var colorWidth: Int = 0
        var colorHeight: Int = 40
        var xGradient: Double = 0.0
        var colorGradient: Double = 0.0
        colorWidth = Int(inputWidth - 20)
   
        // set up CG parameters
        let bitsPerComponent: Int = 8   // for UInt8
        let componentsPerPixel: Int = 4  // RGBA = 4 components
        let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
            let bytesPerRow: Int = colorWidth * bytesPerPixel
            let rasterBufferSize: Int = colorWidth * colorHeight * bytesPerPixel
        
        // Allocate data for the raster buffer.  I'm using UInt8 so that I can
        // address individual RGBA components easily.
            let rasterBufferPtr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)
        
        // Create a CGBitmapContext for drawing and converting into an image for display
            let context: CGContext = CGContext(data: rasterBufferPtr,
                                           width: colorWidth,
                                           height: colorHeight,
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
            let width: Int = colorWidth
            let height: Int = colorHeight
        
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
                
                xGradient = Double(u/colorWidth)

                colorGradient = rRLeft + xGradient*(rRRight - rRLeft)
                pixelAddress.pointee = UInt8(colorGradient)         // R
                
                colorGradient = gGLeft + xGradient*(gGRight - gGLeft)
                (pixelAddress + 1).pointee = UInt8(colorGradient)   // G
                
                colorGradient = bBLeft + xGradient*(bBRight - bBLeft)
                (pixelAddress + 2).pointee = UInt8(colorGradient)   // B
                
                (pixelAddress + 3).pointee = UInt8(255)     //alpha
                    
                    
                    // IMPORTANT:
                    // there is no type checking here and it is up to you to make sure that the
                    // address indexes do not go beyond the memory allocated for the buffer
                
            }    //end for u
            
        }    //end for v
        
        // convert the context into an image - this is what the function will return
        colorImage = context.makeImage()!
        
        // no automatic deallocation for the raster data
        // you need to manage that yourself
        rasterBufferPtr.deallocate()
        
        return colorImage
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

        let contextImage: CGImage = getContextImage(drawIt:drawItStart)
        let img = Image(contextImage, scale: 1.0, label: Text("Test"))
        
        HStack{ // this container shows instructions on left / dwg on right
        
            ScrollView(showsIndicators: true) {
            VStack( // the left side is a vertical container with user stuff
                alignment: .center, spacing: 10) // spacing is between VStacks
            {
                Group{
                    Text("")
                    Text("Click in green area to define values.")
                    Text("Double-click in green area to enter the values.")
                    Text("Click image to choose new center.\n")
                }
                
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
                    //  .textFieldStyle(.roundedBorder)
                    //    .padding()
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter center Y")
                    Text("Between -2 and 2")
                    TextField("Y",value: $yCStart, formatter: ContentView.cgFormatter)
                    //  .textFieldStyle(.roundedBorder)
                    //    .padding()
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter scale:")
                    TextField("Scale",value: $scaleStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                }
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter iMax:")
                    TextField("iMax",value: $iMaxStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                }   
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter rSqLimit:")
                    TextField("rSqLimit",value: $rSqLimitStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter imageWidth:")
                    TextField("imageWidth",value: $imageWidthStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter imageHeight:")
                    TextField("imageHeightStart",value: $imageHeightStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                } 
                
                } // end of group
                
     /*           Group{
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter nBlocks:")
                    TextField("nBlocks",value: $nBlocksStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter bE:")
                    TextField("bE",value: $bEStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                } 
                
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter eE:")
                    TextField("eE",value: $eEStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                    //    .padding()
                } 
                
                }   // end of group */
                
                Group{
                
                VStack{
                    Text("Enter number of colors")
                    TextField("nColors",value: $nColorsStart, formatter: ContentView.cgUnboundFormatter)
                }
            
                VStack{
                    Text("Enter R1 component:")
                    TextField("rR1",value: $rR1Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G1 component:")
                    TextField("gG1",value: $gG1Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B1 component:")
                    TextField("bB1",value: $bB1Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter R2 component:")
                    TextField("rR2",value: $rR2Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G2 component:")
                    TextField("gG2",value: $gG2Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B2 component:")
                    TextField("bB2",value: $bB2Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                } // end of group
                
                Group{
                
                VStack{
                    let colorImage:CGImage = getColorImage(rR1Start, gG1Start, bB1Start, rR2Start, gG2Start, bB2Start)
        //            print("hello")
                }   
                                                
                } // end of group
                
                Group{
                
                VStack{
                    Text("Enter R3 component:")
                    TextField("rR3",value: $rR3Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G3 component:")
                    TextField("gG3",value: $gG3Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B3 component:")
                    TextField("bB3",value: $bB3Start, formatter: ContentView.cgUnboundFormatter)
                }
                
     /*           VStack{
                    Text("Enter R4 component:")
                    TextField("rR4",value: $rR4Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G4 component:")
                    TextField("gG4",value: $gG4Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B4 component:")
                    TextField("bB4",value: $bB4Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter R5 component:")
                    TextField("rR5",value: $rR5Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter G5 component:")
                    TextField("gG5",value: $gG5Start, formatter: ContentView.cgUnboundFormatter)
                }
                
                VStack{
                    Text("Enter B5 component:")
                    TextField("bB5",value: $bB5Start, formatter: ContentView.cgUnboundFormatter)
                }*/
                                
                Text("")
                
                } // end of group
                
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
                drawItPlainStart = true
            }
            .contentShape(Rectangle())
            .onTapGesture(count:1){
                drawItStart = false
                drawItPlainStart = true
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



