//
//  ResultView.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import SwiftUI

struct ResultView: View {
    var score: Int
    var zeusMessage: String
    
    var body: some View {
        Text("あなたのスコアは...\(score)！")
        Text("ゼウスからの一言")
        Text(zeusMessage)
    }
}
