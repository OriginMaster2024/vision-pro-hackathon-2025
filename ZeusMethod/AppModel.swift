//
//  AppModel.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    var spheres: [Entity] = []
    
    // パンチの状態
    var punchStatus = PunchStatus.active // 誤作動を防ぐため、最初はアクティブにしておく
    
    // 加速度計算のための直前2回のposition
    var prevPositions: [SIMD3<Float>] = []

    enum GameState {
        case notStarted
        case inProgress
        case finished
    }
    var gameState = GameState.notStarted
}
