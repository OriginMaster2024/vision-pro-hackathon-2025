//
//  Constellation.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import Foundation

struct Constellation {
    let starPositions: [Position]
    let indexLines: [IndexedLine]
}

struct IndexedLine {
    let headIndex: Int
    let tailIndex: Int
}
