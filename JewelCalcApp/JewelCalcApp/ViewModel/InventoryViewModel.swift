//
//  InventoryViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import Foundation

class InventoryViewModel: ObservableObject {
    @Published var inventory: [InventoryItem] = []

    // Search and filter properties
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var selectedMaterial: String = "All"
    @Published var selectedGemstone: String = "All"

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
}


extension InventoryViewModel {
    var totalInventoryValue: Double {
        inventory.reduce(0) { $0 + ($1.weight * 100) } // Assume $100 per weight unit
    }

    var topGemstones: [String] {
        let gemstoneCounts = inventory.reduce(into: [:]) { counts, item in
            counts[item.gemstone, default: 0] += 1
        }
        return gemstoneCounts.sorted(by: { $0.value > $1.value }).prefix(3).map { $0.key }
    }
}

extension InventoryViewModel {
    func checkLowInventory(threshold: Int = 5) {
        for item in inventory where item.quantity < threshold {
            let title = "Low Inventory Alert"
            let body = "\(item.name) is running low with only \(item.quantity) left in stock."
            NotificationManager.shared.scheduleNotification(title: title, body: body, triggerDate: Date().addingTimeInterval(5))
        }
    }
}
