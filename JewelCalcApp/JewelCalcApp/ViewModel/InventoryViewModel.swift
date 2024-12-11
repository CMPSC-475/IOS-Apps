//
//  InventoryViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import Foundation

class InventoryViewModel: ObservableObject {
    @Published var inventory: [InventoryItem] = []
    
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
