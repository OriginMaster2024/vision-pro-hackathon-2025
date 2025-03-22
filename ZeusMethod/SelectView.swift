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
                Button(action: {
                    // Close Immersive Space
                }, label: {
                    HStack {
                        Image(systemName: "door.right.hand.open")
                        Text("道場を出る")
                    }
                })
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
        
        appModel.spheres = stars
        appModel.starIndexToShoot = 0
        appModel.starPositions = []
    }
}

#Preview(windowStyle: .automatic) {
    SelectView()
        .environment(AppModel())
}
