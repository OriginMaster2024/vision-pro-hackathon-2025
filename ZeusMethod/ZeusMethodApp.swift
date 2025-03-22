//
//  ZeusMethodApp.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI

@main
struct ZeusMethodApp: App {
    
    @State private var appModel = AppModel()
    @State private var avPlayerViewModel = AVPlayerViewModel()
    
    var body: some Scene {
        WindowGroup() {
            if appModel.immersiveSpaceState == .closed {
                ContentView().environment(appModel)
            } else if appModel.immersiveSpaceState == .open {
                switch (appModel.gameState) {
                case .select:
                    SelectView().environment(appModel)
                case .finished:
                    ResultView(
                        score: ScoreCalculator.calculateScore(
                            correctStarPositions: appModel.correctStarPositions,
                            userStarPositions: appModel.starPositions
                        ),
                        zeusMessage: "神を舐めるな。"
                    ).environment(appModel)
                default:
                    EmptyView()
                }
            }
        }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    avPlayerViewModel.play()
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    avPlayerViewModel.reset()
                }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
