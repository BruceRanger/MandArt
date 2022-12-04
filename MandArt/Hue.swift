//
//  Hue.swift
//  MandArt
//
//  Managing one color / hue entry
//

import Foundation
import SwiftUI



/// Hue is a **sorted color** used in a MandArt image.
/// It includes the user-specified sort order,
/// the individual r, g, and b files, and a
/// [Color](https://developer.apple.com/documentation/swiftui/color)
/// object for use with a
/// [ColorPicker](https://developer.apple.com/documentation/swiftui/colorpicker)
/// .
class Hue: Codable, Identifiable, ObservableObject {
    var id = UUID()
    var num: Int =  1
    var r: Double =  0.0
    var g: Double =  255.0
    var b: Double =  0.0
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

    func updateColorFromPicker(cgColor: CGColor) {
        if let arr = cgColor.components {
            self.r = arr[0]
            self.g = arr[1]
            self.b = arr[2]
        }
        else{
            self.r = 0
            self.g = 0
            self.b = 0
        }
    }

}



extension Hue: Equatable {
    static func ==(lhs: Hue, rhs: Hue) -> Bool {
        lhs.id == rhs.id &&
        lhs.num == rhs.num &&
        lhs.r == rhs.r &&
        lhs.g == rhs.g &&
        lhs.b == rhs.b &&
        lhs.color == rhs.color
    }
}


// ***********

// Make Color codable
// See:
// http://brunowernimont.me/howtos/make-swiftui-color-codable
//

fileprivate extension Color {
#if os(macOS)
    typealias SystemColor = NSColor
#else
    typealias SystemColor = UIColor
#endif

    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

#if os(macOS)
        SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
#else
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
#endif

        return (r, g, b, a)
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)

        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}


