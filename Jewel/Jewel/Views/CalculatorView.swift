//
//  CalculatorView.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
//

import SwiftUI

struct CalculatorView: View {
    @State private var metalType = "Gold"
    @State private var weight: Double = 0.0
    @State private var totalCost: Double = 0.0

    var body: some View {
        Form {
            Section(header: Text("Jewelry Details")) {
                Picker("Metal Type", selection: $metalType) {
                    Text("Gold").tag("Gold")
                    Text("Silver").tag("Silver")
                    Text("Platinum").tag("Platinum")
                    Text("Rose Gold").tag("Rose")
                }
                
                TextField("Weight (grams)", value: $weight, format: .number)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button("Calculate Cost") {
                    totalCost = calculateCost()
                }
                Text("Total Cost: $\(totalCost, specifier: "%.2f")")
            }
        }
        .navigationTitle("Cost Calculator")
    }
    
    private func calculateCost() -> Double {
        let metalPrice: Double = metalType == "Gold" ? 50 : metalType == "Silver" ? 25 : 70
        return metalPrice * weight
    }
}

