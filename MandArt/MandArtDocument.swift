//
//  MandArtDocument.swift
//  MandArt
//
//  See:
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-document-based-app-using-filedocument-and-documentgroup
//

import SwiftUI
import UniformTypeIdentifiers

// ReferenceFileDocument for classes
// FileDocument for struts

final class MandArtDocument: ReferenceFileDocument {

    // tell the system we support only json
    static var readableContentTypes = [UTType.json]

    typealias Snapshot = PictureDefinition
    @Published var picdef: PictureDefinition

    /// - Tag: Snapshot
    func snapshot(contentType: UTType) throws -> PictureDefinition {
        picdef // Make a copy.
    }

    // by default our document is empty or the default
    var text: String = ""


    // a simple initializer that creates a new demo picture
    init() {
        picdef = PictureDefinition()
    }

    // Load a file contents into document.
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
    }

    /// Saves the document's data to a file.
    /// - Tag: FileWrapper
    func fileWrapper(snapshot: PictureDefinition, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }


}
