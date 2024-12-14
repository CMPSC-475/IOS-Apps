//
//  InventoryViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import Foundation

class InventoryViewModel: ObservableObject {
    @Published var inventory: [InventoryItem] = [] {
        didSet {
            saveInventory()
        }
    }
    
    // Search and filter properties
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var selectedMaterial: String = "All"
    @Published var selectedGemstone: String = "All"

    init() {
        loadInventory()
    }

    private func saveInventory() {
        do {
            let encodedData = try JSONEncoder().encode(inventory)
            UserDefaults.standard.set(encodedData, forKey: "inventory")
        } catch {
            print("Failed to save inventory: \(error)")
        }
    }

    private func loadInventory() {
        guard let savedData = UserDefaults.standard.data(forKey: "inventory") else { return }
        do {
            inventory = try JSONDecoder().decode([InventoryItem].self, from: savedData)
        } catch {
            print("Failed to load inventory: \(error)")
        }
    }

    func addItem(_ item: InventoryItem) {
        inventory.append(item)
    }

    func deleteItem(_ item: InventoryItem) {
        inventory.removeAll { $0.id == item.id }
    }

    func updateItem(_ item: InventoryItem) {
        if let index = inventory.firstIndex(where: { $0.id == item.id }) {
            inventory[index] = item
        }
    }

    // Computed properties for filtered inventory and unique options
    var filteredInventory: [InventoryItem] {
        inventory.filter { item in
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == "All" || item.category == selectedCategory
            let matchesMaterial = selectedMaterial == "All" || item.material == selectedMaterial
            let matchesGemstone = selectedGemstone == "All" || item.gemstone == selectedGemstone
            return matchesSearch && matchesCategory && matchesMaterial && matchesGemstone
        }
    }

    var uniqueCategories: [String] {
        ["All"] + Array(Set(inventory.map { $0.category })).sorted()
    }

    var uniqueMaterials: [String] {
        ["All"] + Array(Set(inventory.map { $0.material })).sorted()
    }

    var uniqueGemstones: [String] {
        ["All"] + Array(Set(inventory.map { $0.gemstone })).sorted()
    }

    // Update methods for filters and search
    func updateSearchText(_ text: String) {
        searchText = text
    }

    func updateSelectedCategory(_ category: String) {
        selectedCategory = category
    }

    func updateSelectedMaterial(_ material: String) {
        selectedMaterial = material
    }

    func updateSelectedGemstone(_ gemstone: String) {
        selectedGemstone = gemstone
    }

    func resetFilters() {
        searchText = ""
        selectedCategory = "All"
        selectedMaterial = "All"
        selectedGemstone = "All"
    }

    // Alert for low inventory
    func checkLowInventory(threshold: Int = 5) {
        for item in inventory where item.quantity < threshold {
            let title = "Low Inventory Alert"
            let body = "\(item.name) is running low with only \(item.quantity) left in stock."
            NotificationManager.shared.scheduleNotification(title: title, body: body, triggerDate: Date().addingTimeInterval(5))
        }
    }
}
