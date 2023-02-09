//
//  ErrorViewModel.swift
//  MandArt
//
//  Based on: https://www.avanderlee.com/swiftui/error-alert-presenting/

import Foundation

/// A reusable error view model for communicating with the user.
@available(macOS 10.15, *)
final class ErrorViewModel: ObservableObject {
    /// An enumeration of the local errors possible in MandArt
    enum ErrorCustomEnum: LocalizedError {
        case leftGradientOutOfRange
        case cannotBeNegative

        var errorDescription: String? {
            switch self {
            case .leftGradientOutOfRange:
                return "Left gradient invalid."
            case .cannotBeNegative:
                return "Cannot be negative."
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .leftGradientOutOfRange:
                return "Please change left gradient to a valid number."
            case .cannotBeNegative:
                return "Please change to a non-negative number."
            }
        }
    }

    @Published var errorCustomTitle: String = ""
    @Published var errorCustomObject: Swift.Error?

    func testErrorBox1() {
        errorCustomObject = ErrorCustomEnum.leftGradientOutOfRange
    }

    func testErrorBox2() {
        errorCustomObject = ErrorCustomEnum.cannotBeNegative
    }
}
