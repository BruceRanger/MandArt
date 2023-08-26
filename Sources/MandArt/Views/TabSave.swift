import SwiftUI
import UniformTypeIdentifiers

struct TabSave: View {
  @ObservedObject var doc: MandArtDocument
  @ObservedObject var popupManager = PopupManager()


  var body: some View {

    VStack {

      Section(header:
                Text("Save Your Art")
        .font(.headline)
        .fontWeight(.medium)
        .padding(.bottom)
      ) {

          Button("Save Image (as .png)") {
            doc.saveMandArtImage()
          }
          .help("Save MandArt image as .png.")

          Button("Save Image Inputs (as data file)") {
            saveMandArtImageInputs()
          }
          .help("Save MandArt image inputs as .mandart.")
        }// end section

      Section(header:
                Text("Check Colors Before Printing")
        .font(.headline)
        .fontWeight(.medium)
        .padding( .top)
      ) {

        TabSavePopup(popupManager: popupManager)

      } // end second section
      Spacer()
      
      } // end vstack
  } // end body

  // Save the image inputs to a file.
  func saveMandArtImageInputs() {
    let winTitle = doc.getCurrentWindowTitle()
    let justname = winTitle.replacingOccurrences(of: ".mandart", with: "")
    let fname = justname + ".mandart"
    var data: Data
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      data = try encoder.encode(doc.picdef)
    } catch {
      print("Error encoding picdef.")
      print("Closing all windows and exiting with error code 98.")
      NSApplication.shared.windows.forEach { $0.close() }
      NSApplication.shared.terminate(nil)
      exit(98)
    }
    if data == Data() {
      print("Error encoding picdef.")
      print("Closing all windows and exiting with error code 99.")
      NSApplication.shared.windows.forEach { $0.close() }
      NSApplication.shared.terminate(nil)
      exit(99)
    }

    // trigger state change to force a current image
    doc.picdef.imageHeight += 1
    doc.picdef.imageHeight -= 1

    var currImage = contextImageGlobal!
    let savePanel = NSSavePanel()
    savePanel.title = "Choose directory and name for image inputs file"
    savePanel.nameFieldStringValue = fname
    savePanel.canCreateDirectories = true
    savePanel.allowedContentTypes = [UTType.json, UTType.mandartDocType]
    savePanel.begin { (result) in
      if result == .OK {
        do {
          try data.write(to: savePanel.url!)
        } catch {
          print("Error saving file: \(error.localizedDescription)")
        }
        print("Image inputs saved successfully to \(savePanel.url!)")
      } else {
        print("Error saving image inputs")
      }
    }
  } // end function

}
