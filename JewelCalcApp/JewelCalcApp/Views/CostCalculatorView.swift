//
//  CostCalculatorView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct CostCalculatorView: View {
    @StateObject private var viewModel = CostCalculatorViewModel()

    @State private var selectedMaterial = "Gold"
    @State private var selectedGemstone = "Diamond"
    @State private var weight = 0.0
    @State private var designComplexity = 0
    @State private var additionalFees = 0.0

    @State private var calculatedCost = 0.0

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Material Picker
                    Section(header: Text("Material")) {
                        Picker("Material", selection: $selectedMaterial) {
                            ForEach(viewModel.materialPresets, id: \.self) { material in
                                Text(material)
                            }
                        }
                    }

                    // Gemstone Picker
                    Section(header: Text("Gemstone")) {
                        Picker("Gemstone", selection: $selectedGemstone) {
                            ForEach(viewModel.gemstonePresets, id: \.self) { gemstone in
                                Text(gemstone)
                            }
                        }
                    }

                    // Other Inputs
                    Section(header: Text("Details")) {
                        TextField("Weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                        Stepper("Design Complexity: \(designComplexity)", value: $designComplexity, in: 0...10)
                        TextField("Additional Fees", value: $additionalFees, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }

                    // Save Settings
                    Section {
                        Button("Save Settings") {
                            viewModel.saveCurrentSetting(
                                material: selectedMaterial,
                                gemstone: selectedGemstone,
                                weight: weight,
                                designComplexity: designComplexity,
                                additionalFees: additionalFees
                            )
                        }
                    }

                    // Calculate Cost
                    Section {
                        Button("Calculate Cost") {
                            calculatedCost = calculateCost()
                        }
                        Text("Calculated Cost: \(calculatedCost, specifier: "%.2f") USD")
                    }
                }

                // Saved Settings
                List {
                    Section(header: Text("Saved Settings")) {
                        ForEach(viewModel.savedSettings) { setting in
                            VStack(alignment: .leading) {
                                Text("Material: \(setting.material), Gemstone: \(setting.gemstone)")
                                Text("Weight: \(setting.weight), Complexity: \(setting.designComplexity)")
                                Text("Additional Fees: $\(setting.additionalFees, specifier: "%.2f")")
                            }
                            .onTapGesture {
                                applySetting(setting)
                            }
                        }
                        .onDelete(perform: viewModel.deleteSetting)
                    }
                }
            }
            .navigationTitle("Cost Calculator")
        }
    }

    private func calculateCost() -> Double {
        return weight * 50 + Double(designComplexity) * 100 + additionalFees
    }

    private func applySetting(_ setting: CostCalculatorSetting) {
        selectedMaterial = setting.material
        selectedGemstone = setting.gemstone
        weight = setting.weight
        designComplexity = setting.designComplexity
        additionalFees = setting.additionalFees
    }
}

