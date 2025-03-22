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
        VStack {
            Text("あなたのスコアは...")
            Text("\(score)")
                .font(.system(size: 60, weight: .bold))
            Spacer()
            Text("ゼウスからの一言")
            Text(zeusMessage)
                .font(.system(size: 30))
        }
    }
}
