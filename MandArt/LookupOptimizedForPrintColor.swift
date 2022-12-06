//
//  LookupOptimizedForPrintColor.swift
//  MandArt
//
//

import Foundation

/// A quick lookup dictionary
///  Given a user-input RGB color likely to print poorly
///   Provide an RGB color optimized for printing
///   TODO: Fix entries - this test will make two dark blue entries change to white for optimized printing
let LookupOptimizedForPrintColor = [
    "000-000-255":"255-255-255",
    "000-000-250":"255-255-255"
]
