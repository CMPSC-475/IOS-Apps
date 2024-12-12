//
//  MetalRateMenu.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/12/24.
//

import SwiftUI

struct MetalRateMenu: View {
    @State private var metalRate: Float = 0.0
    @State private var purityRates: [PurityRate] = [
        PurityRate(purity: "22K", percentage: 0.0),
        PurityRate(purity: "18K", percentage: 0.0),
        PurityRate(purity: "14K", percentage: 0.0),
        PurityRate(purity: "9K", percentage: 0.0)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Metal Rate Input
                HStack {
                    Text("Metal Rate/gm")
                        .font(.headline)
                    Spacer()
                    TextField("0.0", value: $metalRate, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                }
                .padding(.horizontal)

                Divider()

                // Purity Rates
                VStack(alignment: .leading, spacing: 10) {
                    Text("Purity Rates")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(purityRates) { purityRate in
                        PurityRateRow(purityRate: purityRate, metalRate: $metalRate)
                    }
                }

                Divider()

                // Save Button
                Button(action: {
                    // Save the data logic can be implemented here
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()

                // Version Information
                Text("Version: 1.04.100")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            }
        }
        .navigationTitle("Metal Rate Menu")
    }
}

struct PurityRateRow: View {
    @ObservedObject var purityRate: PurityRate
    @Binding var metalRate: Float

    var body: some View {
        HStack {
            Text(purityRate.purity)
                .font(.subheadline)
                .frame(width: 50, alignment: .leading)
            TextField("0.0", value: $purityRate.percentage, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(width: 100)
            Text("=")
            Text("\((metalRate * purityRate.percentage / 100), specifier: "%.2f")")
                .frame(width: 100, alignment: .trailing)
                .foregroundColor(.purple)
        }
        .padding(.horizontal)
    }
}



#Preview {
    MetalRateMenu()
}
