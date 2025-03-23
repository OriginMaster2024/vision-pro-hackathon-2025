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
        case select
        case inProgress
        case finished
    }
    var gameState = GameState.select
    
    var correctStarPositions: [Position] = []
    var guideNodes: [Entity] = []
    
    /// 星のノード間に引く線分のリスト
    /// indexで指定する
    var indexedLines: [IndexedLine] = []
        
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
    
    enum GameResult: String {
        case huka = "不可"
        case ka = "可"
        case ryou = "良"
        case yuu = "優"
    }
    
    var gameResult: GameResult = .huka
    var zeusMessage: String = "hoge"
 
    var showsBackgroundConstellations: Bool {
        switch gameState {
        case .select: true
        case .inProgress: false
        case .finished: false
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
