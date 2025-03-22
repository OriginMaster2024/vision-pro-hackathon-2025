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
    
    @State private var starIndexToShoot: Int = 0

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        }

        RealityView { content in
            appModel.spheres.forEach {
                content.add($0)
            }
        }
        .gesture(TapGesture().onEnded {
            Shooter.shoot(entity: appModel.spheres[self.starIndexToShoot], to: SIMD3(0, 2, -10))
            self.starIndexToShoot += 1
        })
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
