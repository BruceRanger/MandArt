//
//  MandArtTests.swift
//  MandArtTests
//
//  Created by Denise Case on 9/24/23.
//

import XCTest
@testable import MandArt

final class MandArtTests: XCTestCase {

  var tempURL: URL!

  override func setUpWithError() throws {
    // This method is called before each test method in the class is called.
    // We'll create a temporary directory to save our test document.
    let tempDir = FileManager.default.temporaryDirectory
    tempURL = tempDir.appendingPathComponent(UUID().uuidString)
  }

  override func tearDownWithError() throws {
    // This method is called after each test method in the class finishes.
    // We'll clean up the temporary file.
    try? FileManager.default.removeItem(at: tempURL)
  }

  func testDocumentWriteAndRead() throws {
    // 1. Create an instance of your MandArtDocument
    let originalDocument = MandArtDocument()

    // 2. Populate the document with some sample data
    originalDocument.docName = "SampleData"
    // (Repeat for other properties or data as needed)

    // 3. Save the document to a temporary location
    //try originalDocument.write(to: tempURL, ofType: "yourDocumentType")

    // 4. Read the document back from that location
   // let readDocument = MandArtDocument(contentsOf: tempURL, ofType: "yourDocumentType")

    // 5. Verify that the read data matches the original sample data
  //  XCTAssertEqual(originalDocument.docName, readDocument.docName)
    // (Repeat for other properties or data as needed)
  }

    func testExample() throws {
      let sum = 2 + 2
      XCTAssertEqual(sum, 4, "Expected 2 + 2 to equal 4")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
