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
            VStack(spacing: 88) {
                VStack(spacing: 32) {
                    Text("天空道場")
                        .fontKaiseiDecol(size: 80)
                    Text("拳で覚える星座ドリル")
                        .fontKaiseiDecol(size: 40)
                }
                
                OpenGateButton()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
    
    private struct OpenGateButton: View {
        @Environment(AppModel.self) private var appModel
        @Environment(\.openImmersiveSpace) private var openImmersiveSpace

        var body: some View {
            Button {
                Task {
                    await openImmersiveSpace(id: appModel.immersiveSpaceID)
                    appModel.immersiveSpaceState = .open
                }
            } label: {
                Text("門を叩く")
                    .fontKaiseiDecol(size: 32)
                    .frame(width: 320, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
            .animation(.none, value: 0)
        }
    }
}

#Preview {
    WelcomeView()
}
