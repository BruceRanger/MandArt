//
//  LookupEstimatedPrintColor.swift
//  MandArt
//
//

import Foundation

/// A quick lookup dictionary
///  Given a user-input RGB color likely to print poorly
///   Provide an RGB color that estimates how it would appear when printed
///   TODO: Fix entries - this test will make two dark blue entries appear black when printed
let LookupEstimatedPrintColor = [
    "000-000-255":"000-000-000",
    "000-000-250":"000-000-000"
]
