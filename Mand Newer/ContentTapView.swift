//
//  ContentTapView.swift
//  Mand Newer
//
//  Created by Denise Case on 11/4/21.
//
import SwiftUI

// extension required to use ForEach
// CGPoint must conform to Hashable
extension CGPoint : Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

struct ContentTapView: View {
    @State private var tapLocations: [CGPoint] = []
    @State private var moved: CGFloat = 0
    @State private var startTime: Date?
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(self.tapGesture)
                ForEach(self.tapLocations, id: \.self) {
                    location in
                    //TapAnnotation(tintColor: .systemTeal)
                    TapAnnotation(tintColor: .blue)
                        .offset(CGSize(width: location.x, height: location.y))
                }
            }
        }
    }
    

    
    private var tapGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                // store distance the touch has moved as a sum of all movements
                self.moved += value.translation.width + value.translation.height
                
                // only set the start time if it's the first event
                if self.startTime == nil {
                    self.startTime = value.time
                }
            }
            .onEnded { tap in
                // if we haven't moved very much, treat it as a tap event
                if self.moved < 10 && self.moved > -10 {
                    print(tap.startLocation)
                    self.tapLocations.append(tap.startLocation)
                }
                
                // reset tap event states
                self.moved = 0
                self.startTime = nil
            }
    }
}

struct TapAnnotation: View {
    //var tintColor: UIColor
    var tintColor: Color
    var radius: CGFloat = 10
    var strokeWidth: CGFloat = 1
    var body: some View {
        Circle()
            .overlay(
                Circle()
                    // .stroke(Color(self.tintColor), lineWidth: self.strokeWidth)
                    .stroke(Color.red, lineWidth: self.strokeWidth)
                    .frame(width: self.radius, height: self.radius)
            )
            //.foregroundColor(Color(self.tintColor.withAlphaComponent(0.25)))
            .foregroundColor( Color.red)
            .frame(width: self.radius, height: self.radius)
    }
}

#if DEBUG
struct ContentTapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentTapView()
    }
}
#endif
