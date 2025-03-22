//
//  GlowingSphereView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct GlowingSphereView: View {
    let position: SIMD3<Float>
    
    var body: some View {
        RealityView { content in
            if let entity = try? await Entity(named: "GlowingSphere", in: realityKitContentBundle) {
                entity.position = position
                entity.scale = .init(repeating: 0.5)
                content.add(entity)
            }
        }
        .frame(depth: 0)
    }
}

#Preview {
    GlowingSphereView(position: .init(x: 0, y: 1, z: -1))
}
