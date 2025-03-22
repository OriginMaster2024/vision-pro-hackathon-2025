//
//  MoveConstellationView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/23.
//

import SwiftUI

struct MoveConstellationView: View {
    let positions: [Position] = [
        .init(x: 2, y: 2, z: 0),
        .init(x: 2, y: 1, z: 0),
    ]
    var center: SIMD3<Float> {
        let sum = positions
            .map { $0.simd3 }
            .reduce(SIMD3<Float>(repeating: 0), +)
        return sum / Float(positions.count)
    }
    let targetCenter: SIMD3<Float> = .init(x: 0, y: 5, z: -10)
    
    var quaternion: simd_quatf {
        rotationQuaternion(from: center, to: targetCenter)
    }
    var roated: SIMD3<Float> {
        quaternion.act(.init(x: 2, y: 2, z: 0))
    }
    
    var body: some View {
        ZStack {
            ForEach(positions) { position in
                GlowingSphereView(position: position.simd3)
                    .frame(depth: 0)
            }
            SphereView(position: center, radius: 0.1)
                .frame(depth: 0)
            
            SphereView(position: targetCenter, radius: 0.1)
                .frame(depth: 0)
            
            GlowingSphereView(position: roated)
                .frame(depth: 0)
        }
    }
    
    func rotationQuaternion(from a: SIMD3<Float>, to b: SIMD3<Float>) -> simd_quatf {
        let normA = simd_normalize(a)
        let normB = simd_normalize(b)
        
        let dot = simd_dot(normA, normB)
        
        // 並進方向 or 反対方向のチェック
        if dot > 0.9999 {
            // 同じ方向（回転なし）
            return simd_quatf(angle: 0, axis: SIMD3<Float>(1, 0, 0))
        } else if dot < -0.9999 {
            // 真逆の方向 → 任意の垂直軸で180度回転
            let arbitrary = abs(normA.x) < 0.9 ? SIMD3<Float>(1, 0, 0) : SIMD3<Float>(0, 1, 0)
            let axis = simd_normalize(simd_cross(normA, arbitrary))
            return simd_quatf(angle: .pi, axis: axis)
        }
        
        // 通常のケース
        let axis = simd_normalize(simd_cross(normA, normB))
        let angle = acos(simd_clamp(dot, -1, 1))
        return simd_quatf(angle: angle, axis: axis)
    }
}

#Preview(immersionStyle: .full) {
    MoveConstellationView()
}
