//
//  HueView.swift
//  MandArt
//
//

import Foundation
import SwiftUI

// A view that shows the data for one Hue.
struct HueView: View {
    @StateObject var hueEntry : Hue
    
    var body: some View {
        HStack{
            VStack{
                Text("No:")
                TextField("number1",value: $hueEntry.numberStart, formatter: ContentView.cgUnboundFormatter)
                    .disabled(true)
                    .padding(2)
            }
            VStack{
                Text("Enter R1:")
                TextField("r1",value: $hueEntry.rStart, formatter: ContentView.cgUnboundFormatter)
            }
            VStack{
                Text("Enter G1:")
                TextField("g1",value: $hueEntry.gStart, formatter: ContentView.cgUnboundFormatter)
            }
            VStack{
                Text("Enter B1:")
                TextField("b1",value: $hueEntry.bStart, formatter: ContentView.cgUnboundFormatter)
                    .padding(2)
            }
        }
    }
}
