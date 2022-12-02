//
//  ErrorViewModel.swift
//  MandArt
//
//  Based on: https://www.avanderlee.com/swiftui/error-alert-presenting/

import Foundation

final class ErrorViewModel: ObservableObject {
    enum ErrorCustom: LocalizedError {
        case leftGradientOutOfRange

        var errorDescription: String? {
            switch self {
                case .leftGradientOutOfRange:
                    return "Left gradient invalid."
            }
        }

        var recoverySuggestion: String? {
            switch self {
                case .leftGradientOutOfRange:
                    return "Please change left gradient to a valid number."
            }
        }
    }

    @Published var errorCustomTitle: String = ""
    @Published var errorCustomObject: Swift.Error?

    func testErrorBox() {
        errorCustomObject = ErrorCustom.leftGradientOutOfRange
    }
}
