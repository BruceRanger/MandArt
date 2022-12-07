//
//  PictureDefinition.swift
//  MandArt
//
//  Managing user inputs
//

import Foundation
import SwiftUI

/// The use input information defining a MandArt picture.
///
struct PictureDefinition: Codable, Identifiable {
    var id = UUID()
    var xC: Double = -0.74725
    var yC: Double =  0.08442
    var scale: Double =  2_880_000.0
    var iMax: Double =  10_000.0
    var rSqLimit: Double =  400.0
    var imageWidth: Int = 1_200
    var imageHeight: Int = 1_000
    var nBlocks: Int =  60
    var bE: Double =  5.0
    var eE: Double =  15.0
    var theta: Double =  0.0
    var nImage: Int = 0
    var dFIterMin: Double =  10.0
    var nColors: Int = 6
    var leftNumber: Int = 1
    var hues: [Hue] = [
        Hue(num:1, r:0.0, g:255.0, b:0.0),
        Hue(num:2, r:255.0, g:255.0, b:0.0),
        Hue(num:3, r:255.0, g:0.0, b:0.0),
        Hue(num:4, r:255.0, g:0.0, b:255.0),
        Hue(num:5, r:0.0, g:0.0, b:255.0),
        Hue(num:6, r:0.0, g:255.0, b:255.0),
    ]
    var huesEstimatedPrintPreview: [Hue] = []
    var huesOptimizedForPrinter: [Hue] = []


    /// Initialize with an array of Hues (sorted rgbs)
    /// - Parameter hues: an array of hues
    init(hues:[Hue]){
        self.hues = hues
        self.huesEstimatedPrintPreview = getHuesEstimatedPrintPreview(inHues: hues)
        self.huesOptimizedForPrinter = getHuesOptimizedForPrinter(inHues:hues)
    }


    /// Initialize by setting everything.
    /// - Parameters:
    ///   - xC: <#xC description#>
    ///   - yC: <#yC description#>
    ///   - scale: <#scale description#>
    ///   - iMax: <#iMax description#>
    ///   - rSqLimit: <#rSqLimit description#>
    ///   - imageWidth: <#imageWidth description#>
    ///   - imageHeight: <#imageHeight description#>
    ///   - nBlocks: <#nBlocks description#>
    ///   - bE: <#bE description#>
    ///   - eE: <#eE description#>
    ///   - theta: <#theta description#>
    ///   - nImage: <#nImage description#>
    ///   - dFIterMin: <#dFIterMin description#>
    ///   - nColors: <#nColors description#>
    ///   - leftNumber: <#leftNumber description#>
    ///   - hues: <#hues description#>
    init(
        xC: Double,
        yC: Double,
        scale: Double,
        iMax: Double,
        rSqLimit: Double,
        imageWidth: Int,
        imageHeight: Int,
        nBlocks: Int,
        bE: Double,
        eE: Double,
        theta: Double,
        nImage: Int,
        dFIterMin: Double,
        nColors: Int,
        leftNumber: Int,
        hues: [Hue]
        ){
            self.xC = xC
            self.yC = yC
            self.scale = scale
            self.iMax = iMax
            self.rSqLimit = rSqLimit
            self.imageWidth = imageWidth
            self.imageHeight = imageHeight
            self.nBlocks = nBlocks
            self.bE = bE
            self.eE = eE
            self.theta = theta
            self.nImage = nImage
            self.dFIterMin = dFIterMin
            self.nColors = nColors
            self.leftNumber = leftNumber
            self.hues = hues
            self.huesEstimatedPrintPreview = getHuesEstimatedPrintPreview(inHues:hues)
            self.huesOptimizedForPrinter = getHuesOptimizedForPrinter(inHues:hues)
        }

    private func getHueFromLookupResponse(response: String, sortOrder: Int) -> Hue {
        // response is in format "000-000-000" need to get r / g / b
        let rStr: String = response[0..<3]
        let gStr: String = response[4..<7]
        let bStr: String = response[9..<12]
        let red: Double = Double(rStr)!
        let green: Double = Double(gStr)!
        let blue: Double = Double(bStr)!
        return Hue(num:sortOrder, r:red, g:green, b:blue)
    }


    /// Convert from a precise R G B double (0-255)
    ///  To a general bucketed value (0, 34, 68, 102, 136, 170, 204, 238, 255)
    /// - Parameter preciseValue: preciseValue a double from 0 to 255
    /// - Returns: a bucketed Double equal or less than the precise value
    fileprivate func getBucketColorDouble(preciseValue: Double) -> Double {
        var bucketValue : Double = 0.0
        switch preciseValue {
            case 0..<34:
                bucketValue = 0
            case 34..<68:
                bucketValue = 34
            case 68..<102:
                bucketValue = 68
            case 102..<136:
                bucketValue = 102
            case 136..<170:
                bucketValue = 136
            case 170..<204:
                bucketValue = 170
            case 204..<238:
                bucketValue = 204
            case 238..<255:
                bucketValue = 238
            case 255:
                bucketValue = 255
            default:
                fatalError()
        }
        return bucketValue
    }

    fileprivate func getLookupStringFromHue(hue: Hue) -> String {
        let bucketR : Double = getBucketColorDouble(preciseValue:hue.r)
        let bucketG : Double = getBucketColorDouble(preciseValue:hue.g)
        let bucketB : Double = getBucketColorDouble(preciseValue:hue.b)
        let strR:String = String(format: "%03d", Int(bucketR))
        let strG:String = String(format: "%03d", Int(bucketG))
        let strB:String = String(format: "%03d", Int(bucketB))
        let lookupString:String = strR + "-"+strG + "-"+strB
        return lookupString
    }

    /// Calculate the way the input set of colors will likely appear when printed.
    /// - Parameter inHues: inHues array of Hues the user input
    /// - Returns: an array of Hues that simiulate the way the inputs will likely look when printed
    private func getHuesEstimatedPrintPreview(inHues:[Hue]) -> [Hue]{
        var outHues:[Hue] = [Hue]()
        for inHue in inHues {
            let lookupString:String = getLookupStringFromHue(hue:inHue)
            let response = LookupEstimatedPrintColor[lookupString]
            if response == nil {
                // its good - use as is
                outHues.append(inHue)
            }
            else {
                // use the response to make a hue and append that
                let previewHue:Hue = getHueFromLookupResponse(response:response!, sortOrder: inHue.num)
                outHues.append(previewHue)
            }
        }
        return outHues
    }


    /// Calculate an optimized list of colors that will work better for printing
    /// - Parameter inHues: inHues array of Hues the user input
    /// - Returns: an array of Hues optimized for printing (may want to send this png to the printer)
    private func getHuesOptimizedForPrinter(inHues:[Hue]) -> [Hue]{
        var outHues:[Hue] = [Hue]()
        for inHue in inHues {
            let lookupString:String = getLookupStringFromHue(hue:inHue)
            let response = LookupOptimizedForPrintColor[lookupString]
            if response == nil {
                // its good - use as is
                outHues.append(inHue)
            }
            else {
                // use the response to make a hue and append that
                let optimizedHue:Hue = getHueFromLookupResponse(response:response!, sortOrder:inHue.num)
                outHues.append(optimizedHue)
            }
        }
        return outHues
    }


}
