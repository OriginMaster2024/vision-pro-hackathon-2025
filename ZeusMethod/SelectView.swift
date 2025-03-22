//
//  SelectView.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum Course {
    case easy
    case medium
    case hard
}

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
    
    private func getGuideNodePositions(course: Course) -> [Position] {
        switch (course) {
        case .easy:
            // 初級（カシオペア座）
            return  [
                .init(x: -2, y: 8, z: -50),
                .init(x: 1, y: 8, z: -50),
                .init(x: 0, y: 6, z: -50),
                .init(x: 2, y: 4, z: -50),
                .init(x: 1, y: 2, z: -50),
            ]
        case .medium:
            return []
        case .hard:
            // 上級（オリオン座）
            return [
                .init(x: 14.958391767792357, y: 47.323610412477905, z: 6.059902082480766),
                .init(x: 14.713429873393505, y: 47.53593997172674, z: 4.883583967244099),
                .init(x: 9.75260895553656, y: 48.51812954484714, z: -7.132862260678998),
                .init(x: 7.531397328899982, y: 49.119231455311116, z: 5.529842268438812),
                .init(x: 6.0919405694130155, y: 49.62680868247579, z: -0.26099825992909187),
                .init(x: 5.332249421675046, y: 48.96082362241886, z: 8.625825544226933),
                .init(x: 5.178957876708922, y: 49.72000028221735, z: -1.0487932339510766),
                .init(x: 4.190468353268116, y: 49.79525371330673, z: -1.694898996303652),
                .init(x: 2.631915649762679, y: 49.21931646411622, z: -8.398327620289189),
                .init(x: 1.044547633791461, y: 49.57176402506467, z: 6.445861593615371),
            ]
        }
    }
    
    private func getGuideEdges(course: Course) -> [IndexedLine] {
        switch (course) {
        case .easy:
            return [
                .init(headIndex: 0, tailIndex: 1),
                .init(headIndex: 1, tailIndex: 2),
                .init(headIndex: 2, tailIndex: 3),
                .init(headIndex: 3, tailIndex: 4),
            ]
        case .medium:
            return []
        case .hard:
            return [
                .init(headIndex: 7, tailIndex: 6),
                .init(headIndex: 6, tailIndex: 4),
                .init(headIndex: 9, tailIndex: 7),
                .init(headIndex: 7, tailIndex: 8),
                .init(headIndex: 8, tailIndex: 2),
                .init(headIndex: 2, tailIndex: 4),
                .init(headIndex: 4, tailIndex: 3),
                .init(headIndex: 3, tailIndex: 5),
                .init(headIndex: 5, tailIndex: 9),
                .init(headIndex: 3, tailIndex: 0),
                .init(headIndex: 0, tailIndex: 1),
            ]
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
        
        let course = Course.hard
        let guideNodePositions = getGuideNodePositions(course: course)
        let guideEdges = getGuideEdges(course: course)
        
        var guideNodes: [Entity] = []
        for i in 0..<count {
            let entity = ModelEntity(
                mesh: .generateSphere(radius: 0.05),
                materials: [
                    SimpleMaterial(color: .white, isMetallic: false),
                ]
            )
            entity.position = guideNodePositions[i].simd3
            if i == 0 {
                entity.scale = .init(repeating: 3)
            }
            guideNodes.append(entity)
        }

        appModel.spheres = stars
        appModel.starIndexToShoot = 0
        appModel.correctStarPositions = guideNodePositions
        appModel.guideNodes = guideNodes
        appModel.indexedLines = guideEdges
        appModel.starPositions = []
    }
}

#Preview(windowStyle: .automatic) {
    SelectView()
        .environment(AppModel())
}
