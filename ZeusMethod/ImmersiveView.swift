//
//  ImmersiveView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import RealityKit
import RealityKitContent
import SwiftUI
import ARKit


enum PunchStatus {
    case waiting
    case active
}

struct ImmersiveView: View {
    private let session = ARKitSession()
    private let provider = HandTrackingProvider()
    private let handTrackerRootEntity = Entity()

    @Environment(AppModel.self) var appModel
    
    @State private var starIndexToShoot: Int = 0

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "SkyDome", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        }
        
        ForEach(appModel.spheres, id: \.self) { sphere in
            RealityView { content in
                sphere.position = [0, 1, -1]
                content.add(sphere)
            }
//            .gesture(TapGesture().onEnded {
//                Shooter.shoot(entity: sphere, to: SIMD3(0, 2, -10))
//            })
        }
        
        handTrackerView
    }

    var handTrackerView: some View {
        RealityView { content in
            // トラックボール
            content.add(handTrackerRootEntity)
            for chirality in [HandAnchor.Chirality.left, .right] {
                for jointName in HandSkeleton.JointName.allCases {
                    let jointEntity = ModelEntity(mesh: .generateSphere(radius: 0.006),
                                                  materials: [SimpleMaterial()])
                    jointEntity.name = "\(jointName)\(chirality)"
                    handTrackerRootEntity.addChild(jointEntity)
                }
            }
            
            // 向き先を示すポインタ
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )
            sphere.position = .init(x: 1, y: 2, z: -4)
            sphere.name = "trackerSphere"
            handTrackerRootEntity.addChild(sphere)
        }
        .task { try? await session.run([provider]) }
        .task {
            // 手の座標が更新されるたびにトラックボールとポインタを更新
            for await update in provider.anchorUpdates {
                let handAnchor = update.anchor
                
                var wristPosition: SIMD3<Float>?
                var fingerPosition: SIMD3<Float>?
                
                for jointName in HandSkeleton.JointName.allCases {
                    guard let joint = handAnchor.handSkeleton?.joint(jointName),
                          let jointEntity = handTrackerRootEntity.findEntity(named: "\(jointName)\(handAnchor.chirality)") else {
                        continue
                    }
                    jointEntity.setTransformMatrix(handAnchor.originFromAnchorTransform * joint.anchorFromJointTransform,
                                                   relativeTo: nil)
                    
                    if handAnchor.chirality == .right {
                        // 手首の座標
                        if jointName == .wrist {
                            wristPosition = jointEntity.position
                        }
                        // 中指の根元の座標
                        if jointName == .middleFingerKnuckle {
                            fingerPosition = jointEntity.position
                        }
                    }
                }
                
                guard let wristPosition = wristPosition, let fingerPosition = fingerPosition, let tracker = handTrackerRootEntity.findEntity(named: "trackerSphere") else {
                    continue
                }
                
                let destinations = findLineAndSphereIntersection(point1: wristPosition, point2: fingerPosition, sphereCenter: SIMD3<Float>.zero, radius: 10)
                
                // 交点のうち奥のものを取得
                var destination: SIMD3<Float>?
                for d in destinations {
                    if d.z < 0 {
                        destination = d
                    }
                }
                
                
                guard let destination = destination else {
                    continue;
                }
                
                tracker.setPosition(destination, relativeTo: nil)
                
                // 加速度計算
                appModel.prevPositions.append(wristPosition)
                if appModel.prevPositions.count > 3 {
                    appModel.prevPositions = Array(appModel.prevPositions.dropFirst(
                        appModel.prevPositions.count - 3
                    ))
                }
                if appModel.prevPositions.count == 3 {
                    let v1 = appModel.prevPositions[0] - appModel.prevPositions[1]
                    let v2 = appModel.prevPositions[1] - appModel.prevPositions[2]
                    
                    let a = v2.z - v1.z
                    
                    // ボールを飛ばす
                    if appModel.punchStatus == .waiting {
                        if a < -0.003 {
                            print("Punched! from: \(wristPosition), to: \(destination)")
                            appModel.punchStatus = .active
                            if self.starIndexToShoot < 5 {
                                Shooter.shoot(entity: appModel.spheres[self.starIndexToShoot], to: destination)
                                self.starIndexToShoot += 1
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    print("0.5秒後の処理")
                                    // ここでonShootを呼び出す
                                }
                            }
                        }
                    }
                    if appModel.punchStatus == .active {
                        if a > -0.0001 {
                            appModel.punchStatus = .waiting
                        }
                    }
                }
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
