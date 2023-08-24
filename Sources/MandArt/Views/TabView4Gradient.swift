import SwiftUI
import UniformTypeIdentifiers



struct TabView4Gradient: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var activeDisplayState: ActiveDisplayChoice

  internal var leftGradientIsValid: Bool {
    var isValid = false
    let leftNum = doc.picdef.leftNumber
    let lastPossible = doc.picdef.hues.count
    isValid = leftNum >= 1 && leftNum <= lastPossible
    return isValid
  }

  internal var calculatedRightNumber: Int {
    if leftGradientIsValid, doc.picdef.leftNumber < doc.picdef.hues.count {
      return doc.picdef.leftNumber + 1
    }
    return 1
  }

  var body: some View {

    VStack {

      Section(header:
                Text("Test Gradient for Adjacent Colors")
        .font(.headline)
        .fontWeight(.medium)
        .padding(.bottom) 
      ) {


        HStack {
          Text("Show gradient from color (leftNumber)")

          TextField(
            "1",
            value: $doc.picdef.leftNumber,
            formatter: MAFormatters.fmtLeftGradientNumber
          )
          .frame(maxWidth: 30)
          .foregroundColor(leftGradientIsValid ? .primary : .red)
          .help("Select the color number for the left side of a gradient.")

          Text("to " + String(calculatedRightNumber))
            .help("The color number for the right side of a gradient.")

          Button("Go") {
            activeDisplayState = .Gradient
          }
          .help("Draw a gradient between two adjoining colors.")
        } // end hstack

      } // end section

    } // end vstack

  } // end body
}
