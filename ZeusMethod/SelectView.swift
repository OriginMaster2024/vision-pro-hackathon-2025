//
//  SelectView.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SelectView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack {
            Text("コースを選ぶ").fontKaiseiDecol(size: 70)
            HStack(spacing: 40) {
                CourseButton(level: "初級", constellation: "カシオペア座") {
                    Task {
                        await selectCourse()
                    }
                }
                CourseButton(level: "中級", constellation: "はくちょう座") {
                    Task {
                        await selectCourse()
                    }
                }
                CourseButton(level: "上級", constellation: "オリオン座") {
                    Task {
                        await selectCourse()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                DismissImmersiveSpaceButton()
            }
        }
    }
    
    struct CourseButton: View {
        let level: String
        let constellation: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 20) {
                    Text(level).fontKaiseiDecol(size: 50)
                    Text(constellation).fontKaiseiDecol(size: 24)
                }
                .frame(width: 250, height: 230)
            }
            .buttonBorderShape(.roundedRectangle(radius: 40))
        }
        
    }
    
    private struct DismissImmersiveSpaceButton: View {
        @Environment(AppModel.self) private var appModel
        @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
        
        var body: some View {
            Button {
                Task {
                    appModel.immersiveSpaceState = .inTransition
                    await dismissImmersiveSpace()
                }
            } label: {
                HStack {
                    Image(systemName: "door.right.hand.open")
                    Text("道場を出る")
                }
            }
            .animation(.none, value: 0)
        }
    }
    
    private func selectCourse() async {
        await generateStars(count: 5);
        appModel.gameState = .inProgress
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
    SelectView()
        .environment(AppModel())
}
