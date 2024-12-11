//
//  MessageComposeView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI
import MessageUI

struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.recipients = recipients
        messageComposeVC.body = body
        messageComposeVC.messageComposeDelegate = context.coordinator
        return messageComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
