//
//  AddInventoryItemView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct AddInventoryItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: InventoryViewModel
    
    @State private var name = ""
    @State private var category = ""
    @State private var material = ""
    @State private var gemstone = ""
    @State private var weight = 0.0
    @State private var quantity = 0
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Category", text: $category)
                TextField("Material", text: $material)
                TextField("Gemstone", text: $gemstone)
                TextField("Weight", value: $weight, format: .number)
                Stepper("Quantity: \(quantity)", value: $quantity, in: 0...100)
            }
            .navigationTitle("Add Item")
            .toolbar {
                Button("Save") {
                    let newItem = InventoryItem(
                        id: UUID(),
                        name: name,
                        category: category,
                        material: material,
                        gemstone: gemstone,
                        weight: weight,
                        quantity: quantity
                    )
                    viewModel.addItem(newItem)
                    dismiss()
                }
            }
        }
    }
}

