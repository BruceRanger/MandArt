import SwiftUI

// Provide operations on the MandArt document.
@available(macOS 12.0, *)
extension MandArtDocument {

  private var hueCount: Int {
    return picdef.hues.count
  }

  // Adds a new default hue, and registers an undo action.
  func addHue(undoManager: UndoManager? = nil) {
    picdef.hues.append(Hue(num: hueCount + 1, r: 255, g: 255, b: 255))
    undoManager?.registerUndo(withTarget: self) { doc in
      withAnimation {
        doc.deleteHue(index: doc.hueCount - 1, undoManager: undoManager)
      }
    }
  }

  // Adds a new hue, and registers an undo action.
  func addHue(r: Double, g: Double, b: Double, undoManager: UndoManager? = nil) {
    picdef.hues.append(Hue(num: hueCount + 1, r: r, g: g, b: b))
    undoManager?.registerUndo(withTarget: self) { doc in
      withAnimation {
        doc.deleteHue(index: doc.hueCount - 1, undoManager: undoManager)
      }
    }
  }

  // Deletes the hue at an index, and registers an undo action.
  func deleteHue(index: Int, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    withAnimation {
      _ = picdef.hues.remove(at: index)
    }

    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

  // Replaces the existing items with a new set of items.
  func replaceHues(with newHues: [Hue], undoManager: UndoManager? = nil, animation: Animation? = .default) {
    let oldHues = self.picdef.hues

    withAnimation(animation) {
      picdef.hues = newHues
    }

    undoManager?.registerUndo(withTarget: self) { doc in
      // Because you recurse here, redo support is automatic.
      doc.replaceHues(with: oldHues, undoManager: undoManager, animation: animation)
    }
  }

  // Relocates the specified items, and registers an undo action.
  func moveHuesAt(offsets: IndexSet, toOffset: Int, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    withAnimation {
      picdef.hues.move(fromOffsets: offsets, toOffset: toOffset)
    }

    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }

  // Registers an undo action and a redo action for a hue change
  func registerUndoHueChange(for hue: Hue, oldHue: Hue, undoManager: UndoManager?) {
    let index = self.picdef.hues.firstIndex(of: hue)!

    // The change has already happened, so save the collection of new items.
    let newHues = self.picdef.hues

    // Register the undo action.
    undoManager?.registerUndo(withTarget: self) { doc in
      doc.picdef.hues[index] = oldHue

      // Register the redo action.
      undoManager?.registerUndo(withTarget: self) { doc in
        // Use the replaceItems symmetric undoable-redoable function.
        doc.replaceHues(with: newHues, undoManager: undoManager, animation: nil)
      }
    }
  }

  func updateHueWithColorComponent(index: Int, r: Double? = nil, g: Double? = nil, b: Double? = nil, undoManager: UndoManager? = nil) {
    guard let oldHue = picdef.hues[safe: index] else { return }

    let newHue = Hue(
      num: oldHue.num,
      r: r ?? oldHue.r,
      g: g ?? oldHue.g,
      b: b ?? oldHue.b
    )

    picdef.hues[index] = newHue
    undoManager?.registerUndo(withTarget: self) { doc in
      doc.replaceHues(with: doc.picdef.hues, undoManager: undoManager)
    }
  }

  /**
   Update an ordered color with a new selection from the ColorPicker
   - Parameters:
   - index: an Int for the index of this ordered color
   - newColorPick: the Color of the new selection
   - undoManager: undoManager
   */
  func updateHueWithColorPick(index: Int, newColorPick: Color, undoManager: UndoManager? = nil) {
    let oldHues = self.picdef.hues
    let oldHue = self.picdef.hues[index]
    if let arr = newColorPick.cgColor {
      let newHue = Hue(
        num: oldHue.num,
        r: arr.components![0] * 255.0,
        g: arr.components![1] * 255.0,
        b: arr.components![2] * 255.0
      )
      self.picdef.hues[index] = newHue
    }
    undoManager?.registerUndo(withTarget: self) { doc in
      // Use the replaceItems symmetric undoable-redoable function.
      doc.replaceHues(with: oldHues, undoManager: undoManager)
    }
  }
}
