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
    
    private func calculateViewPosition(g: GeometryProxy) -> some View {
        var blankWidth: CGFloat = 0
        var blankHeight: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(Array(features.data.enumerated()), id: \.offset) { index, item in
                features.content(item)
                    .alignmentGuide(.leading) { d in
                        
                        if abs(blankWidth - d.width) > g.size.width {
                            print("이건 다음줄로 옮겨야한다")
                        }
                        
                        // 현재 문제점 ViewBuilder 이용해서 뷰를 그릴 떄 여러번 호출되는 문제 발생
                        // 그러면서 blankWidth가 문제생겨버려서 제대로 원하는 위치에 배치가 안된다.
                        
                        return blankWidth
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

