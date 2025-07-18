//
//  ImageViewer.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import SwiftUI

struct ImageViewer: View {
    @Binding var image: Image?
    
    var body: some View {
        Group {
            ScrollView([.horizontal, .vertical]) {
                if let image {
                    image
                } else {
                    Text("No content")
                }
            }.defaultScrollAnchor(.top)
        }.toolbar {
            Button {
                image = nil
            } label: {
                Label("Close", systemImage: "xmark")
            }
        }
    }
}

#Preview {
    ImageViewer(image: .constant(Image(systemName: "photo")))
        .padding()
}
