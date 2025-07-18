//
//  ChatField.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import SwiftUI

struct ChatField: View {
    @Binding var urlString: String
    var submit: () -> ()
    
    var body: some View {
        let baseTextField = HStack {
            TextField("Enter URL…", text: $urlString)
                .textContentType(.URL)
                .autocorrectionDisabled()
                .onSubmit(submit)
                .frame(maxWidth: .infinity, alignment: .leading)
            let checkmarkShown = !urlString.isEmpty && urlString.websiteURL != nil
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
        if #available(iOS 15, visionOS 15, *) {
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
    }
}

#Preview {
    ChatField(urlString: .constant(""), submit: {})
        .padding()
}
