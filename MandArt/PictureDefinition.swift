//
//  PictureDefinition.swift
//  MandArt
//
//  Managing user inputs
//

import Foundation

class PictureDefinition: Codable, ObservableObject {
    var xCStart: Double = -0.74725
    var yCStart: Double =  0.08442
    var scaleStart: Double =  2_880_000.0
    var iMaxStart: Double =  10_000.0
    var rSqLimitStart: Double =  400.0
    var imageWidthStart: Int = 1_200
    var imageHeightStart: Int = 1_000
    var nBlocksStart: Int =  60
    var bEStart: Double =  5.0
    var eEStart: Double =  15.0
    var thetaStart: Double =  0.0
    var nImageStart: Int = 0
    var dFIterMinStart: Double =  10.0
    var nColorsStart: Int = 6
    var leftNumberStart: Int = 1
    var hues: [Hue] = [
        Hue(num:1, r:0.0, g:255.0, b:0.0),
        Hue(num:2, r:255.0, g:255.0, b:0.0),
        Hue(num:3, r:255.0, g:0.0, b:0.0),
        Hue(num:4, r:255.0, g:0.0, b:255.0),
        Hue(num:5, r:0.0, g:0.0, b:255.0),
        Hue(num:6, r:0.0, g:255.0, b:255.0),
    ]
}
