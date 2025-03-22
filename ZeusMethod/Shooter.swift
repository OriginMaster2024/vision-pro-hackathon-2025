//
//  Shooter.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import RealityKit

class Shooter {
    private static let SHOOT_DURATION = 0.3
    
    static func shoot(entity: Entity, scale: SIMD3<Float>, to targetPosition: SIMD3<Float>) {
        entity.move(
            to: Transform(scale: scale, translation: targetPosition),
            relativeTo: nil,
            duration: SHOOT_DURATION,
            timingFunction: .easeInOut
        )
    }
}
