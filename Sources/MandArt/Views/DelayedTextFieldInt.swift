import SwiftUI

@available(macOS 11.0, *)
struct DelayedTextFieldInt: View {

  var title: String?
  var placeholder: String
  @Binding var value: Int
  var formatter: NumberFormatter
  var onCommit: () -> Void

  @State private var inputValue: Int
  @State private var initialValue: Int

  init(title: String? = nil, placeholder: String, value: Binding<Int>, formatter: NumberFormatter, onCommit: @escaping () -> Void = {}) {
    self.title = title
    self.placeholder = placeholder
    self._value = value
    self.formatter = formatter
    self.onCommit = onCommit
    self._inputValue = State(initialValue: value.wrappedValue)
    self._initialValue = State(initialValue: value.wrappedValue)
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
            if self.inputValue != self.initialValue {
              self.value = self.inputValue
              onCommit()
              self.initialValue = self.inputValue // Update initialValue for next editing session
            }
          }
        }
      )
      .onChange(of: value) { newValue in
        // Update inputValue and initialValue when external value changes
        if newValue != initialValue {
          inputValue = newValue
          initialValue = newValue
        }
      }
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .multilineTextAlignment(.trailing)
    }
    .onAppear {
      // Set initialValue and inputValue when the view appears
      initialValue = value
      inputValue = value
    }
  }
}
