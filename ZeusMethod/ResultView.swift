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

    private let zeusVoice: ZeusVoice = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("評価: \(appModel.gameResult.rawValue)").fontKaiseiDecol(size: 60)
                .padding(.bottom, 80)
            Text(appModel.zeusMessage).fontKaiseiDecol(size: 60)
            Text("ゼウス師範より").fontKaiseiDecol(size: 24)
                .padding(.leading, 300)
            HStack(spacing: 20) {
                Button("もう1回やる") {
                    Task {
                        appModel.gameState = .select
                    }
                }
                Button("コースを選ぶ") {
                    Task {
                        appModel.gameState = .select
                    }
                }
            }.padding(.top, 40)
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                zeusVoice.speech(text: appModel.zeusMessage)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ResultView()
        .environment(AppModel())
}
