//
//  InvoiceView.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
//

import SwiftUI

struct InvoiceView: View {
    @State private var customerName = ""
    @State private var items: [JewelryItem] = [
        JewelryItem(name: "Diamond Ring", quantity: 2),
        JewelryItem(name: "Gold Necklace", quantity: 1)
    ]
    @State private var totalCost: Double = 1500.0

    var body: some View {
        Form {
            Section(header: Text("Customer Information")) {
                TextField("Customer Name", text: $customerName)
            }
            
            Section(header: Text("Items")) {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("Qty: \(item.quantity)")
                    }
                }
            }
            
            Section(header: Text("Total Cost")) {
                Text("Total: $\(totalCost, specifier: "%.2f")")
            }
        }
        .navigationTitle("Invoice Generator")
        .navigationBarItems(trailing: Button("Generate Invoice") {
            // Functionality to generate and share invoice
        })
    }
}
