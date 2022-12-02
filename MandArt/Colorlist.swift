//
//  Colorlist.swift
//  MandArt
//
//  This file defines `Colorlist` and `ColorlistItem`.
//  See
//  https://developer.apple.com/documentation/swiftui/building_a_document-based_app_with_swiftui

import Foundation

/// - Tag: DataModel
struct ColorlistItem: Identifiable, Codable {
    var id = UUID()
    var isChecked = false
    var title: String
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
    static let item1 = ColorlistItem(title: "Item 1.")
    static let item2 = ColorlistItem(title: "Item 2.")
    static let item3 = ColorlistItem(title: "Item 3.")
    
    static let demoList = Colorlist(items: [ item1, item2, item3 ])
}

// Define some operations.
extension Colorlist {
    mutating func addItem(item: ColorlistItem) {
        items.append(item)
    }
    
    mutating func addItem(title: String) {
        addItem(item: ColorlistItem(title: title))
    }
}
