//
//  MessagingView.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
//

import SwiftUI
import MessageUI

struct MessagingView: View {
    @State private var showMessageCompose = false

    var body: some View {
        VStack {
            Text("Send Invoice Details")
                .font(.title)
                .padding()
            
            Button("Send via iMessage") {
                showMessageCompose = true
            }
            .sheet(isPresented: $showMessageCompose) {
                MessageComposeView()
            }
        }
        .navigationTitle("Messaging")
    }
}

struct MessageComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.body = "Invoice details..."
        vc.recipients = ["+1234567890"]
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}

