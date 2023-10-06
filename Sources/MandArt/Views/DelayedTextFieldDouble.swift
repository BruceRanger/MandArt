import SwiftUI

@available(macOS 11.0, *)
struct DelayedTextFieldDouble: View {
  var title: String?
  var placeholder: String
  @Binding var value: Double
  var formatter: NumberFormatter
  var onCommit: () -> Void

  @State private var stringValue: String
  @State private var initialValue: Double

  init(title: String? = nil, placeholder: String, value: Binding<Double>, formatter: NumberFormatter, onCommit: @escaping () -> Void = {}) {
    self.title = title
    self.placeholder = placeholder
    self._value = value
    self.formatter = formatter
    self.onCommit = onCommit
    self._stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue)) ?? "")
    self._initialValue = State(initialValue: value.wrappedValue)
  }

  var body: some View {
    VStack {
      if let title = title {
        Text(title)
      }
      TextField(placeholder, text: $stringValue, onEditingChanged: { isEditing in
        if !isEditing {
          // Convert string to double only on editing completion
          if let num = formatter.number(from: stringValue) {
            let newValue = num.doubleValue
            if initialValue != newValue {
              value = newValue
              onCommit()
              initialValue = newValue // Update initialValue for next editing session
            }
          }
        }
      })
      .onChange(of: value) { newValue in
        // Update stringValue with formatted string
        if newValue != initialValue {
          stringValue = formatter.string(from: NSNumber(value: newValue)) ?? ""
        }
      }
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .multilineTextAlignment(.trailing)
    }
    .onAppear {
      // Set initialValue and stringValue when the view appears
      initialValue = value
      stringValue = formatter.string(from: NSNumber(value: value)) ?? ""
    }
  }
}
