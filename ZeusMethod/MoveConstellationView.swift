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
    let targetCenter: Position = .init(x: 0, y: 5, z: -10)
    
    var body: some View {
        ZStack {
            ForEach(positions) { position in
                GlowingSphereView(position: position.simd3)
                    .frame(depth: 0)
            }
            SphereView(position: center, radius: 0.1)
                .frame(depth: 0)
            
            SphereView(position: targetCenter.simd3, radius: 0.1)
                .frame(depth: 0)
        }
    }
}

#Preview(immersionStyle: .full) {
    MoveConstellationView()
}
