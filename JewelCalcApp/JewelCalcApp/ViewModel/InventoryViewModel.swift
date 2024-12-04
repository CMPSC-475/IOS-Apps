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

