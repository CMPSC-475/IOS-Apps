//
//  MessagingView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI

struct MessagingView: View {
    let invoices: [Invoice]
    @State private var selectedInvoice: Invoice? // Tracks the selected invoice
    @State private var showingChat = false       // Toggles the chat view

    var body: some View {
        NavigationView {
            List(invoices) { invoice in
                Button(action: {
                    selectedInvoice = invoice
                    showingChat = true
                }) {
                    HStack {
                        Text(invoice.customerName)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Messaging")
        }
        .sheet(isPresented: $showingChat) {
            if let selectedInvoice = selectedInvoice {
                ChatView(
                    customerName: selectedInvoice.customerName,
                    phoneNumber: selectedInvoice.phoneNumber ?? ""
                )
            }
        }
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView(invoices: [
            Invoice(
                id: UUID(),
                date: Date(),
                customerName: "John Doe",
                items: [],
                totalAmount: 500.0,
                paymentStatus: .unpaid,
                dueDate: Date(),
                phoneNumber: "1234567890"
            ),
            Invoice(
                id: UUID(),
                date: Date(),
                customerName: "Jane Smith",
                items: [],
                totalAmount: 1000.0,
                paymentStatus: .paid,
                dueDate: Date(),
                phoneNumber: nil
            )
        ])
    }
}

