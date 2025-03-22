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
    
    enum Event {
        case onShoot(destination: SIMD3<Float>)
    }
    
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    var spheres: [Entity] = []
    var starIndexToShoot: Int = 0

    // パンチの状態
    var lastPunchedAt: Date?
    
    // 加速度計算のための直前2回のposition
    var prevPositions: [SIMD3<Float>] = []
    
    // 音響
    var beamAudio: AudioFileResource?
    var explosionAudio: AudioFileResource?
    
    enum GameState {
        case notStarted
        case inProgress
        case finished
    }
    var gameState = GameState.notStarted
    
    /// 正しい星の位置情報のリスト
    let correctStarPositions: [Position] = [
        .init(x: -2, y: 8, z: -10),
        .init(x: 1, y: 8, z: -10),
        .init(x: 0, y: 6, z: -10),
        .init(x: 2, y: 4, z: -10),
        .init(x: 1, y: 2, z: -10),
    ]
    /// 星のノード間に引く線分のリスト
    /// indexで指定する
    let indexedLines: [IndexedLine] = [
        .init(headIndex: 0, tailIndex: 1),
        .init(headIndex: 1, tailIndex: 2),
        .init(headIndex: 2, tailIndex: 3),
        .init(headIndex: 3, tailIndex: 4),
    ]
    
    /// 正しい星座の線分のリスト
    var correctLines: [LineSegment] {
        indexedLines.compactMap { indexedLine in
            guard let head = correctStarPositions.get(indexedLine.headIndex),
                  let tail = correctStarPositions.get(indexedLine.tailIndex)
            else {
                return nil
            }
            return LineSegment(head: head.simd3, tail: tail.simd3)
        }
    }
    /// パンチによって指定された星の位置情報のリスト
    var starPositions: [Position] = []
    /// パンチによる星座の線分のリスト
    var lines: [LineSegment] {
        indexedLines.compactMap { indexedLine in
            guard let head = starPositions.get(indexedLine.headIndex),
                  let tail = starPositions.get(indexedLine.tailIndex)
            else {
                return nil
            }
            return LineSegment(head: head.simd3, tail: tail.simd3)
        }
    }
}

extension AppModel {
    func dispatch(_ event: Event) {
        switch event {
        case .onShoot(destination: let destination):
            starPositions.append(Position(simd3: destination))
        }
    }
}
