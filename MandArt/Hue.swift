//
//  Hue.swift
//  MandArt
//
//  Managing one color / hue entry
//

import Foundation
import SwiftUI

class Hue: Codable, Identifiable, ObservableObject {
    var num: Int =  1
    var r: Double =  0.0
    var g: Double =  255.0
    var b: Double =  0.0

    init(num:Int=0, r:Double=0, g:Double=0, b: Double = 0) {
        self.num = num
        self.r = r
        self.g = g
        self.b = b
    }
}

