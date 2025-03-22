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
            Spacer()
            Button("Start!") {
                Task {
                    await generateStars(count: 5);
                }
            }
        }
    }
    
    private func generateStars(count: Int) async {
        var stars: [Entity] = []

        for i in 0..<count {
            if let star = try? await Entity(named: "Sphere", in: realityKitContentBundle) {
                stars.append(star)
                print("Generated \(i+1)th star.")
            }
        }
        
        appModel.spheres = stars
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
