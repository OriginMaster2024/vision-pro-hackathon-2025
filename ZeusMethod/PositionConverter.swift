//
//  PositionConverter.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/23.
//

import Foundation
import simd

enum PositionConverter {
    /// positions: 動かしたい点の集合
    /// targetCenter: 動かした先の点の集合の重心方向
    static func converting(
        positions: [SIMD3<Float>],
        targetCenter: SIMD3<Float>
    ) -> [SIMD3<Float>] {
        let center: SIMD3<Float> = {
            let sum = positions
                .reduce(SIMD3<Float>(repeating: 0), +)
            return sum / Float(positions.count)
        }()
        let quaternion: simd_quatf = rotationQuaternion(from: center, to: targetCenter)
        
        let roatedPositions: [SIMD3<Float>] = positions
            .map { quaternion.act($0) }
        
        let roatedAndScaledPositions: [SIMD3<Float>] = roatedPositions
            .map { scaleAnglesAroundCenter(
                center: targetCenter,
                original: $0,
                angleScale: 2
            )}
        
        return roatedAndScaledPositions
    }
}

extension PositionConverter {
    private static func rotationQuaternion(from a: SIMD3<Float>, to b: SIMD3<Float>) -> simd_quatf {
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
    
    private static func scaleAnglesAroundCenter(
        center: SIMD3<Float>,
        original: SIMD3<Float>,
        angleScale: Float
    ) -> SIMD3<Float> {
        let angleAC = angleBetween(center, original)
        let axis = simd_cross(center, original)
        
        // ベクトルaがcと平行な場合（外積ゼロ）には回転軸が定義できないのでそのまま返す
        if simd_length(axis) < 1e-8 {
            return center  // または `-a` など適宜定義
        }
        
        let rotated = rotate(center, around: axis, by: angleScale * angleAC)
        
        // aと同じ長さにスケーリング
        let b = normalize(rotated) * simd_length(center)
        
        return b
    }
    
    private static func angleBetween(_ v1: SIMD3<Float>, _ v2: SIMD3<Float>) -> Float {
        let dot = simd_dot(simd_normalize(v1), simd_normalize(v2))
        return acos(max(-1.0, min(1.0, dot)))  // 数値誤差の対処
    }
    
    // 回転：axis を軸に、vector を angle ラジアン回転
    private static func rotate(_ vector: SIMD3<Float>, around axis: SIMD3<Float>, by angle: Float) -> SIMD3<Float> {
        let u = simd_normalize(axis)
        let cosA = cos(angle)
        let sinA = sin(angle)
        
        // Rodrigues' rotation formula
        return vector * cosA +
        simd_cross(u, vector) * sinA +
        u * simd_dot(u, vector) * (1 - cosA)
    }
}
