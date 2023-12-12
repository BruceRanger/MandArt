import Foundation

enum MandArtError: LocalizedError {
  case encodingError
  case emptyData
  case failedSaving

  var errorDescription: String? {
    switch self {
    case .encodingError:
      return "Error encoding picdef."
    case .emptyData:
      return "Encoded data is empty."
    case .failedSaving:
      return "Failed to save picture inputs."
    }
  }
}
