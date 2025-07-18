//
//  ImageViewer.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import SwiftUI

struct ImageViewer: View {
    var image: Image?
    @Binding var isShown: Bool
    
    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No content")
            }
        }.toolbar {
            Button {
                isShown = false
            } label: {
                Label("Close", systemImage: "xmark")
            }
        }
    }
}

#Preview {
    ImageViewer(isShown: .constant(true))
        .padding()
}
