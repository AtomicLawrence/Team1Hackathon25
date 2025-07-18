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
    @State private var task: Task<(), Error>? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                let baseTextField = HStack {
                    TextField("Enter URL…", text: $urlString)
                        .textContentType(.URL)
                        .autocorrectionDisabled()
                        .onSubmit(submit)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    let checkmarkShown = !urlString.isEmpty && websiteURL != nil
                    if checkmarkShown {
                        Button(action: submit) {
                            Label("Valid URL", systemImage: "checkmark.circle")
                                .labelStyle(.iconOnly)
                                .transition(.opacity)
                                .foregroundStyle(.green)
                        }
                    }
                }
                    .padding(12)
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
                            if !responseURL.isEmpty {
                                Text(responseURL)
                                    .bubble(.leading)
                            }
                            if isLoading {
                                ProgressView()
                                    .bubble(.trailing)
                            }
                            if !responseURL.isEmpty {
                                Text(response.isEmpty ? "…" : response)
                                    .textSelection(.enabled)
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
        task?.cancel()
        responseURL = urlString
        guard
            let websiteURL,
            let inspectorURL = URL(string: "http://127.0.0.1:5000/accessibility-improvements/\(websiteURL.absoluteString)")
        else {
            response = "I'm sorry, the URL you entered is invalid."
            return
        }
        urlString = ""
        response = ""
        let request = URLRequest(url: inspectorURL)
        let session = URLSession(configuration: .default)
        isLoading = true
        task = Task {
            do {
                defer { isLoading = false }
                let (data, _) = try await session.data(for: request)
                let string = String(data: data, encoding: .utf8)
                self.response = string ?? "Failed to load data"
            } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == 400 {
                self.response = "I'm sorry, I couldn't find a website at that address."
            } catch {
                self.response = "Error: \(error)"
            }
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
