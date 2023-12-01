//
//  FlowLayoutView.swift
//  FlowLayout
//
//  Created by Gab on 2023/11/30.
//

import SwiftUI

public protocol FlowLayoutFeatures {
    associatedtype Element
    associatedtype ContentView: View
    
    var data: [Element] { get }
    
    @ViewBuilder var content: (Element) -> ContentView { get }
}


public struct FlowLayoutView<FlowFeatures: FlowLayoutFeatures>: View {
    public var features: FlowFeatures
    
    public var horizentalSpacing: CGFloat = 8
    
    public var body: some View {
        
        VStack {
            GeometryReader { proxy in
                calculateViewPosition(g: proxy)
            }
        }
    }
    
    // previousWidth는 결국엔 배치는 이전에 배치한 View의 width를 계산한 좌표로 해야하기 때문에 사용한다.
    private func calculateViewPosition(g: GeometryProxy) -> some View {
        var blankWidth: CGFloat = 0
        var blankHeight: CGFloat = 0
        var previousWidth: CGFloat = 0
        var previousHeight: CGFloat = 0
        
        // 문제점 다음줄로 보내는 코드가 애매하다
        return ZStack(alignment: .topLeading) {
            ForEach(Array(features.data.enumerated()), id: \.offset) { index, item in
                features.content(item)
                    .alignmentGuide(.leading) { d in
                        
                        if abs(blankWidth - d.width) > g.size.width {
                            print("이건 다음줄로 옮겨야한다")
                            blankHeight -= d.height
                            blankWidth = 0
                            previousWidth = 0
                            
                            print("blankHeight -> \(blankHeight)")
                        }
                        
                        if index == 0 {
                            blankWidth = 0
                            previousWidth = d.width
                            blankHeight = 0
                            
                            return d[.leading]
                            
                        } else {
                            blankWidth -= previousWidth
                            blankWidth -= horizentalSpacing
                            
                            previousWidth = d.width
                        }
                        
                        return blankWidth
                    }
                    .alignmentGuide(.top) { d in
                        let height = d.height
                        
                        
                        return blankHeight
                    }
                
            }
        }
    }
}

//struct FlowLayoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowLayoutView()
//    }
//}

