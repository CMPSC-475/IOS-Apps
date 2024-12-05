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
}

struct InvoiceItem: Codable {
    let description: String
    let quantity: Int
    let price: Double
}


