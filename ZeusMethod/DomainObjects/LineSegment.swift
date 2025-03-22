//
//  LineSegment.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import Foundation

struct LineSegment: Identifiable {
    let id: UUID = UUID()
    let head: SIMD3<Float>
    let tail: SIMD3<Float>
}
