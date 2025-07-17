//
//  ContentView.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.17.
//

import SwiftUI

struct ContentView: View {
    @State var urlString = ""
    @State var response = ""
    @State var isLoading = false
    
    var body: some View {
        VStack {
            ScrollView {
                Group {
                    if !response.isEmpty {
                        Text(response)
                            .padding()
                    } else if isLoading {
                        ProgressView()
                            .padding()
                            .padding(.horizontal)
                    } else {
                        Text("Let me know which site you'd like to inspect!")
                            .padding()
                    }
                }
                .adaptiveBackground()
                .padding(.leading)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            let textField = HStack {
                TextField("Enter URL…", text: $urlString)
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    .onSubmit(submit)
                if !urlString.isEmpty, websiteURL != nil {
                    Label("Valid URL", systemImage: "checkmark.circle")
                        .labelStyle(.iconOnly)
                        .transition(.opacity)
                        .foregroundStyle(.green)
                }
            }
                .padding()
                .adaptiveBackground()
                .textFieldStyle(.plain)
            if #available(iOS 15, *) {
#if os(iOS)
                textField.textInputAutocapitalization(.never)
                    .submitLabel(.send)
#else
                textField
#endif
            } else {
                textField
            }
        }
        .padding()
        .background {
            Image(.rainbow)
                .accessibilityHidden(true)
        }
    }
    
    var websiteURL: URL? {
        if !urlString.contains("://") {
            URL(string: "https://" + urlString)
        } else {
            URL(string: urlString)
        }
    }
    func submit() {
        response = ""
        guard
            let websiteURL,
            let inspectorURL = URL(string: "http://127.0.0.1:5000/accessibility-improvements/\(websiteURL.absoluteString)")
        else {
            return
        }
        let request = URLRequest(url: inspectorURL)
        let session = URLSession(configuration: .default)
        isLoading = true
        Task {
            defer { isLoading = false }
            let (data, _) = try await session.data(for: request)
            let string = String(data: data, encoding: .utf8)
            self.response = string ?? "Failed to load data"
        }
    }
}

#Preview("Default") {
    ContentView()
}

#Preview("Loading") {
    ContentView(isLoading: true)
}

#Preview("Results") {
    ContentView(response: "Hello, world!")
}
