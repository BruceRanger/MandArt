//
//  Colorlist.swift
//  MandArt
//
//  See
//  https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

import Foundation
import SwiftUI


/// The ordered list of colors used to make the MandArt picture.
struct Colorlist: Identifiable, Codable {
    var id = UUID()
    var items: [ColorlistItem]

    init(){
        self.items = []
    }

    /// Create a colorlist from an array of colorlist items
    /// - Parameter items: array of color list items
    init(items:[ColorlistItem] ) {
        self.items = items
    }

    /// Create a colorlist from an array of hues
    /// - Parameter hues: array of hues, each hue having rgb and sort order
    init(hues:[Hue] ) {
        self.items = []
        hues.forEach() {hue in
            let newItem = ColorlistItem(num:hue.num,r:hue.r,g:hue.g,b:hue.b)
            self.addItem(item:newItem)
        }
    }
}


// Provide some default content.
extension Colorlist {
    // Provide an empty list.
    static let emptyList = Colorlist()
    
    // Provide some starter content.
    static let item1 = ColorlistItem(num:1, r:0.0, g:255.0, b:0.0)
    static let item2 = ColorlistItem(num:2, r:255.0, g:255.0, b:0.0)
    static let item3 = ColorlistItem(num:3,r:255.0, g:0.0, b:0.0)
    static let item4 = ColorlistItem(num:4,r:255.0, g:0.0, b:255.0)
    static let item5 = ColorlistItem(num:5,r:0.0, g:0.0, b:255.0)
    static let item6 = ColorlistItem(num:6,r:0.0, g:255.0, b:255.0)
    static let demoList = Colorlist(items: [ item1, item2, item3, item4, item5, item6 ])
}

// Define some operations.
extension Colorlist {
    mutating func addItem(item: ColorlistItem) {
        items.append(item)
    }
    
    mutating func addItem(
        num : Int,
        r : Double,
        g : Double,
        b : Double,
        color : Color) {
        addItem(item: ColorlistItem(num : num,r : r,g : g,b : b))
    }
}

