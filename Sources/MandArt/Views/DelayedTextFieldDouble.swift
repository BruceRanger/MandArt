import SwiftUI

@available(macOS 11.0, *)
struct DelayedTextFieldDouble: View {

  var title: String? = nil
  var placeholder: String
  @Binding var value: Double
  var formatter: NumberFormatter
  var onCommit: () -> Void

  @State private var inputValue: Double

  init(title: String? = nil, placeholder: String, value: Binding<Double>, formatter: NumberFormatter, onCommit: @escaping () -> Void = {}) {
    self.title = title
    self.placeholder = placeholder
    self._value = value
    self.formatter = formatter
    self.onCommit = onCommit
    self._inputValue = State(initialValue: value.wrappedValue)
  }

  var body: some View {
    VStack {
      if let title = title {
        Text(title)
      }
      TextField(
        placeholder,
        value: $inputValue,
        formatter: formatter,
        onEditingChanged: { isEditing in
          if !isEditing {
            self.value = self.inputValue
            onCommit()
          }
        }
      )
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .multilineTextAlignment(.trailing)
    }
  }
}
