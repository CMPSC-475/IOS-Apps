//
//  InventoryItem.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import Foundation

struct InventoryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var material: String
    var gemstone: String
    var weight: Double
    var quantity: Int
}
