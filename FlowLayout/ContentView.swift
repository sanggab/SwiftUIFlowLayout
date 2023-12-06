//
//  ContentView.swift
//  FlowLayout
//
//  Created by Gab on 2023/11/28.
//

import SwiftUI

@frozen public enum FlowDirection {
    case leading
    case trailing
    case top
    case bottom
}

struct TestFlowLayout<ContentView: View>: FlowLayoutFeatures {
    typealias Element = String

    var data: [String]
//    var direction: FlowDirection
    var dataSpacing: CGFloat
    var lineSpacing: CGFloat
    var content: (String) -> ContentView

    init(data: [String],
//         direction: FlowDirection,
         dataSpacing: CGFloat = 0,
         lineSpacing: CGFloat = 0,
         @ViewBuilder content: @escaping (String) -> ContentView) {
        self.data = data
//        self.direction = direction
        self.dataSpacing = dataSpacing
        self.lineSpacing = lineSpacing
        self.content = content
    }
}

struct ContentView: View {
    
    @State var dataLists: [String] = ["음음 놀랍게도", "그건 사실이야", "어이어이 마지카요", "침범이냐?", "음", "침범맞어?", "음 침범 맞아 다음줄로 넘어가 얼른"]
    
    private var randomString = ["초코파이", "허쉬 초콜릿칩 미니쿠키", "복이많은집 미용티슈", "갤럭시 버즈", "심상갑", "카파", "이게머야 이게머야"]
    
    var body: some View {
        LeadingAlignmnetView(features: TestFlowLayout(data: dataLists,
                                                   dataSpacing: 8,
                                                   lineSpacing: 10,
                                                   content: { text in
               Text(text)
                   .padding(10)
                   .foregroundColor(.white)
                   .background(Color.yellow)
                   .opacity(0.5)
                   .cornerRadius(8)
                   .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
           }))

        TrailingAlignmentView(features: TestFlowLayout(data: dataLists,
//                                                       direction: .trailing,
                                                       dataSpacing: 10,
                                                       lineSpacing: 15,
                                                       content: { text in

            Text(text)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.yellow)
                .opacity(0.5)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
        }))
        
    }
    
    func topLeadingView() -> some View {
        return Group {
            FlowLayoutView(features: TestFlowLayout(data: dataLists,
//                                                    direction: .leading,
                                                    dataSpacing: 8,
                                                    lineSpacing: 10,
                                                    content: { text in
                Text(text)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.yellow)
                    .opacity(0.5)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
            }))
            
            Spacer()
            
            Button {
                dataLists.append(randomString.randomElement() ?? "")
            } label: {
                Text("추가시켜")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(.yellow)
                    .cornerRadius(8)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
