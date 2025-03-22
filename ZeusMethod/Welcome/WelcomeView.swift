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
                .aspectRatio(contentMode: .fit)
            VStack(spacing: 88) {
                VStack(spacing: 32) {
                    Text("天空道場")
                        .font(.system(size: 80))
                    Text("拳で覚える星座ドリル")
                        .font(.system(size: 40))
                }
                
                Button(action: {
                    print("Enter Immersive Space")
                }, label: {
                    Text("門を叩く")
                        .font(.system(size: 32))
                        .frame(width: 320, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                })
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    WelcomeView()
}
