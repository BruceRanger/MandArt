import SwiftUI

/// `DataSaver` is responsible for saving `PictureDefinition` data to a file.
/// It provides functionality to encode the `PictureDefinition` into JSON format
/// and to handle the file-saving process using an `NSSavePanel`.
@available(macOS 12.0, *)
class DataSaver {
  private var picdef: PictureDefinition

  /// Initializes a new instance of `DataSaver` with a given `PictureDefinition`.
  /// - Parameter picdef: The `PictureDefinition` instance to be saved.
  init(picdef: PictureDefinition) {
    self.picdef = picdef
  }

  /// Encodes the `PictureDefinition` into JSON data.
  /// - Throws: An error of type `MandArtError` if the encoding fails or the data is empty.
  /// - Returns: An optional `Data` object containing the encoded JSON data.
  func saveData() throws -> Data? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    do {
      let data = try encoder.encode(picdef)
      if data.isEmpty {
        throw MandArtError.emptyData
      }
      return data
    } catch {
      throw MandArtError.encodingError
    }
  }

  /// Presents a save panel to the user and writes the encoded `PictureDefinition` data to the selected file location.
  /// - Parameters:
  ///   - savePanel: The `NSSavePanel` instance used for selecting where to save the file.
  ///   - completionHandler: A closure called with the result of the file save operation.
  func saveToFile(withPanel savePanel: NSSavePanel, completionHandler: @escaping (Result<Void, Error>) -> Void) {
    do {
      guard let data = try saveData() else {
        completionHandler(.failure(MandArtError.encodingError))
        return
      }

      savePanel.begin { result in
        if result == .OK {
          do {
            try data.write(to: savePanel.url!)
            completionHandler(.success(()))
          } catch {
            completionHandler(.failure(error))
          }
        } else {
          completionHandler(.failure(MandArtError.failedSaving))
        }
      }
    } catch {
      completionHandler(.failure(error))
    }
  }
}
