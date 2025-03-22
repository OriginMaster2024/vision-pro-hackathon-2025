//
//  Position.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import Foundation

struct Position: Identifiable {
    internal init(simd3: SIMD3<Float>) {
        self.simd3 = simd3
    }
    
    init(x: Float, y: Float, z: Float) {
        self.simd3 = .init(x: x, y: y, z: z)
    }
    
    let id: UUID = UUID()
    let simd3: SIMD3<Float>
}
