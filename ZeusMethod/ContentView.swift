//
//  ContentView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
