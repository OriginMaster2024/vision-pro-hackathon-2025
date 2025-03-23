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
                        await selectCourse(course: .easy)
                    }
                }
                CourseButton(level: "中級", constellation: "はくちょう座") {
                    Task {
                        await selectCourse(course: .medium)
                    }
                }
                CourseButton(level: "上級", constellation: "オリオン座") {
                    Task {
                        await selectCourse(course: .hard)
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
    
    private func selectCourse(course: Course) async {
        await generateStars(course: course);
        appModel.gameState = .inProgress
    }
    
    private func getGuideNodePositions(course: Course) -> [Position] {
        switch (course) {
        case .easy:
            // 初級（カシオペア座）
            return  [
                .init(x: 25.618933609339972, y: 1.0253984980616253, z: 42.92573585438465),
                .init(x: 27.14012418116607, y: 4.847405526317356, z: 41.712304169085556),
                .init(x: 23.711516090525105, y: 5.989845823429629, z: 43.610615126369304),
                .init(x: 23.102241038294526, y: 9.078097685726759, z: 43.403624288957054),
                .init(x: 19.47120334396341, y: 10.615456888791993, z: 44.81276955712765),
            ]
        case .medium:
            // 中級（はくちょう座）
            return [
                .init(x: 9.848353335680766, y: -28.161145600396704, z: 40.124304542868316),
                .init(x: 11.814478151773706, y: -28.626603382524046, z: 39.25475365839053),
                .init(x: 17.02915246271813, y: -40.748698138925064, z: 23.442516212733338),
                .init(x: 15.597967407907182, y: -31.638596865205248, z: 35.43589424782293),
                .init(x: 19.88422244773133, y: -35.759158452252166, z: 28.738480899933805),
                .init(x: 22.18931415701313, y: -31.04280503873943, z: 32.31065756941803),
                .init(x: 22.782444881933955, y: -26.809113212444537, z: 35.52789965596015),
                .init(x: 27.5047841527702, y: -31.031934846135268, z: 27.9375351170202),
                .init(x: 32.22306348968696, y: -28.776270183163604, z: 25.17142136799534),
            ]
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
                .init(headIndex: 4, tailIndex: 3),
                .init(headIndex: 3, tailIndex: 2),
                .init(headIndex: 2, tailIndex: 1),
                .init(headIndex: 1, tailIndex: 0),
            ]
        case .medium:
            return [
                .init(headIndex: 0, tailIndex: 1),
                .init(headIndex: 1, tailIndex: 3),
                .init(headIndex: 3, tailIndex: 5),
                .init(headIndex: 5, tailIndex: 6),
                .init(headIndex: 5, tailIndex: 7),
                .init(headIndex: 7, tailIndex: 8),
                .init(headIndex: 5, tailIndex: 4),
                .init(headIndex: 4, tailIndex: 2),
            ]
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
    
    private func generateStars(course: Course) async {
        var stars: [Entity] = []
        
        let guideNodePositions = getGuideNodePositions(course: course)
            // FIXME: 値は要審議
            .converting(to: .init(x: 0, y: 20, z: -100), angleScale: 1)
        let guideEdges = getGuideEdges(course: course)
        
        let count = guideNodePositions.count
        
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
