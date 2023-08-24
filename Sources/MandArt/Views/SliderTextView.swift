import SwiftUI

struct SliderTextfieldView: View {
  let range: ClosedRange<Double>
  let step: Double
  let placeholder: String
  let formatter: NumberFormatter
  let helpText: String
  @Binding var value: Double

  var body: some View {
    VStack {
      HStack {
        Text("\(Int(range.lowerBound))")
        Slider(value: $value, in: range, step: step) { isStarted in
          if isStarted {
            // Your action
          }
        }
        Text("\(Int(range.upperBound))")
        TextField(
          placeholder,
          value: $value,
          formatter: formatter
        ) { isStarted in
          if isStarted {
            // Your action
          }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: 50)
      }
      .padding(.horizontal)
      .help(helpText)
    }
  }
}
