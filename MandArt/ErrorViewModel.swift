//
//  ErrorViewModel.swift
//  MandArt
//
//  Based on: https://www.avanderlee.com/swiftui/error-alert-presenting/

import Foundation

final class ErrorViewModel: ObservableObject {
    enum Error: LocalizedError {
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

    @Published var title: String = ""
    @Published var error: Swift.Error?

    func publish() {
        error = Error.leftGradientOutOfRange
    }
}
