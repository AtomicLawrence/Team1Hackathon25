//
//  ChatEntryView.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import SwiftUI

struct ChatEntryView: View {
    var chatEntry: Chat.Entry
    @Environment(\.selectedImage) @Binding var selectedImage
    
    var body: some View {
        switch chatEntry.content {
        case .image(let image):
                Button {
                    selectedImage = image
                } label: {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 320)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .buttonStyle(.plain)
                .bubble(chatEntry.side, inset: false)
        case .text(let text):
                Text(text)
                    .textSelection(.enabled)
                    .bubble(chatEntry.side)
        }
    }
}

#Preview("Text") {
    ChatEntryView(chatEntry: .init(side: .trailing, content: .text("Hello, world!")))
        .padding()
}

#Preview("Image") {
    ChatEntryView(chatEntry: .init(side: .trailing, content: .image(Image(systemName: "photo"))))
        .padding()
}
