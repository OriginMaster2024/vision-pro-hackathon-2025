//
//  ResultView.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import SwiftUI

struct ResultView: View {
    var score: Int
    var zeusMessage: String
    
    private let zeusVoice: ZeusVoice = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("あなたのスコアは...")
            Text("\(score)")
                .font(.system(size: 60, weight: .bold))
            Text("ゼウスからの一言")
            Text(zeusMessage)
                .font(.system(size: 30))
        }
        .onAppear() {
            zeusVoice.speech(text: zeusMessage)
        }
    }
}
