//
//  Array+get.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import Foundation

extension Array {
    func get(_ index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
