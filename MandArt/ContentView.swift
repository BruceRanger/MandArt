//
//  ContentView.swift
//  MandArt
//
//  Created by Bruce Johnson on 9/20/21.
//  Revised and updated 2021-2
//  All rights reserved.

import SwiftUI      // views
import Foundation   // trig functions
import ImageIO      // saving
import CoreServices // persistence

var contextImageGlobal: CGImage?
var startFile = "default.json"
var countFile = "outcount.json"

struct ContentView: View {

    let instructionBackgroundColor = Color.green.opacity(0.5)
    let inputWidth: Double = 290

    @StateObject private var picdef: PictureDefinition = ModelData.shared.load(startFile)
    @StateObject var errdef = ErrorViewModel()

    @State private var testColor = Color.red
    @State private var tapX: Double = 0.0
    @State private var tapY: Double = 0.0
    @State private var tapLocations: [CGPoint] = []
    @State private var moved: Double = 0.0
    @State private var startTime: Date?
    @State private var dragCompleted = false
    @State private var dragOffset = CGSize.zero
    @State private var scaleOld: Double =  1.0

    @State private var drawIt = true
    @State private var drawGradient = false

    private var aspectRatio: String{
        let h : Double = Double(picdef.imageHeight)
        let w : Double = Double(picdef.imageWidth)
        let ratioDouble: Double = max (h/w, w/h)
        let ratioString = String(format: "%.2f", ratioDouble)
        return ratioString
    }

    var leftGradientIsValid: Bool {
        var isValid = false
        let leftNum = picdef.leftNumber
        let lastPossible = picdef.hues.count
        isValid =  leftNum >= 1 && leftNum <= lastPossible
        print("leftGradient leftNum=", leftNum,"and isValid=", isValid)
        return isValid
    }

    @State private var colorEntries: [Color] = [
        Color(.sRGB, red:   0/255, green: 255/255, blue:   0/255),
        Color(.sRGB, red: 255/255, green: 255/255, blue:   0/255),
        Color(.sRGB, red: 255/255, green:   0/255, blue:   0/255),
        Color(.sRGB, red: 255/255, green:   0/255, blue: 255/255),
        Color(.sRGB, red:   0/255, green:   0/255, blue: 255/255),
        Color(.sRGB, red:   0/255, green: 255/255, blue: 255/255)
    ]

    private func  calcColorEntries() -> [Color] {
        var arr: [Color] = []
        picdef.hues.forEach{hue in
            let newColor: Color = Color(
                .sRGB,
                red: hue.r/255.0,
                green: hue.g/255.0,
                blue: hue.b/255.0)
            arr.insert(newColor, at: arr.endIndex)
        }
        return arr
    }

//    func addColorEntry(){
//        let newColor: Color = Color(
//            .sRGB,
//            red: 1,
//            green: 1,
//            blue: 1
//        )
//        colorEntries.append(
//            newColor
//        )
//    }

    /// Return the document directory for this app.
    /// - Returns: URL to document directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }


    /// Returns the new x to be the picture center x when user clicks on the picture.
    /// - Parameters:
    ///   - tapX: Double x coordinate from user tap
    /// - Returns: Double new center x = current x + (tapX - (imagewidth / 2.0)/ scale
    func getCenterXFromTapX(tapX: Double) -> Double {
        let tapXDifference = (tapX - Double(picdef.imageWidth)/2.0)/picdef.scale
        let newXC: Double = picdef.xC + tapXDifference
        debugPrint("Clicked on picture, newXC is",newXC)
        return newXC
    }

    /// Returns the new y to be the picture center y when user clicks on the picture.
    /// - Parameters:
    ///   - tapY: Double y coordinate from user tap
    /// - Returns: Double new center y = current y + ( (imageHeight / 2.0)/ scale - tapY)
    func getCenterYFromTapY(tapY: Double) -> Double {
        let tapYDifference = ((Double(picdef.imageHeight) - tapY) - Double(picdef.imageHeight)/2.0)/picdef.scale
        let newYC: Double = (picdef.yC + tapYDifference)
        debugPrint("Clicked on picture, newYC is",newYC)
        return newYC
    }


    /// Divides scale by 2.0.
    func zoomOut(){
        picdef.scale = picdef.scale / 2.0
        debugPrint("Zoomed out, new scale is",picdef.scale)
    }

    /// Multiplies scale by 2.0.
    func zoomIn(){
        picdef.scale = picdef.scale * 2.0
        debugPrint("Zoomed in, new scale is",picdef.scale)
    }

    /// Reads pictue count (from previous session) to make unique save numbers.
    /// - Returns: newly incremented count
    func readOutCount() -> Int {
        debugPrint("reading the picture count into state")
        var newCount: Int = 0
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent(countFile)
            debugPrint("in readOutCount() reading from ", fileURL)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let countdef = try decoder.decode(CountDefinition.self, from: data)
            newCount = countdef.nImages
            debugPrint("Just read the new i, it will be", newCount)
            return newCount
        } catch {
            debugPrint("Error in readOutCount",error.localizedDescription)
            return newCount
        }
    }

    /// Saves new picture count to be used for the next saved picture.
    /// - Parameter newi: count to be saved
     func saveOutCount(newi: Int) {
         debugPrint("Saving the new count for next time as ", newi)
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
            debugPrint("fileURL for OUTCOUNT JSON is ", fileURL)
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
        //  file:///Users/denisecase/Library/Containers/Bruce-Johnson.MandArt/Data/
        print("In saveImage(), file url is ", url)
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
    
    func getImage() -> CGImage? {
        print("Starting getImage(): drawIt=",drawIt, "drawGradient=",drawGradient)

       // update colors used for picture and gradient
        var colors: [[Double]] = []
        picdef.hues.forEach{hue in
            let arr: [Double] = [hue.r, hue.g, hue.b]
            colors.insert(arr, at: colors.endIndex)
        }
        let imageWidth: Int = picdef.imageWidth
        let imageHeight: Int = picdef.imageHeight
        let nColors: Int = picdef.nColors

        if drawIt == true { // draws image
            print("Drawing picture")
            let iMax: Double = picdef.iMax
            let scale: Double = picdef.scale
            let xC: Double = picdef.xC
            let yC: Double = picdef.yC
            let theta: Double = picdef.theta
            let dIterMin: Double = picdef.dFIterMin
            let pi: Double = 3.14159
            let thetaR: Double = pi*theta/180.0
            let rSqLimit: Double = picdef.rSqLimit

            var contextImage: CGImage
            var rSq: Double = 0.0
            var rSqMax: Double = 0.0
            var x0: Double = 0.0
            var y0: Double = 0.0
            var dX: Double = 0.0
            var dY: Double = 0.0
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
            var p: Double = 0.0
            var test1: Double = 0.0
            var test2: Double = 0.0

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
            
            let nBlocks: Int = picdef.nBlocks
            let nColors: Int = picdef.nColors
            let bE: Double = picdef.bE
            let eE: Double = picdef.eE
            
            var dE: Double = 0.0
            var fNBlocks: Double = 0.0
            var color: Double = 0.0
            var block0: Int = 0
            var block1: Int = 0
            
            fNBlocks = Double(nBlocks)
            
            dE = (iMax - fIterMin - fNBlocks*bE)/pow(fNBlocks, eE)
            
            var blockBound = [Double](repeating: 0.0, count: nBlocks + 1)

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
            let context: CGContext =
                CGContext(data: rasterBufferPtr,
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
                    } //end else
                    
                } //end for u
                
            } //end for v
            
            // convert the context into an image - this is what the function will return
            contextImage = context.makeImage()!
            
            // no automatic deallocation for the raster data
            // you need to manage that yourself
            rasterBufferPtr.deallocate()

            // STASH bitmap
            // before returning it, set the global variable
            // in case they want to save
            contextImageGlobal = contextImage

            return contextImage
        } // end if == true

        else if drawGradient == true && leftGradientIsValid { // draws gradient image
            debugPrint("Drawing gradient")
            
            var gradientImage: CGImage

            // Now we need to generate a bitmap image.

            let leftNumber: Int = picdef.leftNumber
            var rightNumber: Int = 0
            var color: Double = 0.0

            debugPrint("Drawing gradient, left color number is ", leftNumber)
            debugPrint("leftGradiaentIsValid=",leftGradientIsValid)

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
            let context: CGContext =
                CGContext(data: rasterBufferPtr,
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
                    
                } //end for u
                
            } //end for v
            
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
    
    static var cgDecimal2Formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    static var intMaxColorsFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 1
        formatter.maximum = 20
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2
        return formatter
    }

    var body: some View {
        
      var image: CGImage = getImage()!
      let img = Image(image, scale: 1.0, label: Text("Test"))
        
        HStack{ // instructions on left, picture on right
            ScrollView(showsIndicators: true) {

                // left side with user stuff
                // spacing is between VStacks
                VStack(alignment: .center, spacing: 10){
                    Text("MandArt")
                        .font(.title)
                        .padding()
                    Group{
                        HStack {
                            VStack {
                                Button("Zoom In") {
                                    zoomIn()
                                }
                            }
                            .padding(10)
                            VStack {
                                Button("Zoom Out") {
                                    zoomOut()
                                }
                            }
                        }
                        VStack {
                            Button("Save as PNG",
                                   action: {
                                let imageCount = readOutCount()
                                let saveSuccess = saveImage(i:imageCount)
                                debugPrint("Save success",saveSuccess)
                            })
                        }
                        HStack {
                            VStack { // use a button to pause to change values
                                Button("Pause to change values") {
                                    drawIt = false
                                    drawGradient = false
                                    debugPrint("Clicked Pause for changes. draw=",drawIt, "drawGradient=",drawGradient)
                                }
                            }
                            .padding(10)

                            VStack { // use a button to resume
                                Button("Resume") {
                                    drawIt = true
                                    drawGradient = false
                                    debugPrint("Clicked Resume live drawing. draw=",drawIt, "drawGradient=",drawGradient)
                                }
                            }
                        } // end HStack
                    }
                    Divider()
                    Group{
                        HStack {
                            VStack{
                                Text("Left #")
                                TextField("leftNumber",value: $picdef.leftNumber, formatter: ContentView.intMaxColorsFormatter)
                                    .frame(maxWidth: 30)
                                    .foregroundColor(leftGradientIsValid ? .primary : .red)
                            }
                            //.errorAlert(error: $errdef.leftGradientOutOfRange)

                            VStack { // use a button made a gradient
                                Text("")
                                Button("Make a gradient") {
                                    // trigger a state change
                                    drawIt = !drawIt
                                    drawIt = false
                                    drawGradient = true
                                }
                            }
                            VStack {
                                Text("")
                                Button("Resume") {
                                    drawIt = true
                                    drawGradient = false
                                }
                            }
                        } // end HStack
                        Divider()

                        HStack {
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("Enter center X")
                                Text("Between -2 and 2")
                                TextField("X",value: $picdef.xC, formatter: ContentView.cgFormatter)
                                    .padding(2)
                            }
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("Enter center Y")
                                Text("Between -2 and 2")
                                TextField("Y",value: $picdef.yC, formatter: ContentView.cgFormatter)
                                    .padding(2)
                            }
                        }
                    }
                    Divider()
                    Group{
                        HStack {
                            VStack { // each input has a vertical container with a Text label & TextField for data
                                Text("scale:")
                                TextField("Scale",value: $picdef.scale, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("iMax:")
                                TextField("iMax",value: $picdef.iMax, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("rSqLimit:")
                                TextField("rSqLimit",value: $picdef.rSqLimit, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }
                        Divider()
                        HStack {
                            VStack {
                                Text("Image width, px:")
                                TextField("imageWidth",value: $picdef.imageWidth, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("Image height, px:")
                                TextField("imageHeightStart",value: $picdef.imageHeight, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("Aspect ratio:")
                                Text("\(aspectRatio)")
                                    .padding(2)
                            }
                        }
                        Divider()
                        HStack{
                            VStack {
                                Text("bE:")
                                TextField("bE",value: $picdef.bE, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("eE:")
                                TextField("eE",value: $picdef.eE, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }
                        Divider()
                        HStack{
                            VStack {
                                Text("theta:")
                                TextField("theta",value: $picdef.theta, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("nImage:")
                                TextField("nImage",value: $picdef.nImage, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }
                        Divider()
                        HStack {
                            VStack {
                                Text("dFIterMin:")
                                TextField("dFIterMin",value: $picdef.dFIterMin, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                            VStack {
                                Text("nBlocks:")
                                TextField("nBlocks",value: $picdef.nBlocks, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }
                    }
                    Divider()
                    HStack {
                        VStack{
                            Text("Number of colors")
                            TextField("nColors",value: $picdef.nColors, formatter: ContentView.cgUnboundFormatter)
                                .padding(2)
                        }
                    }

                Group{
                    ForEach($picdef.hues, id: \.num) { hue in
                        HStack{
                            VStack{
                                Text("No:")
                                TextField("number",value: hue.num, formatter: ContentView.cgUnboundFormatter)
                                    .disabled(true)
                                    .padding(2)
                            }
                            VStack{
                                Text("Enter R:")
                                TextField("r",value: hue.r, formatter: ContentView.cgUnboundFormatter)
                            }
                            VStack{
                                Text("Enter G:")
                                TextField("g",value: hue.g, formatter: ContentView.cgUnboundFormatter)
                            }
                            VStack{
                                Text("Enter B:")
                                TextField("b",value: hue.b, formatter: ContentView.cgUnboundFormatter)
                                    .padding(2)
                            }
                        }   // end HStack
                    } // end foreach
                } // end colors group
  
                Group { // dont nest list in existing scrollview
                    Text("Ordered List of Colors")
                    // Button("Add Color", action: { addColorEntry() }
                        ForEach($picdef.hues, id:\.num) { $hue in
                               ColorPicker("\(hue.num)", selection: $colorEntries[hue.num-1])
                        }
                        Text("")
                } // end colors group

                } // end VStack for user instructions
                .background(instructionBackgroundColor)
                .frame(width:inputWidth)
                .padding(10)
            } // end scroll bar
            GeometryReader {
                geometry in
                ZStack(alignment: .topLeading) {
                    Text("")
                    img.gesture(self.tapGesture)
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
                debugPrint("User clicked on picture x,y:",tap.startLocation)
                    // if we haven't moved very much, treat it as a tap event
                if self.moved < 10 && self.moved > -10 {
                    tapX = tap.startLocation.x
                    tapY = tap.startLocation.y
                    self.tapLocations.append(tap.startLocation)
                    picdef.xC = getCenterXFromTapX(tapX:tapX)
                    picdef.yC = getCenterYFromTapY(tapY:tapY)
                }
                // reset tap event states
                self.moved = 0
                self.startTime = nil
            }
    } // end tapGesture
}

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
