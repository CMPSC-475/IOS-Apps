//
//  Invoice.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import Foundation

struct Invoice: Identifiable, Codable {
    let id: UUID
    let date: Date
    let customerName: String
    let items: [InvoiceItem]
    let totalAmount: Double
    var paymentStatus: PaymentStatus
    var dueDate: Date
}

struct InvoiceItem: Codable {
    let description: String
    let quantity: Int
    let price: Double
}


enum PaymentStatus: String, Codable, CaseIterable {
    case unpaid = "Unpaid"
    case partiallyPaid = "Partially Paid"
    case paid = "Paid"
}
