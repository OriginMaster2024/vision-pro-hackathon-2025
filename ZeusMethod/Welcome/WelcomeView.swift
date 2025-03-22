//
//  WelcomeView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        ZStack {
            Image(.welcomeBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

#Preview {
    WelcomeView()
}
