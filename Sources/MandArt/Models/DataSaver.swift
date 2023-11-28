import SwiftUI

@available(macOS 12.0, *)
class DataSaver {
  private var picdef: PictureDefinition

  init(picdef: PictureDefinition) {
    self.picdef = picdef
  }

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
