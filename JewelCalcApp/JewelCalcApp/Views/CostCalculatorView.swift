//
//  CostCalculatorView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct CostCalculatorView: View {
    @State private var material = ""
    @State private var gemstone = ""
    @State private var weight = 0.0
    @State private var designComplexity = 0
    @State private var additionalFees = 0.0
    
    @State private var calculatedCost = 0.0
    
    var body: some View {
        Form {
            TextField("Material", text: $material)
            TextField("Gemstone", text: $gemstone)
            TextField("Weight", value: $weight, format: .number)
            Stepper("Design Complexity: \(designComplexity)", value: $designComplexity, in: 0...10)
            TextField("Additional Fees", value: $additionalFees, format: .currency(code: "USD"))
            
            Button("Calculate Cost") {
                calculatedCost = calculateCost()
            }
            
            Text("Calculated Cost: \(calculatedCost, specifier: "%.2f") USD")
                .padding(.top)
        }
        .navigationTitle("Cost Calculator")
    }
    
    func calculateCost() -> Double {
        return weight * 50 + Double(designComplexity) * 100 + additionalFees
    }
}
