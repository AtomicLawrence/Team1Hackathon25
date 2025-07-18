//
//  AdaptiveBackground.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.17.
//

import SwiftUI

extension View {
    func adaptiveBackground<BackgroundShape: Shape>(_ shape: BackgroundShape = RoundedRectangle(cornerRadius: 16)) -> some View {
        modifier(AdaptiveBackground(shape: shape))
    }
}
struct AdaptiveBackground<BackgroundShape: Shape>: ViewModifier {
    var shape: BackgroundShape
    func body(content: Content) -> some View {
        content.background(.background, in: shape)
//        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
//            content
//                .glassEffect(.regular, in: shape, isEnabled: true)
//        } else {
//            content
//                .background(.regularMaterial, in: shape)
//        }
    }
}
