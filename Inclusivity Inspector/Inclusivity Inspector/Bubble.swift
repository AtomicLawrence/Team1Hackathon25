//
//  Bubble.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.17.
//

import SwiftUI

extension View {
    func bubble(_ alignment: HorizontalEdge) -> some View {
        modifier(Bubble(alignment: alignment))
    }
}

struct Bubble: ViewModifier {
    var alignment: HorizontalEdge
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .padding(.horizontal, 8)
            .background(.blue.opacity(alignment == .leading ? 0.5 : 0), in: RoundedRectangle(cornerRadius: 16))
            .background(.background, in: RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment == .leading ? .leading : .trailing, vertical: .center))
            .padding(alignment == .leading ? .trailing : .leading)
    }
}
