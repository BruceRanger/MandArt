//
//  PictureDefinition.swift
//  MandArt
//
//  Managing user inputs
//

import Foundation
import SwiftUI

/// The input information defining a MandArt picture.
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
    var colorlist: Colorlist

    // initialize with defaults
    init(){
        let hues: [Hue] = [
            Hue(num:1, r:0.0, g:255.0, b:0.0),
            Hue(num:2, r:255.0, g:255.0, b:0.0),
            Hue(num:3, r:255.0, g:0.0, b:0.0),
            Hue(num:4, r:255.0, g:0.0, b:255.0),
            Hue(num:5, r:0.0, g:0.0, b:255.0),
            Hue(num:6, r:0.0, g:255.0, b:255.0),
        ]
        self.hues = hues
        self.colorlist = Colorlist(hues: hues)
    }

    // initialize with defaults and default set of colors (hues)
    init(hues:[Hue]){
        self.hues = hues
        self.colorlist = Colorlist(hues: hues)
    }

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
        hues: [Hue],
        colorlist: Colorlist){
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
            self.colorlist = Colorlist(hues: hues)
        }
}

//[ColorlistItems: items: [
//    item1: ColorlistItem(num:1, color:  Color(.sRGB, red:   0/255, green: 255/255, blue:   0/255), r:0.0, g:255.0, b:0.0 ),
//    item2: ColorlistItem(num:2, color: Color(.sRGB, red:   255/255, green: 255/255, blue:   0/255), r:255.0, g:255.0, b:0.0),
//    item3: ColorlistItem(num:3, color: Color(.sRGB, red: 255/255, green: 0/255, blue:   0/255),r:255.0, g:0.0, b:0.0),
//    item4: ColorlistItem(num:4, color: Color(.sRGB, red: 255/255, green:   0/255, blue: 255/255),r:255.0, g:0.0, b:255.0),
//    item5: ColorlistItem(num:5, color: Color(.sRGB, red:   0/255, green:   0/255, blue: 255/255),r:0.0, g:0.0, b:255.0),
//    item6: ColorlistItem(num:6, color: Color(.sRGB, red:   0/255, green: 255/255, blue: 255/255),r:0.0, g:255.0, b:255.0)

