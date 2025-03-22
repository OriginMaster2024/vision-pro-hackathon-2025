//
//  View+fontKaiseiDecol.swift
//  ZeusMethod
//
//  Created by Akihiro Kokubo on 2025/03/22.
//

import SwiftUI

struct KaiseiDecolModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("KaiseiDecol-Bold", size: size))
    }
}

extension View {
    func fontKaiseiDecol(size: CGFloat) -> some View {
        self.modifier(KaiseiDecolModifier(size: size))
    }
}

#Preview {
    Text("Hello")
        .fontKaiseiDecol(size: 32)
}
