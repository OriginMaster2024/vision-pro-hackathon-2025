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
    private let beamSpeaker = Entity()
    private let backgroundSpeaker = Entity()

    @Environment(AppModel.self) var appModel
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack {
//            Button("Shoot") {
//                appModel.spheres.forEach { sphere in
//                    shootStar(star: sphere, destination: [0, 2, -10])
//                }
//            }
            RealityView { content in
                // Add the initial RealityKit content
                if let immersiveContentEntity = try? await Entity(named: "CelestialSphere", in: realityKitContentBundle) {
                    content.add(immersiveContentEntity)
                }
            }.frame(depth: 0)
            
            if appModel.showsBackgroundConstellations {
                RealityView { content in
                    if let linesEntity = try? await Entity(named: "ConstellationLines-02", in: realityKitContentBundle) {
                        content.add(linesEntity)
                    }
                    if let starsEntity = try? await Entity(named: "ConstellationStars-04", in: realityKitContentBundle) {
                        content.add(starsEntity)
                    }
                }.frame(depth: 0)
            }
            
            ForEach(appModel.spheres, id: \.self) { sphere in
                RealityView { content, attachments in
                    sphere.spatialAudio = SpatialAudioComponent(directivity: .beam(focus: 0.75))
                    content.add(sphere)

                    if let attachment = attachments.entity(for: "tag") {
                        attachment.setPosition([0, (-3-sphere.scale.y) / 6, 0], relativeTo: nil)
                        sphere.addChild(attachment)
                    }
                } attachments: {
                    Attachment(id: "tag") {
                        VStack {
                            Text(sphere.name)
                                .padding(.all, 15)
                                .font(.system(size: 100.0))
                                .bold()
                        }
                        .tag("tag")
                    }
                }.frame(depth: 0)
            }
            
            handTrackerView.frame(depth: 0)
            
            constellationView.frame(depth: 0)
            
            RealityView { content in
                beamSpeaker.position = SIMD3(0, 1, -1)
                beamSpeaker.spatialAudio = SpatialAudioComponent(directivity: .beam(focus: 0.75))
                content.add(beamSpeaker)
            }
            .task {
                let configuration = AudioFileResource.Configuration.init()
                if let audio = try? await AudioFileResource.load(named: "Beam", configuration: configuration) {
                    appModel.beamAudio = audio
                }
                if let audio = try? await AudioFileResource.load(named: "Explosion", configuration: configuration) {
                    appModel.explosionAudio = audio
                }
            }
            .frame(depth: 0)
            
            RealityView { content in
                backgroundSpeaker.position = SIMD3(0, 2, 0)
                backgroundSpeaker.spatialAudio = SpatialAudioComponent()
                content.add(backgroundSpeaker)
            }
            .task {
                let configuration = AudioFileResource.Configuration.init()
                if let audio = try? await AudioFileResource.load(named: "Background", configuration: configuration) {
                    backgroundSpeaker.playAudio(audio)
                }
            }
            .frame(depth: 0)
        }
    }

    var handTrackerView: some View {
        RealityView { content in
            // トラックボール
            content.add(handTrackerRootEntity)
            for chirality in [HandAnchor.Chirality.left, .right] {
                for jointName in HandSkeleton.JointName.allCases {
                    let jointEntity = ModelEntity(mesh: .generateSphere(radius: 0.00000000001),
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
            sphere.position = .init(x: 0, y: -100, z: 100)
            sphere.name = "trackerSphere"
            handTrackerRootEntity.addChild(sphere)
        }
        .task { try? await session.run([provider]) }
        .task {
            // 手の座標が更新されるたびにトラックボールとポインタを更新
            for await update in provider.anchorUpdates {
                let handAnchor = update.anchor
                
                var wristPosition: SIMD3<Float>?
                var knucklePosition: SIMD3<Float>?
                var fingerPosition: SIMD3<Float>?
                
                for jointName in HandSkeleton.JointName.allCases {
                    guard let joint = handAnchor.handSkeleton?.joint(jointName),
                          let jointEntity = handTrackerRootEntity.findEntity(named: "\(jointName)\(handAnchor.chirality)") else {
                        continue
                    }
                    jointEntity.setTransformMatrix(handAnchor.originFromAnchorTransform * joint.anchorFromJointTransform,
                                                   relativeTo: nil)
                    
                    if handAnchor.chirality == .right {
                        // 手首
                        if jointName == .wrist {
                            wristPosition = jointEntity.position
                        }
                        // 中指の根元
                        if jointName == .middleFingerKnuckle {
                            knucklePosition = jointEntity.position
                        }
                        // 中指の関節
                        if jointName == .middleFingerIntermediateBase {
                            fingerPosition = jointEntity.position
                        }
                    }
                }
                
                guard let wristPosition = wristPosition, let knucklePosition = knucklePosition, let fingerPosition = fingerPosition, let tracker = handTrackerRootEntity.findEntity(named: "trackerSphere") else {
                    continue
                }
                
                var currentSphere: Entity?
                if appModel.starIndexToShoot < appModel.spheres.count {
                    currentSphere = appModel.spheres[appModel.starIndexToShoot]
                    
                    let spherePosition = (fingerPosition - wristPosition) * 2 + wristPosition
                    currentSphere?.setPosition(spherePosition, relativeTo: nil)
                }
                
                let destinations = findLineAndSphereIntersection(point1: wristPosition, point2: fingerPosition, sphereCenter: SIMD3<Float>.zero, radius: 50)
                
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
                    if a < -0.003 {
                        if appModel.lastPunchedAt == nil || Date().timeIntervalSince(appModel.lastPunchedAt!) > 1.0 {
                            guard let currentSphere else { continue }

                            appModel.lastPunchedAt = Date()
                            shootStar(star: currentSphere, destination: destination)
                            
                            print("Punched! from: \(wristPosition), to: \(destination)")
                        }
                    }
                }
            }
        }
    }
    
    var constellationView: some View {
        ZStack {
            ForEach(appModel.guideNodes, id: \.self) { node in
                RealityView { content in
                    content.add(node)
                }.frame(depth: 0)
            }
            
            ForEach(appModel.correctLines) { line in
                LineSegmentView(head: line.head, tail: line.tail, size: 0.1)
                    .frame(depth: 0)
            }
            
            ForEach(appModel.starPositions) { position in
                GlowingSphereView(position: position.simd3, scale: 2)
                    .frame(depth: 0)
            }
            ForEach(appModel.lines) { line in
                LineSegmentView(head: line.head, tail: line.tail, size: 0.2)
                    .frame(depth: 0)
            }
        }
    }
        
    private func shootStar(star: Entity, destination: SIMD3<Float>) {
        Shooter.shoot(entity: star, scale: star.scale, to: destination)
        appModel.starIndexToShoot += 1

        appModel.guideNodes[appModel.starIndexToShoot - 1].scale = .init(repeating: 1)
        if appModel.starIndexToShoot < appModel.guideNodes.count {
            appModel.guideNodes[appModel.starIndexToShoot].scale = .init(repeating: 10)
        }
        
        if let audio = appModel.beamAudio {
            beamSpeaker.playAudio(audio)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("0.5秒後の処理")
            // ここでonShootを呼び出す
            appModel.dispatch(.onShoot(destination: destination))
        }
        
        if appModel.spheres.count <= appModel.starIndexToShoot {
            appModel.gameResult = ResultGenerater.getResult(correctStarPositions: appModel.correctStarPositions, userStarPositions: appModel.starPositions)
            appModel.zeusMessage = ResultGenerater.getZeusMessage(result: appModel.gameResult)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                appModel.gameState = .finished
                openWindow(id: appModel.windowId)
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
