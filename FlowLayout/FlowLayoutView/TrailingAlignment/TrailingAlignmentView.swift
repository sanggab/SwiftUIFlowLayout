//
//  TrailingAlignmentView.swift
//  FlowLayout
//
//  Created by Gab on 2023/12/05.
//

import SwiftUI

public struct TrailingAlignmentView<FlowFeatures: FlowLayoutFeatures>: View {
    @State private var frameSize: CGSize = CGSize(width: 0, height: 0)
    
    public var features: FlowFeatures
    
    public var body: some View {
        HStack {
            
            ZStack(alignment: .topTrailing) {
                var width: CGFloat = 0
                var height: CGFloat = 0
                
                ForEach(Array(features.data.enumerated()), id: \.offset) { index, item in
                    features.content(item)
                        .alignmentGuide(.trailing) { d in

                            if abs(width) + d.width > frameSize.width {
                                width = 0
                                height -= d.height
                                height -= features.lineSpacing
                            }
                            
                            if index == 0 {
                                width = d.width
                                height = 0
                            } else {
                                width += d.width
                            }
                            
                            width += features.dataSpacing

                            return width

                        }
                        .alignmentGuide(.top) { d in

                            return height
                        }

                }
            }
            .frame(width: frameSize.width, alignment: .topTrailing)
            
        }
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        .overlay(
            GeometryReader { proxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { size in
            print("몇 번을 그리는거야")
            frameSize = size
        }
    }
}

//struct RightAlignmnetView_Previews: PreviewProvider {
//    static var previews: some View {
//        RightAlignmnetView()
//    }
//}
