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

struct StarMetadata {
    var name: String
    var brightness: Float
}

struct SelectView: View {
    @Environment(AppModel.self) var appModel
    
    @Environment(\.dismissWindow) private var dismissWindow
    
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
        dismissWindow(id: appModel.windowId)
    }
    
    private func getGuideNodePositions(course: Course) -> [Position] {
        switch (course) {
        case .easy:
            // 初級（カシオペア座）
            return  [
                .init(x: 19.47120334396341, y: 10.615456888791993, z: 44.81276955712765),
                .init(x: 23.102241038294526, y: 9.078097685726759, z: 43.403624288957054),
                .init(x: 23.711516090525105, y: 5.989845823429629, z: 43.610615126369304),
                .init(x: 27.14012418116607, y: 4.847405526317356, z: 41.712304169085556),
                .init(x: 25.618933609339972, y: 1.0253984980616253, z: 42.92573585438465),
            ]
        case .medium:
            // 中級（はくちょう座）
            return [
               .init(x: 17.02915246271813, y: -40.748698138925064, z: 23.442516212733338),
               .init(x: 19.88422244773133, y: -35.759158452252166, z: 28.738480899933805),
               .init(x: 22.18931415701313, y: -31.04280503873943, z: 32.31065756941803),
               .init(x: 22.782444881933955, y: -26.809113212444537, z: 35.52789965596015),
               .init(x: 36.35929766662391, y: -24.492353629819753, z: 24.044252678378093),
               .init(x: 32.22306348968696, y: -28.776270183163604, z: 25.17142136799534),
               .init(x: 27.5047841527702, y: -31.031934846135268, z: 27.9375351170202),
               .init(x: 15.597967407907182, y: -31.638596865205248, z: 35.43589424782293),
               .init(x: 11.814478151773706, y: -28.626603382524046, z: 39.25475365839053),
               .init(x: 9.848353335680766, y: -28.161145600396704, z: 40.124304542868316),
            ]
        case .hard:
            // 上級（オリオン座）
            return [
                .init(x: 1.044547633791461, y: 49.57176402506467, z: 6.445861593615371),
                .init(x: 5.332249421675046, y: 48.96082362241886, z: 8.625825544226933),
                .init(x: 7.531397328899982, y: 49.119231455311116, z: 5.529842268438812),
                .init(x: 4.190468353268116, y: 49.79525371330673, z: -1.694898996303652),
                .init(x: 5.178957876708922, y: 49.72000028221735, z: -1.0487932339510766),
                .init(x: 6.0919405694130155, y: 49.62680868247579, z: -0.26099825992909187),
                .init(x: 2.631915649762679, y: 49.21931646411622, z: -8.398327620289189),
                .init(x: 9.75260895553656, y: 48.51812954484714, z: -7.132862260678998),
                .init(x: -0.5125641976900469, y: 49.29022741800023, z: 8.37918605981898),
                .init(x: -2.5240715740355544, y: 48.404617392899254, z: 12.272818654904839),
                .init(x: -0.7098668027023569, y: 47.070936177391005, z: 16.847048896064972),
                .init(x: -1.5970888535689078, y: 48.32179230127157, z: 12.74573246175274),
                .init(x: 1.1490448046380872, y: 46.887505439059034, z: 17.327479035888153),
                .init(x: 14.958391767792357, y: 47.323610412477905, z: 6.059902082480766),
                .init(x: 14.728395275757347, y: 47.15116943263355, z: 7.735734854306458),
                .init(x: 13.79407883256237, y: 47.244759667994906, z: 8.81226832742036),
                .init(x: 14.713429873393505, y: 47.53593997172674, z: 4.883583967244099),
                .init(x: 14.316817341264057, y: 47.856458105437696, z: 2.1881861939442184),
                .init(x: 13.240676733803165, y: 48.19178161120468, z: 1.495548317132479),
            ]
        }
    }
    
    private func getStarMetadata(course: Course) -> [StarMetadata] {
        switch (course) {
        case .easy:
            return [
                .init(name: "セギン", brightness: 3.35),
                .init(name: "ルクバー", brightness: 2.66),
                .init(name: "ツィー", brightness: 2.15),
                .init(name: "シェダル", brightness: 2.24),
                .init(name: "カフ", brightness: 2.28),
            ]
        case .medium:
            return [
                .init(name: "アルビレオ", brightness: 3.05),
                .init(name: "", brightness:3.89),
                .init(name: "サドル", brightness:2.23),
                .init(name: "デネブ", brightness:1.25),
                .init(name: "", brightness:4.49),
                .init(name: "", brightness: 3.21),
                .init(name: "アルジャナー", brightness: 2.48),
                .init(name: "ファワリス", brightness: 2.86),
                .init(name: "", brightness: 3.76),
                .init(name: "", brightness: 3.8),
            ]
        case .hard:
            return [
                .init(name: "ベテルギウス", brightness: 0.45),
                .init(name: "メイサ", brightness: 3.39),
                .init(name: "ベラトリクス", brightness: 1.64),
                .init(name: "アルニタク", brightness: 1.74),
                .init(name: "アルニラム", brightness: 1.69),
                .init(name: "ミンタカ", brightness: 2.25),
                .init(name: "サイフ", brightness: 2.07),
                .init(name: "リゲル", brightness: 0.18),
                .init(name: "", brightness: 4.12),
                .init(name: "", brightness: 4.45),
                .init(name: "", brightness: 5.14),
                .init(name: "", brightness: 4.42),
                .init(name: "", brightness: 4.39),
                .init(name: "タビト", brightness: 3.19),
                .init(name: "", brightness: 4.35),
                .init(name: "", brightness: 4.64),
                .init(name: "", brightness: 3.68),
                .init(name: "", brightness: 5.33),
                .init(name: "", brightness: 4.47),
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
            return [
                .init(headIndex: 9, tailIndex: 8),
                .init(headIndex: 8, tailIndex: 7),
                .init(headIndex: 7, tailIndex: 2),
                .init(headIndex: 2, tailIndex: 3),
                .init(headIndex: 0, tailIndex: 1),
                .init(headIndex: 1, tailIndex: 2),
                .init(headIndex: 2, tailIndex: 6),
                .init(headIndex: 6, tailIndex: 5),
                .init(headIndex: 5, tailIndex: 4),
            ]
        case .hard:
            return [
                .init(headIndex: 3, tailIndex: 4),
                .init(headIndex: 4, tailIndex: 5),
                .init(headIndex: 10, tailIndex: 9),
                .init(headIndex: 9, tailIndex: 11),
                .init(headIndex: 11, tailIndex: 12),
                .init(headIndex: 9, tailIndex: 8),
                .init(headIndex: 8, tailIndex: 0),
                .init(headIndex: 0, tailIndex: 3),
                .init(headIndex: 3, tailIndex: 6),
                .init(headIndex: 6, tailIndex: 7),
                .init(headIndex: 7, tailIndex: 5),
                .init(headIndex: 5, tailIndex: 2),
                .init(headIndex: 2, tailIndex: 1),
                .init(headIndex: 1, tailIndex: 0),
                .init(headIndex: 2, tailIndex: 13),
                .init(headIndex: 13, tailIndex: 16),
                .init(headIndex: 16, tailIndex: 17),
                .init(headIndex: 17, tailIndex: 18),
                .init(headIndex: 13, tailIndex: 14),
                .init(headIndex: 14, tailIndex: 15),
                .init(headIndex: 11, tailIndex: 8),
            ]
        }
    }
    
    private func generateStars(course: Course) async {
        var stars: [Entity] = []
        
        let guideNodePositions = getGuideNodePositions(course: course)
            // FIXME: 値は要審議
            .converting(to: .init(x: 0, y: 20, z: -100), angleScale: 1)
        let guideEdges = getGuideEdges(course: course)
        
        let metadata = getStarMetadata(course: course)
        
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
                    star.position = .init(x: 0, y: -100, z: 100)
                    star.scale = .init(repeating: 0.1 * (15 / (1 + metadata[i].brightness) / (1 + metadata[i].brightness)))
                    star.name = metadata[i].name
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
        appModel.starMetadataList = metadata
    }
}

#Preview(windowStyle: .automatic) {
    SelectView()
        .environment(AppModel())
}
