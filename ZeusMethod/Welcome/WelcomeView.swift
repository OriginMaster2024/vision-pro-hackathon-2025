//
//  WelcomeView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image(.welcomeBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Text("天空道場")
                    .font(.system(size: 80))
                Text("拳で覚える星座ドリル")
                    .font(.system(size: 40))
            }
        }
    }
}

#Preview {
    WelcomeView()
}
