//
//  ImmersiveView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel

    @State private var sphere: Entity?

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        }

        RealityView { content in
            if let sphere = try? await Entity(named: "Sphere", in: realityKitContentBundle) {
                sphere.position = [0, 1, -1]
                content.add(sphere)
                self.sphere = sphere
            }
        }
        .gesture(TapGesture().onEnded {
            guard let sphere else { return }
            Shooter.shoot(entity: sphere, to: SIMD3(0, 2, -10))
        })
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
