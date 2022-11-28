//
//  HueList.swift
//  MandArt
//
//  Based on https://github.com/V8tr/ListCRUDSwiftUI
//

import Foundation
import SwiftUI
import CoreServices


struct HueListView: View {
    @StateObject var picdef:PictureDefinition
    @State private var isEditing = false
    private static var count = 0
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach($picdef.hues) { $hue in
                    HueView(hueEntry: hue)
                }
            }
        }
   
    }

}
