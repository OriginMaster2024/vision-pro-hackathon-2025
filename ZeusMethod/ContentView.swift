//
//  ContentView.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) var appModel

    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
            Button("Start!") {
                Task {
                    await generateStars(count: 5);
                }
            }
        }
    }
    
    private func generateStars(count: Int) async {
        for i in 0..<count {
            if let sphere = try? await Entity(named: "Sphere", in: realityKitContentBundle) {
                sphere.position = [0, 1, -1]
                appModel.spheres.append(sphere)
                print("Generated \(i+1)th star.")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
