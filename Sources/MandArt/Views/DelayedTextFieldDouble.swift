import SwiftUI

@available(macOS 11.0, *)
struct DelayedTextFieldDouble: View {
  var placeholder: String
  var formatter: NumberFormatter
  @Binding var value: Double
  var onEditingChanged: ((Bool) -> Void)?

  @State private var stringValue: String

  init(placeholder: String, value: Binding<Double>, formatter: NumberFormatter, onEditingChanged: ((Bool) -> Void)? = nil) {
    self.placeholder = placeholder
    self._value = value
    self.formatter = formatter
    self.onEditingChanged = onEditingChanged
    self._stringValue = State(initialValue: formatter.string(from: NSNumber(value: value.wrappedValue)) ?? "")
  }

  var body: some View {
    TextField(placeholder, text: $stringValue, onEditingChanged: { isEditing in
      if let newValue = formatter.number(from: stringValue)?.doubleValue {
        value = newValue
      }
      onEditingChanged?(isEditing)
    })
  }
}
