//
//  ContentView.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.17.
//

import SwiftUI

struct Chat {
    var history: [Chat.Entry] = [.init(side: .trailing, content: .text("Let me know which site you'd like to inspect!"))]
    var isLoading = false
    struct Entry: Identifiable {
        var date: Date = Date()
        var side: HorizontalEdge
        var content: Content
        enum Content {
            case image(Image)
            case text(String)
        }
        
        var id: Date { date }
    }
}

extension EnvironmentValues {
    @Entry var selectedImage: Binding<Image?> = .constant(nil)
}
@TaskLocal var activeScrollView: ScrollViewProxy? = nil

struct ContentView: View {
    @State var urlString = ""
    @State var chat: Chat = .init()
    @State private var selectedImage: Image? = nil
    @State private var task: Task<(), Error>? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { scrollView in
                    VStack {
                        let textField = ChatField(urlString: $urlString) {
                            $activeScrollView.withValue(scrollView) {
                                submit()
                            }
                        }
                        let scroll = ScrollView {
                            LazyVStack {
                                ForEach(chat.history) { entry in
                                    ChatEntryView(chatEntry: entry)
                                        .id(entry.date)
                                }.environment(\.selectedImage, $selectedImage)
                                if chat.isLoading {
                                    TypingIndicator()
                                        .bubble(.trailing)
                                }
                            }
                            .padding()
                        }.defaultScrollAnchor(.bottom)
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
                }
                .opacity(selectedImage == nil ? 1 : 0)
                .accessibilityHidden(selectedImage != nil)
                if selectedImage != nil {
                    ImageViewer(image: $selectedImage)
                        .accessibilityAddTraits(.isModal)
                }
            }
        }
        .background(Color(.appBackground), ignoresSafeAreaEdges: .all)
    }
    
    func submit() {
        task?.cancel()
        say(urlString)
        let responseURL = urlString
        guard
            let websiteURL = urlString.websiteURL,
            let inspectorURL = URL(string: "http://127.0.0.1:5000/accessibility-improvements/\(websiteURL.absoluteString)")
        else {
            respond("I'm sorry, the URL you entered is invalid.")
            return
        }
        urlString = ""
        let request = URLRequest(url: inspectorURL)
        let session = URLSession(configuration: .default)
        chat.isLoading = true
        respond("Analysing \(responseURL) for accessibility issues…")
        task = Task {
            var stringResponse: String?
            do {
                defer { chat.isLoading = false }
                
                let useLocalResponse = true
                if useLocalResponse, websiteURL.host()?.wholeMatch(of: /(www\.)?example\.com/) != nil {
                    try await Task.sleep(for: .seconds(1))
                    let string = try String(contentsOf: Bundle.main.url(forResource: "ExampleResponse", withExtension: "txt")!, encoding: .utf8)
                    stringResponse = string
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: string.data(using: .utf8)!)
                    if let image = Image(base64: decodedResponse.screenshot) {
                        respond(image)
                    }
                    respond(decodedResponse.text)
                } else {
                    let (data, _) = try await session.data(for: request)
                    stringResponse = String(data: data, encoding: .utf8)
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                    if let image = Image(base64: decodedResponse.screenshot) {
                        respond(image)
                    }
                    respond(decodedResponse.text)
                }
            } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == 400 {
                respond("I'm sorry, I couldn't find a website at that address.")
            } catch is CancellationError {
                // Do nothing
            } catch {
                var response = "Error: \(error)"
                if let stringResponse {
                    response += "\n\n" + stringResponse
                }
                respond(response)
            }
        }
    }
    
    func say(_ submission: String) {
        addEntry(.init(side: .leading, content: .text(submission)))
    }
    func respond(_ reply: String) {
        addEntry(.init(side: .trailing, content: .text(reply.isEmpty ? "…" : reply)))
    }
    func respond(_ image: Image) {
        addEntry(.init(side: .trailing, content: .image(image)))
    }
    func addEntry(_ entry: Chat.Entry) {
        chat.history.append(entry)
        Task {
            try await Task.sleep(for: .seconds(0.5))
            activeScrollView?.scrollTo(entry.id, anchor: .bottom)
        }
    }
}

extension Image {
    init?(base64: Data) {
        self.init(data: base64)
    }
    init?(data: Data) {
#if os(macOS)
        if let image = NSImage(data: data) {
            self.init(nsImage: image)
        } else {
            return nil
        }
#else
        if let image = UIImage(data: data) {
            self.init(uiImage: image)
        } else {
            return nil
        }
#endif
    }
}

struct Response: Decodable {
    var text: String
    var screenshot: Data
}

#Preview("Default") {
    ContentView(chat: .init())
}

#Preview("Loading") {
    ContentView(chat: .init(isLoading: true))
}

#Preview("Results") {
    ContentView(chat: .init(history: [
        .init(side: .leading, content: .text("example")),
        .init(side: .trailing, content: .text("Analysing example for accessibility issues…")),
        .init(side: .trailing, content: .text(repeatElement("**Hello, world!**", count: 200).joined(separator: "\n"))),
    ]))
}

#Preview("Live") {
    ContentView(urlString: "example.com")
}
