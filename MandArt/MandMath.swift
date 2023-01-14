//
//  MandMath.swift
//
//  Pure Swift for MandArt
//  This helps us decouple from SwiftUI
//  and facilitates deploying in other ways
//
//

import Foundation


// set class/static constants first
// These are the same for every instance of MandMath

let windowGroupName: String = "Welcome to MandArt"
let defaultFileName: String = "default.json"
let openingButtonText: String = "Get Started"

struct MandMath {

    // instance variables
    // these can change if we have multiple MandMaths

    // Define static functions below.................
    // static functions are the same for every instance of MandMat

    /// Returns the name of the default document to show when the app first starts up
    /// - Returns: a simple filename (e.g. "default.json")
    static func getDefaultDocumentName() -> String {
        return defaultFileName
    }

    /// Returns the title/name of the window group
    /// - Returns: a simple window group title  (e.g. "Welcome to MandArt")
    static func getWindowGroupName() -> String {
        return windowGroupName
    }

    /// Returns the text to show on the opening button
    /// - Returns: simple text (e.g., "Get Started")
    static func getOpeningButtonText() -> String {
        return openingButtonText
    }

    /// Return a list for printable colors, each element is [r,g,b]
    static func getPrintableColorList() -> [[Int]] {
        return printableColorList
    }

}

// down here at the end for readability
let printableColorList = [
    [0,73,36],
    [],
    [255,255,255]
]
