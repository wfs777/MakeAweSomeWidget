//
//  View+.swift
//  WidgetsWall
//
//  Created by on 2024/10/17.
//

import SwiftUI

@available(iOS 15.0.0, *)
struct BaseShadowModifier: ViewModifier {
    let color: SwiftUI.Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 6, x: 0, y: 3)
            .shadow(color: color, radius: 1, x: 0, y: 1)
    }
}

@available(iOS 15.0.0, *)
extension View {
    func baseShadow(color: SwiftUI.Color = .black.opacity(0.3)) -> some View {
        modifier(BaseShadowModifier(color: color))
    }
}
