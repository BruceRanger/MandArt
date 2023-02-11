//
//  MandMath.swift
//
//  Pure Swift for MandArt
//  This helps us decouple from SwiftUI
//  and facilitates deploying in other ways
//
//

import Foundation
import CoreGraphics // CG Color

// set class/static constants first
// These are the same for every instance of MandMath

let windowGroupName: String = "Welcome to MandArt"
let defaultFileName: String = "default.json"

enum MandMath {
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



    /// Check all the Hues (an ordered list of colors)
    ///  for calculated printablility
    static func getCalculatedPrintabilityOfHues(hues: [Hue]) -> [Bool] {
        print("================================================")
        return hues.map { isColorPrintableByCalculation(color: $0.color.cgColor!, num: $0.num   ) }
    }

    /// Check all the Hues (an ordred list of colors)
    /// to see if any are in the printable list
    static func getListPrintabilityOfHues(hues: [Hue]) -> [Bool] {
        print("================================================")
        return hues.map { isColorInPrintableList(color: $0.color.cgColor!, num: $0.num   ) }
    }



    /// Checks a CGColor to see if it is in the printable list.
    ///
    /// - Parameter: CGColor
    /// - Returns:boolean true if in printable list
    static func isColorInPrintableList(color: CGColor, num: Int) -> Bool {

        guard let components = color.components else { return false }
        let r = components[0]
        let g = components[1]
        let b = components[2]

        let red = Int(r * 255.0)
        let green = Int(g * 255.0)
        let blue = Int(b * 255.0)
        print(num, red, green, blue)

        let inList = MandMath.printableColorList.contains([red, green, blue])

        let rr = padIntToThreeCharacters(number: red)
        let gg = padIntToThreeCharacters(number: green)
        let bb = padIntToThreeCharacters(number: blue)

        print("Color Number \(num)(\(rr)-\(gg)-\(bb)): in printable list: ", inList)
        return inList
    }

    /// Decomposes a CGColor into its
    /// red, green, and blue components,
    /// and returns true if all of them are between 0 and 1, inclusive.
    ///
    /// This indicates that the color is printable,
    /// as the RGB color space used by Core Graphics uses
    /// values between 0 and 1 to represent color intensity.
    ///
    /// - Parameter: CGColor
    /// - Returns:boolean true if printable
    static func isColorPrintableByCalculation(color: CGColor, num: Int) -> Bool {

        guard let components = color.components else { return false }
        let r = components[0]
        let g = components[1]
        let b = components[2]

        let isPrintable = r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1

        let red = Int(r * 255.0)
        let green = Int(g * 255.0)
        let blue = Int(b * 255.0)
        print(num, red, green, blue)

        let rr = padIntToThreeCharacters(number: red)
        let gg = padIntToThreeCharacters(number: green)
        let bb = padIntToThreeCharacters(number: blue)

        print("Color Number \(num)(\(rr)-\(gg)-\(bb)): calculated printable: ", isPrintable)
        return isPrintable
    }

    static func padIntToThreeCharacters(number: Int) -> String {
        return String(format: "%03d", number)
    }




    // down here at the end for readability
    static let printableColorList = [
        [0, 73, 36],
        [0, 73, 73],
        [0, 73, 109],
        [0, 73, 146],
        [0, 109, 73],
        [0, 109, 109],
        [0, 109, 146],
        [0, 109, 182],
        [0, 146, 73],
        [0, 146, 109],
        [0, 146, 146],
        [0, 146, 182],
        [0, 182, 73],
        [0, 182, 109],
        [0, 182, 146],
        [0, 182, 182],
        [36, 36, 109],
        [36, 73, 36],
        [36, 73, 73],
        [36, 73, 109],
        [36, 73, 146],
        [36, 109, 0],
        [36, 109, 36],
        [36, 109, 73],
        [36, 109, 109],
        [36, 109, 146],
        [36, 109, 182],
        [36, 146, 0],
        [36, 146, 36],
        [36, 146, 73],
        [36, 146, 109],
        [36, 146, 146],
        [36, 146, 182],
        [36, 146, 219],
        [36, 182, 73],
        [36, 182, 109],
        [36, 182, 146],
        [36, 182, 182],
        [36, 182, 219],
        [36, 219, 182],
        [36, 219, 219],
        [72, 144, 55], // added after choosing a print color
        [73, 0, 109],
        [73, 36, 109],
        [73, 36, 146],
        [73, 73, 0],
        [73, 73, 36],
        [73, 73, 73],
        [73, 73, 109],
        [73, 73, 146],
        [73, 73, 182],
        [73, 109, 0],
        [73, 109, 36],
        [73, 109, 73],
        [73, 109, 109],
        [73, 109, 146],
        [73, 109, 182],
        [73, 109, 219],
        [73, 146, 0],
        [73, 146, 36],
        [73, 146, 73],
        [73, 146, 109],
        [73, 146, 146],
        [73, 146, 182],
        [73, 146, 219],
        [73, 182, 0],
        [73, 182, 36],
        [73, 182, 73],
        [73, 182, 109],
        [73, 182, 146],
        [73, 182, 182],
        [73, 182, 219],
        [73, 219, 182],
        [73, 219, 219],
        [73, 219, 255],
        [81, 179, 85], // added after choosing a print color
        [81, 179, 86], // added after choosing a print color
        [109, 0, 0],
        [109, 0, 36],
        [109, 0, 73],
        [109, 0, 109],
        [109, 0, 146],
        [109, 0, 182],
        [109, 36, 0],
        [109, 36, 36],
        [109, 36, 73],
        [109, 36, 109],
        [109, 36, 146],
        [109, 36, 182],
        [109, 73, 0],
        [109, 73, 36],
        [109, 73, 73],
        [109, 73, 109],
        [109, 73, 146],
        [109, 73, 182],
        [109, 109, 0],
        [109, 109, 36],
        [109, 109, 73],
        [109, 109, 109],
        [109, 109, 146],
        [109, 109, 182],
        [109, 146, 0],
        [109, 146, 36],
        [109, 146, 73],
        [109, 146, 109],
        [109, 146, 146],
        [109, 146, 182],
        [109, 146, 219],
        [109, 182, 0],
        [109, 182, 36],
        [109, 182, 73],
        [109, 182, 109],
        [109, 182, 146],
        [109, 182, 182],
        [109, 182, 219],
        [109, 182, 255],
        [109, 219, 109],
        [109, 219, 146],
        [109, 219, 182],
        [109, 219, 219],
        [109, 219, 255],
        [146, 0, 0],
        [146, 0, 36],
        [146, 0, 73],
        [146, 0, 109],
        [146, 0, 146],
        [146, 36, 0],
        [146, 36, 36],
        [146, 36, 73],
        [146, 36, 109],
        [146, 36, 146],
        [146, 73, 0],
        [146, 73, 36],
        [146, 73, 73],
        [146, 73, 109],
        [146, 73, 146],
        [146, 109, 0],
        [146, 109, 36],
        [146, 109, 73],
        [146, 109, 109],
        [146, 109, 146],
        [146, 109, 182],
        [146, 146, 0],
        [146, 146, 36],
        [146, 146, 73],
        [146, 146, 109],
        [146, 146, 146],
        [146, 146, 182],
        [146, 146, 219],
        [146, 182, 0],
        [146, 182, 36],
        [146, 182, 73],
        [146, 182, 109],
        [146, 182, 146],
        [146, 182, 182],
        [146, 182, 219],
        [146, 219, 36],
        [146, 219, 73],
        [146, 219, 109],
        [146, 219, 146],
        [146, 219, 182],
        [146, 219, 219],
        [146, 219, 255],
        [182, 0, 0],
        [182, 0, 36],
        [182, 0, 73],
        [182, 0, 109],
        [182, 0, 146],
        [182, 36, 0],
        [182, 36, 36],
        [182, 36, 73],
        [182, 36, 109],
        [182, 36, 146],
        [182, 73, 0],
        [182, 73, 36],
        [182, 73, 73],
        [182, 73, 109],
        [182, 73, 146],
        [182, 109, 0],
        [182, 109, 36],
        [182, 109, 73],
        [182, 109, 109],
        [182, 109, 146],
        [182, 109, 182],
        [182, 146, 0],
        [182, 146, 36],
        [182, 146, 73],
        [182, 146, 109],
        [182, 146, 146],
        [182, 146, 182],
        [182, 146, 219],
        [182, 182, 0],
        [182, 182, 36],
        [182, 182, 73],
        [182, 182, 109],
        [182, 182, 146],
        [182, 182, 182],
        [182, 182, 219],
        [182, 219, 0],
        [182, 219, 36],
        [182, 219, 73],
        [182, 219, 109],
        [182, 219, 146],
        [182, 219, 182],
        [182, 219, 219],
        [182, 219, 255],
        [182, 255, 255],
        [219, 0, 0],
        [219, 0, 36],
        [219, 0, 73],
        [219, 0, 109],
        [219, 0, 146],
        [219, 36, 0],
        [219, 36, 36],
        [219, 36, 73],
        [219, 36, 109],
        [219, 36, 146],
        [219, 73, 0],
        [219, 73, 36],
        [219, 73, 73],
        [219, 73, 109],
        [219, 73, 146],
        [219, 109, 0],
        [219, 109, 36],
        [219, 109, 73],
        [219, 109, 109],
        [219, 109, 146],
        [219, 109, 182],
        [219, 146, 0],
        [219, 146, 36],
        [219, 146, 73],
        [219, 146, 109],
        [219, 146, 146],
        [219, 146, 182],
        [219, 146, 219],
        [219, 182, 0],
        [219, 182, 36],
        [219, 182, 73],
        [219, 182, 109],
        [219, 182, 146],
        [219, 182, 182],
        [219, 182, 219],
        [219, 219, 0],
        [219, 219, 36],
        [219, 219, 73],
        [219, 219, 109],
        [219, 219, 146],
        [219, 219, 182],
        [219, 219, 219],
        [219, 219, 255],
        [219, 255, 73],
        [219, 255, 109],
        [219, 255, 146],
        [219, 255, 182],
        [219, 255, 219],
        [219, 255, 255],
        [255, 36, 73],
        [255, 36, 109],
        [255, 73, 73],
        [255, 73, 109],
        [255, 109, 0],
        [255, 109, 36],
        [255, 109, 73],
        [255, 109, 109],
        [255, 109, 146],
        [255, 146, 0],
        [255, 146, 36],
        [255, 146, 73],
        [255, 146, 109],
        [255, 146, 146],
        [255, 146, 182],
        [255, 146, 219],
        [255, 182, 0],
        [255, 182, 36],
        [255, 182, 73],
        [255, 182, 109],
        [255, 182, 146],
        [255, 182, 182],
        [255, 182, 219],
        [255, 219, 0],
        [255, 219, 36],
        [255, 219, 73],
        [255, 219, 109],
        [255, 219, 146],
        [255, 219, 182],
        [255, 219, 219],
        [255, 219, 255],
        [255, 255, 0],
        [255, 255, 36],
        [255, 255, 73],
        [255, 255, 109],
        [255, 255, 146],
        [255, 255, 182],
        [255, 255, 219],
        [255, 255, 255]
    ]

}
