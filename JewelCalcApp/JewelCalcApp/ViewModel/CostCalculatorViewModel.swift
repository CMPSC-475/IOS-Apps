//
//  CostCalculatorViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import Foundation
import SwiftUI

class CostCalculatorViewModel: ObservableObject {
    @Published var materialPresets = ["Gold", "Silver", "Platinum"]
    @Published var gemstonePresets = ["Diamond", "Ruby", "Sapphire"]
    @Published var savedSettings: [CostCalculatorSetting] = []

    private let savedSettingsKey = "SavedCostCalculatorSettings"

    init() {
        loadSavedSettings()
    }

    func saveCurrentSetting(material: String, gemstone: String, weight: Double, designComplexity: Int, additionalFees: Double) {
        let newSetting = CostCalculatorSetting(
            id: UUID(),
            material: material,
            gemstone: gemstone,
            weight: weight,
            designComplexity: designComplexity,
            additionalFees: additionalFees
        )
        savedSettings.append(newSetting)
        saveToPersistence()
    }

    func deleteSetting(at offsets: IndexSet) {
        savedSettings.remove(atOffsets: offsets)
        saveToPersistence()
    }

    private func saveToPersistence() {
        do {
            let data = try JSONEncoder().encode(savedSettings)
            UserDefaults.standard.set(data, forKey: savedSettingsKey)
        } catch {
            print("Failed to save settings: \(error)")
        }
    }

    private func loadSavedSettings() {
        guard let data = UserDefaults.standard.data(forKey: savedSettingsKey) else { return }
        do {
            savedSettings = try JSONDecoder().decode([CostCalculatorSetting].self, from: data)
        } catch {
            print("Failed to load settings: \(error)")
        }
    }
}

struct CostCalculatorSetting: Identifiable, Codable {
    let id: UUID
    let material: String
    let gemstone: String
    let weight: Double
    let designComplexity: Int
    let additionalFees: Double
}

