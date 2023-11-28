import SwiftUI

@available(macOS 11.0, *)
struct DelayedTextFieldDouble: View {
  var title: String?
  var placeholder: String
  @Binding var value: Double
  var formatter: NumberFormatter
  var onCommit: () -> Void

  @State private var stringValue: String

  init(
    title: String? = nil,
    placeholder: String,
    value: Binding<Double>,
    formatter: NumberFormatter,
    onCommit: @escaping () -> Void = {}
  ) {
    self.title = title
    self.placeholder = placeholder
    _value = value
    self.formatter = formatter
    self.onCommit = onCommit
    _stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue)) ?? "")
  }

  var body: some View {
    VStack {
      if let title = title {
        Text(title)
      }
      TextField(placeholder, text: $stringValue, onEditingChanged: { isEditing in
        if !isEditing {
          // Convert to double on editing completion
          if let num = formatter.number(from: stringValue) {
            let newValue = num.doubleValue
            if newValue != value {
              value = newValue
              onCommit()
            }
          }
        }
      })
      .onChange(of: value) { newValue in
        // Update stringValue with formatted string
        // when the bound value changes
        let newStringValue = formatter.string(from: NSNumber(value: newValue)) ?? ""
        if newStringValue != stringValue {
          stringValue = newStringValue
        }
      }
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .multilineTextAlignment(.trailing)
    }
  }
}
