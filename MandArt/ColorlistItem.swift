//
//  ColorlistItem.swift
//  MandArt
//
//

import Foundation
import SwiftUI      // Color

struct ColorlistItem: Identifiable, Codable {
    var id = UUID()
    var num : Int = 0
    var r : Double = 0
    var g : Double = 0
    var b : Double = 0
    var color : Color

    // default new entry will be white, with a num of zero
    init() {
        self.num = 0
        self.r = 255
        self.g = 255
        self.b = 255
        self.color = Color(.sRGB,red: self.r/255,green: self.g/255,blue: self.b/255)
    }

    // initialize with a given num and rgb values
    init(num:Int, r:Double,g:Double,b:Double) {
        self.num = num
        self.r = r
        self.g = g
        self.b = b
        self.color = Color(.sRGB,red: self.r/255,green: self.g/255,blue: self.b/255)
    }
}

extension ColorlistItem: Equatable {
    static func ==(lhs: ColorlistItem, rhs: ColorlistItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.num == rhs.num &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.color == rhs.color
    }
}

