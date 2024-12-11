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
    @State private var messageHistory: [String] = []
    @State private var showingMessageCompose = false

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
                Button(action: { showingMessageCompose = true }) {
                    Label("Send via iMessage", systemImage: "message.fill")
                }
            }
        }
        .sheet(isPresented: $showingMessageCompose) {
            MessageComposeView(
                recipients: [phoneNumber],
                body: ""
            )
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

