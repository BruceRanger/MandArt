//
//  ContentView.swift
//  MandArt
//
//  Created by Bruce Johnson on 9/20/21.
//  Edited by Bruce Johnson on 8/7/22.

import SwiftUI

struct ContentView: View {
    
    struct Config: Codable, Hashable, Identifiable {
        let id: UUID
        let tag: String
        var xC: Double
        var yC: Double
        var scale: Double
    }
    
    let instructionBackgroundColor = Color.green
    let inputWidth: Double = 200.0
//    let inputWidth: Double = 450.0
    
    @State private var showingAlert = false
    @State private var tapX: Double = 0
    @State private var tapY: Double = 0
    
    @State private var tapLocations: [CGPoint] = []
    @State private var moved: Double = 0
    @State private var startTime: Date?
    
    @State private var dragCompleted = false
    @State private var dragOffset = CGSize.zero
    
    // set up initial view size - TODO: make resolution dynamic, user-specified
    
    @State private var imageWidth: Int = 1000
    @State private var imageHeight: Int = 1000
    
    // temporary starting center X and Y - TODO: read this from a file
    
 //   @State private var xCStart: Double = 0.0
 //   @State private var yCStart: Double =  0.0
 //   @State private var scaleStart: Double =  160.0
    
    @State private var xCStart: Double = -0.74725
    @State private var yCStart: Double =  0.08442
    @State private var scaleStart: Double =  2_880_000.0
    
    @State private var scaleOld: Double =  160.0
    
    @State private var selectedConfig: Config?
    
    func getCenterXFromTapX(tapX: Double, imageWidth:Int) -> Double {
        var tapXDifference = (tapX - Double(imageWidth)/2.0)/scaleStart
        print (tapXDifference)
        var newXC: Double = xCStart + tapXDifference // needs work
        print (newXC)
        return newXC
    }
    
    func getCenterYFromTapY(tapY: Double, imageHeight:Int) -> Double {
        var tapYDifference = ((Double(imageHeight) - tapY) - Double(imageHeight)/2.0)/scaleStart
        print (tapYDifference)
        var newYC: Double = (yCStart + tapYDifference) // needs work
        print (newYC)
        return newYC
    }
    
    func zoomOut(){
        self.scaleOld = self.scaleStart
        self.scaleStart = self.scaleOld / 2.0
        print("Double-click detected: Zoom out from\n \(self.scaleOld) to\n \(self.scaleStart)\n")
    }
    
    func zoomIn(){
        self.scaleOld = self.scaleStart
        self.scaleStart = self.scaleOld * 2.0
        print("Single-click detected: Zoom in from\n \(self.scaleOld) to\n \(self.scaleStart)\n")
    }
    
    func getContextImage(xC: Double,yC: Double) -> CGImage {
        
        var contextImage: CGImage
        
        var iMax: Float = 10_000.0
        var rSq: Double = 0.0
        var rSqLimit: Double = 0.0
        var rSqMax: Double = 0.0
        var x0: Double = 0.0
        var y0: Double = 0.0
        
        var xx: Double = 0.0
        var yy: Double = 0.0
        var xTemp: Double = 0.0
        var iter: Float = 0.0
        var dIter: Float = 0.0
        var gGML: Double = 0.0
        var gGL: Double = 0.0
        var fIter = [[Float]](repeating: [Float](repeating: 0.0, count: imageHeight), count: imageWidth)
        var fIterMinLeft: Float = 0.0
        var fIterMinRight: Float = 0.0
        var fIterBottom = [Float](repeating: 0.0, count: imageWidth)
        var fIterTop = [Float](repeating: 0.0, count: imageWidth)
        var fIterMinBottom: Float = 0.0
        var fIterMinTop: Float = 0.0
        var fIterMins = [Float](repeating: 0.0, count: 4)
        var fIterMin: Float = 0.0
        var scale: Double = 0.0
        var p: Double = 0.0
        var test1: Double = 0.0
        var test2: Double = 0.0
        
        rSqLimit = 400.0
        
        //scale = 33_320_000
        scale = self.scaleStart
        
        rSqMax = 162_000.0
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
                        iter = Float(i)
                    }
                }   //end else
                
                if iter < iMax {
                    
                    dIter = Float(-(  log( log(rSq) ) - gGL  )/gGML)
                    
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
        var nColors: Int = 0
        var color: Float = 0.0
        var b0: Int = 0
        var b1: Int = 0
        var block1: Float = 0.0
        
        nBlocks = 60
        
        block1 = 1.0
        
        var blockBound = [Float](repeating: 0.0, count: nBlocks + 1)
        
        var colors: [[Float]] = [[0.0, 255.0, 0.0], [255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0], [0.0, 255.0, 255.0]]
        
        nColors = colors.count
        
        var h: Float = 0.0
        var xX: Float = 0.0
        var k: Float = 0.0
        
        var B: Float = 0.0
        
        B = (log10((iMax + 1.0)/block1))/Float((nBlocks - 1))
        k = pow(10.0, B)
        
        for i in 1...nBlocks {
            blockBound[i] = block1*pow(k, Float(i - 1))
        }
        
        // set up CG parameters
        let bitsPerComponent: Int = 8   // for UInt8
        let componentsPerPixel: Int = 4  // RGBA = 4 components
        let bytesPerPixel: Int = (bitsPerComponent * componentsPerPixel) / 8 // 32/8 = 4
        var bytesPerRow: Int = imageWidth * bytesPerPixel
        var rasterBufferSize: Int = imageWidth * imageHeight * bytesPerPixel
        
        // Allocate data for the raster buffer.  I'm using UInt8 so that I can
        // address individual RGBA components easily.
        var rasterBufferPtr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: rasterBufferSize)
        
        // Create a CGBitmapContext for drawing and converting into an image for display
        var context: CGContext = CGContext(data: rasterBufferPtr,
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
        var xS: Int = 0
        var yS: Int = 0
        var width: Int = imageWidth
        var height: Int = imageHeight
        
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
            var pixel_vertical_offset: Int = rasterBufferSize - (bytesPerRow*(Int(yS)+v+1))
            
            // iterate over all of the pixels in this row
            for u in 0...(width - 1) {
                
                // calculate the horizontal offset to the pixel in the row
                var pixel_horizontal_offset: Int = ((Int(xS) + u) * bytesPerPixel)
                
                // sum the horixontal and vertical offsets to get the pixel offset
                var pixel_offset = pixel_vertical_offset + pixel_horizontal_offset
                
                // calculate the offset of the pixel
                var pixelAddress:UnsafeMutablePointer<UInt8> = rasterBufferPtr + pixel_offset
                
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
    }
    
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
    
    var body: some View {
        var contextImage: CGImage = getContextImage(xC:xCStart,yC:yCStart)
        var img = Image(contextImage, scale: 1.0, label: Text("Test"))
        
        HStack(spacing: 0){ // this container shows instructions on left / dwg on right
        
            VStack( // the left side is a vertical container with user stuff
                alignment: .leading, spacing: 10.0)
            {
                Group{
                    Text("Click here to zoom in.")
                    Text("Double-click here to zoom out.")
                    Text("Click image to choose new center.\n")
                    
                }
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter center X")
                    Text("Between -4 and 4")
                    TextField("X",value: $xCStart, formatter: ContentView.cgFormatter)
                    //  .textFieldStyle(.roundedBorder)
                        .padding()
                }
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter center Y\n between -4 and 4:")
                    Text("Enter center Y\n between -4 and 4:")
                    TextField("Y",value: $yCStart, formatter: ContentView.cgFormatter)
                    //   .textFieldStyle(.roundedBorder)
                        .padding()
                }
                VStack { // each input has a vertical container with a Text label & TextField for data
                    Text("Enter scale:")
                    TextField("Scale",value: $scaleStart, formatter: ContentView.cgUnboundFormatter)
                    //    .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                // Then, there is a Picker to list the pre-selected scenes
                Picker(
                    selection:$selectedConfig,
                    label: Text ("Optional: Choose scene"))
                {
                    Text("No scene selected").tag(nil as Config?)
                    ForEach(self.configs, id: \.id) { item in
                        Text(item.tag).tag(item as Config?)
                    }
                    
                }
                
                
            } // end vstack for user instructions
            .onTapGesture(count:2){
                zoomOut()
            }
            .onTapGesture(count:1){
                zoomIn()
            }
            .background(instructionBackgroundColor)
            .frame(width:inputWidth)
            .padding(50)
            
            GeometryReader {
                geometry in
                ZStack(alignment: .topLeading) {
                    Text("Scene")
                    img
                        .gesture(self.tapGesture)
                        .alert(isPresented: $showingAlert) {
                            // fixed imageWidth & imageHeight
                            xCStart = getCenterXFromTapX(tapX:tapX,imageWidth:imageHeight)
                            print (xCStart)
                            yCStart = getCenterYFromTapY(tapY:tapY,imageHeight:imageWidth)
                            print (yCStart)
                            return Alert(
                                title: Text("It works! You clicked on"),
                                message: Text("X: \(tapX),Y: \(Double(imageHeight) - tapY), so the new center is \(xCStart), \(yCStart). Scale is \(self.scaleStart)."),
                                dismissButton: .default(Text("Got it!")))
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
                    print(tap.startLocation)
                    self.tapLocations.append(tap.startLocation)
                    // the right place to update
                    xCStart = getCenterXFromTapX(tapX:tapX,imageWidth:imageHeight)
                    print (xCStart)
                    yCStart = getCenterYFromTapY(tapY:tapY,imageHeight:imageWidth)
                    print (yCStart)
                }
                
                // reset tap event states
                self.moved = 0
                self.startTime = nil
            }
    } // end tapGesture
    
    
    var configs = [
        Config( id: UUID(), tag: "Overview",
                xC : 0.0,
                yC : 0.0,
                scale :160.0
              ),
        Config( id: UUID(), tag: "M15 = N1",
                xC : -0.7649211,
                yC : 0.1018886,
                scale :2_839_040.0
              ),
        Config( id: UUID(), tag: "M1",
                xC : -0.2985836511290,     // M1
                yC : 0.6580148156626,
                scale : 1.9e12
              ),
        Config(id: UUID(), tag: "M2",
               xC : -0.5489774042572,     // M2
               yC : 0.6513448574304,
               scale : 6_008_327_554_320.0
              ),
        Config(id: UUID(), tag: "M3",
               xC : -0.1913046694  ,   // M3
               yC : 0.6502983463,
               scale : 1.9e9
              ),
        Config(id: UUID(), tag: "M4",
               xC : -0.1690435583 ,   // M4
               yC : 0.6505206291,
               scale : 1.8e9
              ),
        Config(id: UUID(), tag: "M5",
               xC : -0.183111455812451001,    // M5
               yC : 0.651073847461314001,
               scale : 1.0e13
              ),
        Config(id: UUID(), tag: "N2",
               xC : 0.345679 ,   // N2
               yC : 0.38838,
               scale : 320_000.0
              ),
        Config(id: UUID(), tag: "N3",
               xC : -1.250385042 ,  // N3
               yC : 0.007717842,
               scale : 48.0e6
              ),
        Config(id: UUID(), tag: "N4",
               xC :-0.74344 ,  // N4
               yC : 0.12493,
               scale : 576_000.0
              ),
        Config(id: UUID(), tag: "N6",
               xC : -0.74725 ,  // N6
               yC : 0.08442,
               scale :  2_880_000.0
              ),
        Config(id: UUID(), tag: "N8",
               xC : -1.250377295  , // N8
               yC : 0.007719842,
               scale : 928.0e6
              ),
        Config(id: UUID(), tag: "N9",
               xC : -0.111925 , // N9
               yC : 0.6502587,
               scale : 38.4e6
              ),
        Config(id: UUID(),  tag: "N10",
               xC : -0.111715 , // N10
               yC : 0.6495112,
               scale : 2.0e7
              ),
        Config( id: UUID(), tag: "N11",
                xC : -0.148238 , // N11
                yC : 0.651878,
                scale : 26_656_000.0
              )
    ]
    
} // end view struct

//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif


//  var colors: [[Float]] = [[255.0, 128.0, 0.0], [255.0, 255.0, 0.0], [0.0, 255.0, 0.0], [0.0, 128.0, 255.0], [255.0, 0.0, 255.0], [255.0, 0.0, 128.0]]

//  var colors: [[Float]] = [[255.0, 128.0, 0.0], [255.0, 255.0, 0.0], [0.0, 255.0, 0.0], [0.0, 128.0, 255.0], [255.0, 0.0, 255.0], [255.0, 0.0, 128.0]]

//var colors: [[Float]] = [[255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0],[0.0, 255.0, 255.0], [0.0, 255.0, 0.0], [255.0, 255.0, 0.0]]

//var colors: [[Float]] = [[255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, //0.0, 255.0], [0.0, 255.0, 255.0], [0.0, 255.0, 0.0]]

//var colors: [[Float]] = [[0.0, 255.0, 0.0], [255.0, 255.0, 0.0], [255.0, 0.0, 0.0], [255.0, 0.0, 255.0], [0.0, 0.0, 255.0], [0.0, 255.0, 255.0]]

//var colors: [[Float]] = [[255.0, 127.0, 0.0], [255.0, 0.0, 127.0], [127.0, 0.0, 255.0],[0.0, 127.0, 255.0], [0.0, 255.0, 127.0], [127.0, 255.0, 0.0]]

//var colors: [[Float]] = [[0.0, 255.0, 0.0], [255.0, 0.0, 0.0], [0.0, 0.0, 255.0]]

//var colors: [[Float]] = [[255.0, 0.0, 255.0], [30,144,255], [61.0, 145.0, 64.0], [255.0, 255.0, 0.0], [255.0, 165.0, 0.0], [255.0, 0.0, 0.0]]



