//
//  ContentView.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.17.
//

import SwiftUI

struct ContentView: View {
    @State var urlString = ""
    @State var responseURL = ""
    @State var response = ""
    @State var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                let baseTextField = HStack {
                    TextField("Enter URL…", text: $urlString)
                        .textContentType(.URL)
                        .autocorrectionDisabled()
                        .onSubmit(submit)
                    let checkmarkShown = !urlString.isEmpty && websiteURL != nil
                    Label("Valid URL", systemImage: "checkmark.circle")
                        .labelStyle(.iconOnly)
                        .transition(.opacity)
                        .foregroundStyle(.green)
                        .opacity(checkmarkShown ? 1 : 0)
                        .accessibilityHidden(!checkmarkShown)
                }
                    .padding()
                    .textFieldStyle(.plain)
                let textField = if #available(iOS 15, *) {
#if os(iOS)
                    AnyView(
                        baseTextField.textInputAutocapitalization(.never)
                            .submitLabel(.send)
                    )
#else
                    AnyView(baseTextField)
#endif
                } else {
                    AnyView(baseTextField)
                }
                let scroll = ScrollView {
                    VStack {
                        Group {
                            Text("Let me know which site you'd like to inspect!")
                                .bubble(.trailing)
                            if !response.isEmpty {
                                Text(responseURL)
                                    .bubble(.leading)
                                Text(response)
                                    .bubble(.trailing)
                            } else if isLoading {
                                Text(responseURL)
                                    .bubble(.leading)
                                ProgressView()
                                    .bubble(.trailing)
                            }
                        }
                    }
                    .padding()
                }
#if os(macOS)
                VStack {
                    scroll
                    textField
                        .adaptiveBackground()
                        .padding([.bottom, .horizontal])
                }
#else
                scroll
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
                                textField
                            } else {
                                textField
                                    .adaptiveBackground()
                            }
                        }
                    }
#endif
            }
            .background {
                Image(.rainbow)
                    .accessibilityHidden(true)
            }
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
        guard
            let websiteURL,
            let inspectorURL = URL(string: "http://127.0.0.1:5000/accessibility-improvements/\(websiteURL.absoluteString)")
        else {
            return
        }
        defer {
            urlString = ""
            response = ""
        }
        responseURL = urlString
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
    ContentView(responseURL: "example", isLoading: true)
}

#Preview("Results") {
    ContentView(responseURL: "example", response: repeatElement("Hello, world!", count: 200).joined(separator: "\n"))
}
