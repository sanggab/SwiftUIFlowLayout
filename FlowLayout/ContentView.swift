//
//  ContentView.swift
//  FlowLayout
//
//  Created by Gab on 2023/11/28.
//

import SwiftUI

struct TestFlowLayout<ContentView: View>: FlowLayoutFeatures {
    typealias Element = String

    var data: [String]
    var content: (String) -> ContentView

    init(data: [String],
         @ViewBuilder content: @escaping (String) -> ContentView) {
        self.data = data
        self.content = content
    }
}

struct ContentView: View {
    
    var body: some View {
        
        FlowLayoutView(features: TestFlowLayout(data: ["음음 놀랍게도", "그건 사실이야", "어이어이 마지카요", "침범이냐?"], content: { text in
            Text(text)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.yellow)
                .opacity(0.5)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
        }))
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
