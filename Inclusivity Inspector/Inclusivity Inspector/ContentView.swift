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
                    let checkmarkButton = Button(action: submit) {
                        Label("Valid URL", systemImage: "checkmark.circle")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .transition(.opacity)
                            .foregroundStyle(.green)
                    }
                        .buttonStyle(.accessoryBar)
                    if checkmarkShown {
                        checkmarkButton
                    } else {
                        checkmarkButton.hidden()
                    }
                }
                    .textFieldStyle(.plain)
                let textField = if #available(iOS 15, visionOS 15, *) {
#if os(iOS)
                    AnyView(
                        baseTextField
                            .textInputAutocapitalization(.never)
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
                        Text("Let me know which site you'd like to inspect!")
                            .bubble(.trailing)
                        if !responseURL.isEmpty {
                            Text(responseURL)
                                .bubble(.leading)
                        }
                        if isLoading {
                            ProgressView()
                                .bubble(.trailing)
                        } else if !responseURL.isEmpty {
                            Text(response.isEmpty ? "…" : response)
                                .textSelection(.enabled)
                                .bubble(.trailing)
                        }
                    }
                    .padding()
                }
                Group {
                    let fallback = scroll
                        .safeAreaInset(edge: .bottom, spacing: 0) {
                            textField
                                .padding(12)
                                .adaptiveBackground(Capsule(style: .continuous))
                                .padding([.bottom, .horizontal])
                        }
                        .navigationTitle(
                            Text("One for A11y")
                                .accessibilityLabel("One for Ally")
                        )
#if !os(macOS)
                    if #available(iOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
                        scroll
                            .toolbar {
                                ToolbarItem(placement: .bottomBar) {
                                    textField
                                        .padding(4)
                                        .padding(.horizontal, 4)
                                }
                                ToolbarItem(placement: .title) {
                                    HStack {
                                        Image(.logo)
                                            .resizable()
                                            .scaledToFit()
                                            .accessibilityHidden(true)
                                            .frame(idealHeight: 0)
                                            .cornerRadius(4)
                                        Text("One for A11y")
                                            .accessibilityLabel("One for Ally")
                                            .bold()
                                    }
                                    .fixedSize(horizontal: true, vertical: false)
                                    .font(.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                    } else {
                        fallback
                    }
#else
                    fallback
#endif
                }
            }
            .background(Color(.appBackground), ignoresSafeAreaEdges: .all)
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
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                self.response = decodedResponse.text
            } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == 400 {
                self.response = "I'm sorry, I couldn't find a website at that address."
            } catch is CancellationError {
                // Do nothing
            } catch {
                self.response = "Error: \(error)"
            }
        }
    }
}

struct Response: Decodable {
    var text: String
    var screenshot: Data // or String
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
