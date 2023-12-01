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
    public var verticalSpacing: CGFloat = 6
    
    public var body: some View {
        
        VStack(alignment: .trailing) {
            GeometryReader { proxy in
                calculateViewPosition(g: proxy)
            }
        }
    }
    
    // previousWidth는 결국엔 배치는 이전에 배치한 View의 width를 계산한 좌표로 해야하기 때문에 사용한다.
    private func calculateViewPosition(g: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        // 문제점 다음줄로 보내는 코드가 애매하다
        return ZStack(alignment: .topLeading) {
            ForEach(Array(features.data.enumerated()), id: \.offset) { index, item in
                features.content(item)
                    .alignmentGuide(.leading) { d in
                        
                        if abs(width) + d.width > g.size.width {
//                            print("idx -> \(index)")
//                            print("사이즈 머야 -> \(width)")
//
                            /// 이제 해당 width에 더이상 배치할 수 없을 경우, 맨 처음에 붙어야 하므로 width를 0으로 바꿔준다
                            width = 0
                            height -= d.height
                            height -= verticalSpacing
                        }
                        
                        var result: CGFloat = width
                        
                        /// 현재 문제점 발생
                        /// 1. ViewBuilder에 의해 데이터는 만약에 3개일 경우, 3번 호출될 것 같지만 3번만 호출되는게 아니라 여러번 호출됨
                        /// 그로 인해서 x좌표값이 문제가 생겨버림
                        /// 어차피 다시 그려질 때 index가 0부터 돌거니까 0때 초기화 하는 코드를 넣는다
                        if index == 0 {
                            
                            /// 초기화 코드
                            width = -d.width
                        } else {
                            width -= d.width
                        }
                        
                        width -= horizentalSpacing
                        
                        /// 이러면 여기서 발생한 문제점 index가 1일땐 자기 자신의 사이즈로 배치해버리는데
                        /// 그러면 이상해지니까 초기화되는 지역변수를 하나 둬서 계산한다
                    
                        /// index가 0일때, 다음 index1은 index0의 사이즈 뒤에 배치되어야 하므로 명시적으로 얻을 수 있는 좌표값이 없으므로 처리해준다
                        if width == 0 || index == 0 {
                            result = 0
                            height = 0
                        } else {
                            print("result -> \(result)")
                        }
                        
                        return result
                        
                    }
                    .alignmentGuide(.top) { d in
                        
                        return height
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

