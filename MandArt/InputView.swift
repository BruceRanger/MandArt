//
//  InputView.swift
//  MandArt
//
//  Created by Denise Case on 12/4/21.
//

import SwiftUI

extension View {
    func textFieldAlert(isShowing: Binding<Bool>,text: Binding<String>, title:String) -> some View {
        InputView(isShowing: isShowing, text:text, presenting:self, title:title)
    }
}


struct InputView<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    
    var body: some View {
        GeometryReader { (deviceSize:GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextField(self.title,text:self.$text)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Dismiss")
                        }
                    }
                }.padding()
                    .background(Color.white)
                    .shadow(radius:1)
                    .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
}




//#if DEBUG
//struct InputView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputView()
//    }
//}
//#endif

 
