//
//  TypingIndicator.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import SwiftUI

struct TypingIndicator: View {
    @State private var flag = false
    @State private var width: Double = 0
    
    var body: some View {
        HStack(spacing: 4) {
            let scale: Double = flag ? 0.75 : 1
            Group {
                Circle().fill(Color.gray)
                    .scaleEffect(scale)
                    .animation(
                        .bouncy(duration: 0.5)
                        .repeatForever()
                        .delay(0/6),
                        value: scale
                    )
                Circle().fill(Color.gray)
                    .scaleEffect(scale)
                    .animation(
                        .bouncy(duration: 0.5)
                        .repeatForever()
                        .delay(1/6),
                        value: scale
                    )
                Circle().fill(Color.gray)
                    .scaleEffect(scale)
                    .animation(
                        .bouncy(duration: 0.5)
                        .repeatForever()
                        .delay(2/6),
                        value: scale
                    )
            }
            .frame(width: 8, height: 8)
        }
        .onGeometryChange(for: CGFloat.self, of: \.size.width) { newValue in
            width = newValue
        }
        .frame(height: width/2)
        .task {
            try? await Task.sleep(nanoseconds: 1)
            flag = true
        }
        .accessibilityLabel("Generating response…")
    }
}

#Preview {
    TypingIndicator()
        .padding()
}
