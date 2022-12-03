//
//  MandArtDocument.swift
//  MandArt
//
//  See:
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-document-based-app-using-filedocument-and-documentgroup
//

import SwiftUI
import UniformTypeIdentifiers

/// A utility class to work with files for saving and sharing your art.
///
final class MandArtDocument: ReferenceFileDocument {

    // tell the system we support only reading / writing json files
    static var readableContentTypes = [UTType.json]

    typealias Snapshot = PictureDefinition
    @Published var picdef: PictureDefinition

    /// Create a snapshot of the current state of the document, which will be used for serialization
    /// - Parameter contentType: the standard type we use
    /// - Returns: picture definition
    func snapshot(contentType: UTType) throws -> PictureDefinition {
        return picdef // return the current state
    }

    /// A simple initializer that creates a new demo picture
    init() {
        picdef = PictureDefinition()
    }

    /// Initialize a document
    /// - Parameter configuration: config
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.picdef = try JSONDecoder().decode(PictureDefinition.self, from: data)
    }

    /// Save the picture definittion document to a file.
    /// - Parameters:
    ///   - snapshot: snapshot of the current state
    ///   - configuration: write config
    /// - Returns: a fileWrapper
    func fileWrapper(snapshot: PictureDefinition, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        print ("print the image too")
        let modDate = fileWrapper.fileAttributes["NSFileModificationDate"]
        let uniqueString = stringFromAny(modDate)
        saveImage(tag: uniqueString)
        return fileWrapper
    }

    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }


    /// Save custom user bitmap as a PNG file.
    func saveImage(tag : String) -> Bool {
        print("saving image with tag=",tag)
        let endCount = tag.count-6
        let uniqueEnough = tag[0..<endCount]
        let fn:String = "mandart" + uniqueEnough + ".png"
        print("Saving Image as ", fn)
        let allocator : CFAllocator = kCFAllocatorDefault
        let filePath: CFString = fn as NSString
        let pathStyle: CFURLPathStyle = CFURLPathStyle.cfurlWindowsPathStyle
        let isDirectory: Bool = false
        let url : CFURL = CFURLCreateWithFileSystemPath(allocator, filePath, pathStyle, isDirectory)
        print("Saving Image to ",url)
        //  file:///Users/denisecase/Library/Containers/Bruce-Johnson.MandArt/Data/
        let imageType: CFString = kUTTypePNG
        let count: Int = 1
        let options: CFDictionary? = nil
        var destination: CGImageDestination
        let destinationAttempt: CGImageDestination?  = CGImageDestinationCreateWithURL(url, imageType, count, options)
        if (destinationAttempt == nil) {
            return false
        }
        else {
            destination = destinationAttempt.unsafelyUnwrapped
            CGImageDestinationAddImage(destination,contextImageGlobal!, nil);
            CGImageDestinationFinalize(destination)
            return true
        }
    }

}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}
