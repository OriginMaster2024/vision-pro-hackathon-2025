//
//  ResultView.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import SwiftUI
import AVFoundation

struct ResultView: View {
    @Environment(AppModel.self) var appModel
    
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
            Spacer()
            Button("最初から") {
                Task {
                    appModel.gameState = .select
                }
            }
        }
        .onAppear() {
            zeusVoice.speech(text: zeusMessage)
        }
    }
}
