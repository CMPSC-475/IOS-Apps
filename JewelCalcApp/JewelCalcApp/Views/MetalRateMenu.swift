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
        PurityRate(purity: "22K", percentage: 91.6, rate: 0.0),
        PurityRate(purity: "18K", percentage: 75.0, rate: 0.0),
        PurityRate(purity: "14K", percentage: 58.3, rate: 0.0),
        PurityRate(purity: "9K", percentage: 37.5, rate: 0.0)
    ]
    @State private var labour: Float = 0.0
    @State private var charges: Float = 0.0
    @State private var taxPercentage: Float = 0.0

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

                    ForEach($purityRates) { $purityRate in
                        HStack {
                            Text(purityRate.purity)
                                .font(.subheadline)
                                .frame(width: 50, alignment: .leading)
                            Text("\(purityRate.percentage, specifier: "%.1f")%")
                                .frame(width: 50, alignment: .center)
                            TextField("Rate/gms", value: $purityRate.rate, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                        }
                        .padding(.horizontal)
                    }
                }

                Divider()

                // Labour, Charges, and Tax Inputs
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Labour")
                            .font(.subheadline)
                        Spacer()
                        TextField("0.0", value: $labour, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Charges")
                            .font(.subheadline)
                        Spacer()
                        TextField("0.0", value: $charges, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Tax %")
                            .font(.subheadline)
                        Spacer()
                        TextField("0.0", value: $taxPercentage, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    .padding(.horizontal)
                }

                Divider()

                // Save Button
                Button(action: {
                    // Action to save the values
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

struct PurityRate: Identifiable {
    let id = UUID()
    var purity: String
    var percentage: Float
    var rate: Float
}

