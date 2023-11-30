import SwiftUI

/// `DelayedTextFieldInt` is a SwiftUI view struct designed for macOS 11.0 and later.
/// It offers a text field specifically for handling integer values with delayed processing.
/// The struct enables users to input integer values, which are formatted and processed upon completion.
@available(macOS 11.0, *)
struct DelayedTextFieldInt: View {
  var title: String?
  var placeholder: String
  @Binding var value: Int
  var formatter: NumberFormatter
  var onCommit: () -> Void

  @State private var stringValue: String

  /// Initializes a new `DelayedTextFieldInt` view.
  ///
  /// - Parameters:
  ///   - title: Optional title label.
  ///   - placeholder: Placeholder text.
  ///   - value: Binding to the integer value this text field represents.
  ///   - formatter: A `NumberFormatter` to format the integer value as a string.
  ///   - onCommit: Closure to execute when editing is committed.
  init(
    title: String? = nil,
    placeholder: String,
    value: Binding<Int>,
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
          // Convert to int on editing completion
          if let num = formatter.number(from: stringValue) {
            let newValue = num.intValue
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
