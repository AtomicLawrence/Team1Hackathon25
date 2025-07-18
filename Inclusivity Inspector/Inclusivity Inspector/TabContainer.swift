//
//  TabContainer.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import SwiftUI

struct TabContainer: View {
    var body: some View {
        TabView {
            Tab {
                ContentView()
            } label: {
                Label("Chat", image: .chat)
            }
            Tab {
                Text("NYI")
            } label: {
                Label("History", image: .history)
            }
            Tab {
                Text("NYI")
            } label: {
                Label("Reports", image: .reports)
            }
            Tab {
                Text("NYI")
            } label: {
                Label("Profile", image: .profile)
            }
        }
    }
}

#Preview {
    TabContainer()
        .padding()
}
