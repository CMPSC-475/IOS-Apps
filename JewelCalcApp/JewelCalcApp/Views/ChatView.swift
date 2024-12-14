//
//  ChatView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI
import MessageUI

struct ChatView: View {
    let customerName: String
    let phoneNumber: String
    @State private var messageText = ""
    @State private var messageHistory: [String] = ["Welcome!"]
    @FocusState private var isMessageFieldFocused: Bool

    var body: some View {
        VStack {
            List(messageHistory, id: \.self) { message in
                HStack {
                    Text(message)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Chat with \(customerName)")
            .listStyle(PlainListStyle())

            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isMessageFieldFocused)
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(8)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isMessageFieldFocused = false }) {
                    Label("Close Keyboard", systemImage: "keyboard.chevron.compact.down")
                }
            }
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        messageHistory.append("You: \(messageText)")
        messageText = ""
    }
}




struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(customerName: "John Doe", phoneNumber: "1234567890")
    }
}

