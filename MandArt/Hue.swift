//
//  Hue.swift
//  MandArt
//
//  Managing one color / hue entry
//

import Foundation

class Hue: Codable, ObservableObject {
    var numberStart: Int =  1
    var rStart: Double =  0.0
    var gStart: Double =  255.0
    var bStart: Double =  0.0
    
    init(numberStart:Int=0, rStart:Double=0, gStart:Double=0, bStart: Double = 0) {
        self.numberStart = numberStart
        self.rStart = rStart
        self.gStart = gStart
        self.bStart = bStart
        
    }
    
}

