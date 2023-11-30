import SwiftUI

/// `DelayedTextFieldDouble` is a SwiftUI view struct designed for macOS 11.0 and later.
/// It provides a text field specifically for handling Double values with delayed processing.
/// This struct allows user inputs to be formatted as doubles and performs actions upon committing the input.
@available(macOS 11.0, *)
struct DelayedTextFieldDouble: View {
  var title: String?
  var placeholder: String
  @Binding var value: Double
  var formatter: NumberFormatter
  var onCommit: () -> Void

  @State private var stringValue: String

  /// Initializes a new `DelayedTextFieldDouble` view.
  ///
  /// - Parameters:
  ///   - title: Optional title label.
  ///   - placeholder: Placeholder text.
  ///   - value: Binding to the double value this text field represents.
  ///   - formatter: A `NumberFormatter` to format the double value as a string.
  ///   - onCommit: Closure to execute when editing is committed.
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
      // Optional title for the text field
      if let title = title {
        Text(title)
      }

      // The actual text field for input
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
