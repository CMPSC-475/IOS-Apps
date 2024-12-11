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

    @State private var searchText = ""
    @State private var selectedCategory: String = "All"
    @State private var selectedMaterial: String = "All"
    @State private var selectedGemstone: String = "All"

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search by name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { _, newValue in
                        viewModel.updateSearchText(newValue)
                    }
            }

            // Filter Options
            HStack {
                FilterMenu(title: "Category", selection: $selectedCategory, options: viewModel.uniqueCategories)
                    .onChange(of: selectedCategory) { _, newValue in
                        viewModel.updateSelectedCategory(newValue)
                    }
                FilterMenu(title: "Material", selection: $selectedMaterial, options: viewModel.uniqueMaterials)
                    .onChange(of: selectedMaterial) { _, newValue in
                        viewModel.updateSelectedMaterial(newValue)
                    }
                FilterMenu(title: "Gemstone", selection: $selectedGemstone, options: viewModel.uniqueGemstones)
                    .onChange(of: selectedGemstone) { _, newValue in
                        viewModel.updateSelectedGemstone(newValue)
                    }
            }
            .padding(.horizontal)

            // Filtered and Searched List
            List {
                ForEach(viewModel.filteredInventory) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Category: \(item.category), Material: \(item.material)")
                        Text("Gemstone: \(item.gemstone), Quantity: \(item.quantity)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Inventory")
            .toolbar {
                // Add Item Button
                Button(action: {
                    showingAddItemSheet = true
                }) {
                    Label("Add Item", systemImage: "plus")
                }

                // Reset Filters Button
                Button(action: {
                    viewModel.resetFilters()
                }) {
                    Text("Reset Filters")
                }
            }
        }
        .sheet(isPresented: $showingAddItemSheet) {
            AddInventoryItemView()
                .environmentObject(viewModel) // Ensure the view model is passed here
        }
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = viewModel.filteredInventory[index]
            viewModel.deleteItem(item)
        }
    }
}

// A reusable drop-down menu for filters
struct FilterMenu: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: { selection = option }) {
                    Text(option)
                }
            }
        } label: {
            Text("\(title): \(selection)")
                .font(.subheadline)
                .padding(5)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}
