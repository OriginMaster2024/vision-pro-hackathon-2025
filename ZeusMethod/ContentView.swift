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
            Spacer()
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
                Button("Restart!") {
                    Task {
                        await generateStars(count: 5);
                        appModel.gameState = .inProgress
                    }
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
        }
    }
    
    private func generateStars(count: Int) async {
        var stars: [Entity] = []

        for i in 0..<count {
            if let star = try? await Entity(named: "GlowingSphere", in: realityKitContentBundle) {
                    star.position = [0, -10, 0]
                    star.scale = .init(repeating: 0.1)
                    stars.append(star)
                    print("Generated \(i+1)th star.")
            }
        }
        
        let correctStarPositions: [Position] = [
            .init(x: -2, y: 8, z: -50),
            .init(x: 1, y: 8, z: -50),
            .init(x: 0, y: 6, z: -50),
            .init(x: 2, y: 4, z: -50),
            .init(x: 1, y: 2, z: -50),
        ]
        
        var guideNodes: [Entity] = []
        for i in 0..<count {
            let entity = ModelEntity(
                mesh: .generateSphere(radius: 0.05),
                materials: [
                    SimpleMaterial(color: .white, isMetallic: false),
                ]
            )
            entity.position = correctStarPositions[i].simd3
            if i == 0 {
                entity.scale = .init(repeating: 3)
            }
            guideNodes.append(entity)
        }

        appModel.spheres = stars
        appModel.starIndexToShoot = 0
        appModel.correctStarPositions = correctStarPositions
        appModel.guideNodes = guideNodes
        appModel.indexedLines = [
            .init(headIndex: 0, tailIndex: 1),
            .init(headIndex: 1, tailIndex: 2),
            .init(headIndex: 2, tailIndex: 3),
            .init(headIndex: 3, tailIndex: 4),
        ]
        appModel.starPositions = []
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
