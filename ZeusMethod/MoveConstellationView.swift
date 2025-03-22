//
//  MoveConstellationView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/23.
//

import SwiftUI

struct MoveConstellationView: View {
    let positions: [Position] = [
        .init(x: 40, y: 10, z: 0),
        .init(x: 40, y: 0, z: 0),
        .init(x: 40, y: 5, z: 5),
    ]
    
    /*
    let positions: [Position] = [
        .init(x: 25.618933609339972, y: 1.0253984980616253, z: 42.92573585438465),
        .init(x: 27.14012418116607, y: 4.847405526317356, z: 41.712304169085556),
        .init(x: 23.711516090525105, y: 5.989845823429629, z: 43.610615126369304),
        .init(x: 23.102241038294526, y: 9.078097685726759, z: 43.403624288957054),
        .init(x: 19.47120334396341, y: 10.615456888791993, z: 44.81276955712765),
    ]
    
    let positions: [Position] = [
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
     */
    
    var center: SIMD3<Float> {
        let sum = positions
            .map { $0.simd3 }
            .reduce(SIMD3<Float>(repeating: 0), +)
        return sum / Float(positions.count)
    }
    let targetCenter: SIMD3<Float> = .init(x: 0, y: 25, z: -50)
    
    var quaternion: simd_quatf {
        rotationQuaternion(from: center, to: targetCenter)
    }
    var roatedPositions: [Position] {
        positions
            .map { $0.simd3 }
            .map { quaternion.act($0) }
            .map { Position(simd3: $0) }
    }
    
    var roatedAndscaledPositions: [Position] {
        scaleAnglesAroundCenter(
            positions: roatedPositions.map { $0.simd3 },
            center: targetCenter,
            angleScale: 6
        )
        .map { Position(simd3: $0) }
    }
    
    var body: some View {
        ZStack {
            ForEach(positions) { position in
                GlowingSphereView(position: position.simd3, scale: 1)
                    .frame(depth: 0)
            }
            SphereView(position: center, radius: 0.5)
                .frame(depth: 0)
            
            SphereView(position: targetCenter, radius: 0.5)
                .frame(depth: 0)
            
            ForEach(roatedPositions) { position in
                GlowingSphereView(position: position.simd3, scale: 1)
                    .frame(depth: 0)
            }
            
            ForEach(roatedAndscaledPositions) { position in
                GlowingSphereView(position: position.simd3, scale: 3)
                    .frame(depth: 0)
            }
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
    
    /*
     方針（正味よくわからん）
     各 p に対して、center → p のベクトル（差分）を取る
     そのベクトルを、center の方向を軸として、中心（center）を原点とする回転を行う
     回転の角度は、center ベクトルとのなす角を測って、それを 1.2 倍にする
     */
    
    func scaleAnglesAroundCenter(positions: [SIMD3<Float>], center: SIMD3<Float>, angleScale: Float) -> [SIMD3<Float>] {
        return positions.map { point in
            let v = point - center
            let dir = simd_normalize(center)
            let vNorm = simd_normalize(v)
            
            let dot = simd_clamp(simd_dot(dir, vNorm), -1, 1)
            let angle = acos(dot)
            
            // 回転軸（centerとvの外積）
            var axis = simd_cross(dir, vNorm)
            let axisLength = simd_length(axis)
            
            if axisLength < 1e-6 {
                // 同一線上の場合は回転不要または反対方向に180度（無視してもOK）
                return point
            }
            
            axis = simd_normalize(axis)
            let deltaAngle = angle * (angleScale - 1.0)
            
            let q = simd_quatf(angle: deltaAngle, axis: axis)
            let rotatedV = q.act(v)
            return center + rotatedV
        }
    }
}

#Preview(immersionStyle: .full) {
    MoveConstellationView()
}
