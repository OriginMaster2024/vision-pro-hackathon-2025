//
//  Positions+converting.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/23.
//

import Foundation

extension Array<Position> {
    func converting(to center: SIMD3<Float>, angleScale: Float) -> [Position] {
        PositionConverter.converting(
            positions: self.map { $0.simd3 },
            targetCenter: center,
            angleScale: angleScale
        )
        .map { Position(simd3: $0) }
    }
}
