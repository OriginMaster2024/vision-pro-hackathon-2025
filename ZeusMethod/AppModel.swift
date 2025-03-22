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
    var punchStatus = PunchStatus.waiting
}
