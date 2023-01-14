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
    [0,73,73],
    [0,73,109],
    [0,73,146],
    [0,109,73],
    [0,109,109],
    [0,109,146],
    [0,109,182],
    [0,146,73],
    [0,146,109],
    [0,146,146],
    [0,146,182],
    [0,182,73],
    [0,182,109],
    [0,182,146],
    [0,182,182],
    [36,36,109],
    [36,73,36],
    [36,73,73],
    [36,73,109],
    [36,73,146],
    [36,109,0],
    [36,109,36],
    [36,109,73],
    [36,109,109],
    [36,109,146],
    [36,109,182],
    [36,146,0],
    [36,146,36],
    [36,146,73],
    [36,146,109],
    [36,146,146],
    [36,146,182],
    [36,146,219],
    [36,182,73],
    [36,182,109],
    [36,182,146],
    [36,182,182],
    [36,182,219],
    [36,182,255],
    [36,219,182],
    [36,219,219],
    [73,0,109],
    [73,36,109],
    [73,36,146],
    [73,73,0],
    [73,73,36],
    [73,73,73],
    [73,73,109],
    [73,73,146],
    [73,73,182],
    [73,109,0],
    [73,109,36],
    [73,109,73],
    [73,109,109],
    [73,109,146],
    [73,109,182],
    [73,109,219],
    [73,146,0],
    [73,146,36],
    [73,146,73],
    [73,146,109],
    [73,146,146],
    [73,146,182],
    [73,146,219],
    [73,182,0],
    [73,182,36],
    [73,182,73],
    [73,182,109],
    [73,182,146],
    [73,182,182],
    [73,182,219],
    [73,219,182],
    [73,219,219],
    [73,219,255],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    [xx,xx,xx],
    
    
    [255,255,255]
]
