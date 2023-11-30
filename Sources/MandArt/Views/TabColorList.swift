import SwiftUI
import UniformTypeIdentifiers

/// A SwiftUI view that represents a list of tab colors.
///
/// This view is available on macOS 12.0 and later. It uses a `GeometryReader` to adapt its size to the available space.
/// It displays a list of colors (`hues`) from a `MandArtDocument` object. Each hue is represented by a
/// `TabColorListRow`.
/// The list allows for reordering of colors, which is handled by the `moveHues(from:to:)` function.
///
/// - Parameters:
///   - doc: An `ObservedObject` of type `MandArtDocument`. This is the document model containing the data.
///   - requiresFullCalc: A `Binding<Bool>` indicating whether a full calculation is required.
///   - showGradient: A `Binding<Bool>` indicating whether to show the gradient.
///
@available(macOS 12.0, *)
struct TabColorList: View {
  @ObservedObject var doc: MandArtDocument
  @Binding var requiresFullCalc: Bool
  @Binding var showGradient: Bool

  var body: some View {
    GeometryReader { geometry in
      List {
        ForEach($doc.picdef.hues, id: \.id) { $hue in
          TabColorListRow(doc: doc, hue: $hue)
        }
        .onMove(perform: moveHues)
      }
      .frame(height: geometry.size.height)
    }
    .onAppear {
      requiresFullCalc = false
    }
    .frame(maxHeight: .infinity)
  }

  /// Handles the reordering of hues within the document.
  ///
  /// When hues are moved in the list, this function updates their order in the `MandArtDocument`.
  /// It also reassigns the hue numbers to reflect the new order.
  ///
  /// - Parameters:
  ///   - source: An `IndexSet` indicating the original positions of the moved hues.
  ///   - destination: An `Int` representing the new position for the moved hues.
  func moveHues(from source: IndexSet, to destination: Int) {
    doc.picdef.hues.move(fromOffsets: source, toOffset: destination)
    for (index, _) in doc.picdef.hues.enumerated() {
      doc.picdef.hues[index].num = index + 1
    }
  }
}
