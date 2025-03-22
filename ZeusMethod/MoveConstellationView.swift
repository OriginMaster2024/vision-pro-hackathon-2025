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
    
    var body: some View {
        ZStack {
            ForEach(positions) { position in
                GlowingSphereView(position: position.simd3)
                    .frame(depth: 0)
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    MoveConstellationView()
}
