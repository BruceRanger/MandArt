//
//  PictureDefinition.swift
//  MandArt
//
//  Managing user inputs
//

import Foundation

//class PictureDefinition: Codable, ObservableObject {

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
}
