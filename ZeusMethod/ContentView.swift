//
//  ContentView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
            Spacer()
            switch(appModel.gameState) {
            case .notStarted:
                Button("Start!") {
                    Task {
                        await generateStars(count: 5);
                        appModel.gameState = .inProgress
                    }
                }
            case .inProgress:
                Button("End!") {
                    appModel.gameState = .finished
                }
            case .finished:
                Button("Restart!") {
                    Task {
                        await generateStars(count: 5);
                        appModel.gameState = .inProgress
                    }
                }
                Spacer()
                ResultView(
                    score: ScoreCalculator.calculateScore(
                        correctStarPositions: appModel.correctStarPositions,
                        userStarPositions: appModel.starPositions
                    ),
                    zeusMessage: "神を舐めるな。"
                )
            }
            Spacer()
            Button("Reset") {
                Task {
                    await generateStars(count: 5);
                }
            }
        }
    }
    
    private func generateStars(count: Int) async {
        var stars: [Entity] = []

        for i in 0..<count {
            if let star = try? await Entity(named: "Sphere", in: realityKitContentBundle) {
                stars.append(star)
                print("Generated \(i+1)th star.")
            }
        }
        
        appModel.spheres = stars
        appModel.starIndexToShoot = 0
        appModel.starPositions = []
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
