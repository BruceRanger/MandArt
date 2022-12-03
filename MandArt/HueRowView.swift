//
//  HueRow.swift
//  MandArt
//
//

import SwiftUI

struct HueRowView: View {

    @Binding var hue: Hue

    @FocusState private var isNumFieldFocused: Bool
    @FocusState private var isRFieldFocused: Bool
    @FocusState private var isGFieldFocused: Bool
    @FocusState private var isBFieldFocused: Bool
    @FocusState private var isColorFieldFocused: Bool

    // Define these handlers as properties that you initialize
    // at the callsite to facilitate preview and testing.
    //    var onNumCommit: (_ oldNum: Int) -> Void
    //    var onRCommit: (_ oldR: Double) -> Void
    //    var onGCommit: (_ oldG: Double) -> Void
    //    var onBCommit: (_ oldB: Double) -> Void
    //    var onColorCommit: (_ oldColor: Color) -> Void

    @State private var oldNum: Int = 0
    @State private var oldR: Double = 0
    @State private var oldG: Double = 0
    @State private var oldB: Double = 0
    @State private var oldColor: Color = Color(
        .sRGB,red: 0/255.0,green:0/255.0, blue:0/255.0)


    var body: some View {
        Group{
            HStack{
                TextField("number",value: $hue.num, formatter: HueRowView.cg255Formatter)
                    .disabled(true)
                    .padding(2)

                TextField("r",value: $hue.r, formatter: HueRowView.cg255Formatter)
                TextField("g",value: $hue.g, formatter: HueRowView.cg255Formatter)
                TextField("b",value: $hue.b, formatter: HueRowView.cg255Formatter)
                    .padding(2)

                ColorPicker("\(hue.num)", selection: $hue.color,supportsOpacity: false)

                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .help("Delete \(hue.num)")
                    .onSubmit{
                        //self.remove(at: IndexSet(integer: self.index))   // << here !!
                    }
                //                        Button(role: .destructive) {
                //                            //$picdef.hues.remove(object: hue)
                //                        } label: {Label("", systemImage: "trash")
                //                        }
            }
        }
    }




    static var cg255Formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimum = 0
        formatter.maximum = 255
        return formatter
    }
}

