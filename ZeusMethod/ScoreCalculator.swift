//
//  ScoreCalculator.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import simd

class ScoreCalculator {
    private static let COEFFICIENT: Float = 0.0
    
    static func calculateScore(correctStarPositions: [Position], userStarPositions: [Position]) -> Int {
        let starCount = correctStarPositions.count
        if userStarPositions.count != starCount {
            return 0
        }
        
        let totalError: Float = zip(userStarPositions, correctStarPositions)
            .map { simd_distance($0.simd3, $1.simd3) }
            .reduce(0, +)
        let avgError: Float = totalError / Float(starCount)

        let normalizedScore: Int = Int(100 - avgError * COEFFICIENT)
        
        return max(0, normalizedScore)
    }
}
