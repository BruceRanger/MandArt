//
//  Colorlist.swift
//  MandArt
//
//  This file defines `Colorlist` and `ColorlistItem`.
//  See
//  https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

import Foundation
import SwiftUI      // Color


/// - Tag: DataModel
struct ColorlistItem: Identifiable, Codable {
    var id = UUID()
    var num : Int = 0
    var color : Color
    var r : Double = 0
    var g : Double = 0
    var b : Double = 0
}

struct Colorlist: Identifiable, Codable {
    var id = UUID()
    var items: [ColorlistItem]
}

extension ColorlistItem: Equatable {
    static func ==(lhs: ColorlistItem, rhs: ColorlistItem) -> Bool {
        lhs.id == rhs.id
    }
}

// Provide some default content.
extension Colorlist {
    // Provide an empty list.
    static let emptyList = Colorlist(items: [])
    
    // Provide some starter content.
    static let item1 = ColorlistItem(num:1, color:  Color(.sRGB, red:   0/255, green: 255/255, blue:   0/255), r:0.0, g:255.0, b:0.0 )

    static let item2 = ColorlistItem(num:2, color: Color(.sRGB, red:   255/255, green: 255/255, blue:   0/255), r:255.0, g:255.0, b:0.0)

    static let item3 = ColorlistItem(num:3, color: Color(.sRGB, red: 255/255, green: 0/255, blue:   0/255),r:255.0, g:0.0, b:0.0)

    static let item4 = ColorlistItem(num:4, color: Color(.sRGB, red: 255/255, green:   0/255, blue: 255/255),r:255.0, g:0.0, b:255.0)

    static let item5 = ColorlistItem(num:5, color: Color(.sRGB, red:   0/255, green:   0/255, blue: 255/255),r:0.0, g:0.0, b:255.0)

    static let item6 = ColorlistItem(num:6, color: Color(.sRGB, red:   0/255, green: 255/255, blue: 255/255),r:0.0, g:255.0, b:255.0)

    static let demoList = Colorlist(items: [ item1, item2, item3, item4, item5, item6 ])
}

// Define some operations.
extension Colorlist {
    mutating func addItem(item: ColorlistItem) {
        items.append(item)
    }
    
    mutating func addItem(
        num : Int,color : Color,
        r : Double,g : Double,b : Double) {
        addItem(item: ColorlistItem(num : num,color : color,r : r,g : g,b : b))
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
