//
//  SphereView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import Foundation
import SwiftUI
import RealityKit

struct SphereView: View {
    let position: SIMD3<Float>
    let radius: Float
    
    var body: some View {
        RealityView { content in
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: radius),
                materials: [
                    SimpleMaterial(color: .white, isMetallic: false),
                ]
            )
            sphere.position = position
            content.add(sphere)
        }
        .frame(depth: 0)
    }
}

#Preview {
    SphereView(position: .init(x: 0, y: 1, z: -1), radius: 0.1)
}
