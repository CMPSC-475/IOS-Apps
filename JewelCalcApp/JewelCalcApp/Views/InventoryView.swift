//
//  InventoryView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    
    @State private var showingAddItemSheet = false
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.inventory) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Category: \(item.category), Material: \(item.material)")
                        Text("Quantity: \(item.quantity)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Inventory")
            .toolbar {
                Button(action: {
                    showingAddItemSheet = true
                }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddItemSheet) {
            AddInventoryItemView()
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = viewModel.inventory[index]
            viewModel.deleteItem(item)
        }
    }
}
