//
//  InventoryView.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
//

import SwiftUI

struct JewelryItem: Identifiable {
    var id = UUID()
    var name: String
    var quantity: Int
}

struct InventoryView: View {
    @State private var inventoryItems: [JewelryItem] = [
        JewelryItem(name: "Diamond Ring", quantity: 10),
        JewelryItem(name: "Gold Necklace", quantity: 5)
    ]
    
    var body: some View {
        List {
            ForEach(inventoryItems) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("Qty: \(item.quantity)")
                }
            }
        }
        .navigationTitle("Inventory")
        .navigationBarItems(trailing: Button("Add Item") {
            // Add item functionality
        })
    }
}
