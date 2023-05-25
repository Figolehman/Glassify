//
//  SnapCarousel.swift
//  Glassify2
//
//  Created by Figo Alessandro Lehman on 23/05/23.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    // Properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 30, trailingSpace: CGFloat = 100,
         index: Binding<Int>, items: [T],
         @ViewBuilder content: @escaping (T) -> Content)
    {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex = 0
    
    var body: some View {
        
        
        GeometryReader{ proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustmentWidth = CGFloat(140)
            HStack(spacing: spacing) {
                ForEach(list){ item in
                        
                    let scale = getScale(itemIndex: list.firstIndex { currentItem in
                        currentItem.id == item.id
                    } ?? 0)
                        
                        ZStack{
                            Circle()
                                .fill(.white)
                            content(item)
                        }
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .animation(.easeOut(duration: 0.5))
                        .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset
                                + CGFloat(currentIndex == 2 ? 140 : 0)
                                , y: 50
                        )
                        .gesture(
                            
                            DragGesture()
                                .updating($offset, body: { value, out, _ in
                                    
                                    out = value.translation.width
                                })
                                .onEnded({ value in
                                    
                                    let offsetX = value.translation.width
                                    
                                    let progress =  -offsetX/width
                                    
                                    let roundIndex = progress.rounded()
                                    
                                    currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                                    
                                    currentIndex = index
                                })
                                .onChanged({ value in
                                    let offsetX = value.translation.width
                                    
                                    let progress =  -offsetX/width
                                    
                                    let roundIndex = progress.rounded()
                                    
                                    index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                                    
                                })
                    )
                    //                    .offset(y: 45)
                    //                    .frame(width: proxy.size.width)
                    //                    Circle()
                    //                        .fill(.white)
                    //                        .frame(width: proxy.size.width)
                    //                        .overlay(
                    //                            content(item)
                    //                                .frame(width: proxy.size.width)
                    //                        )
                    
                }
            }.padding(.leading,115)
            .padding(.horizontal, spacing)
        }
    }
    
    func getScale(itemIndex: Int) -> CGFloat {
        if itemIndex == currentIndex { return 0.95 }
        return 0.75
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
