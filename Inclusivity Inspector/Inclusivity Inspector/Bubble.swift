//
//  Bubble.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.17.
//

import SwiftUI

extension View {
    func bubble(_ alignment: HorizontalEdge, inset: Bool = true) -> some View {
        modifier(Bubble(alignment: alignment, inset: inset))
    }
}

struct Bubble: ViewModifier {
    var alignment: HorizontalEdge
    var inset: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, inset ? 8 : 0)
            .padding(.horizontal, inset ? 16 : 0)
            .background(.blue.opacity(alignment == .leading ? 0.5 : 0))
            .background(.background)
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment == .leading ? .leading : .trailing, vertical: .center))
            .padding(alignment == .leading ? .trailing : .leading)
    }
}
