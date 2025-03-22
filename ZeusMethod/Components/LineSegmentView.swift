//
//  LineSegmentView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI
import RealityKit

struct LineSegmentView: View {
    let head: SIMD3<Float>
    let tail: SIMD3<Float>
    
    var body: some View {
        RealityView { content in
            let line = createLine(from: head, to: tail, color: .white)
            content.add(line)
        }
        .frame(depth: 0)
    }
    
    func createLine(from start: SIMD3<Float>, to end: SIMD3<Float>, color: UIColor) -> ModelEntity {
        let vector = end - start // 2点間のベクトル
        let length = simd_length(vector) // 距離（線の長さ）
        
        // 線（細長いボックス）の作成
        let line = ModelEntity(
            mesh: .generateBox(size: SIMD3(0.01, 0.01, length)), // 幅0.5cmのボックス
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
        
        // 位置を2点の中間に設定
        line.position = (start + end) / 2.0
        
        // 方向を調整（線を2点間に向ける）
        let axis = normalize(vector) // 方向ベクトル
        let quaternion = simd_quatf(from: [0, 0, 1], to: axis) // Z軸からターゲットへ回転
        line.orientation = quaternion
        
        return line
    }
}

#Preview {
    LineSegmentView(head: .init(x: -2, y: 2, z: -1), tail: .init(x: 2, y: 2, z: -1))
}
