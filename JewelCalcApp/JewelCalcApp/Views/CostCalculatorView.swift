//
//  CostCalculatorView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct CostCalculatorView: View {
    @StateObject private var viewModel = CostCalculatorViewModel()

    @State private var isNatural = true
    @State private var itemName: String = ""
    @State private var purity: String = "18K"
    @State private var metalWeight: Float = 0.0
    @State private var metalRate: Float = 0.0
    @State private var labour: Float = 0.0
    @State private var labourRate: Float = 0.0
    @State private var solitaireWeight: Float = 0.0
    @State private var solitaireRate: Float = 0.0
    @State private var sideDiaWeight: Float = 0.0
    @State private var sideDiaRate: Float = 0.0
    @State private var colStoneWeight: Float = 0.0
    @State private var colStoneRate: Float = 0.0
    @State private var charges: Float = 0.0
    @State private var taxPercentage: Float = 0.0
    @State private var totalPrice: Float = 0.0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Toggle for Natural and Lab Grown
                    HStack {
                        Text("Jewellery price calculator")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()

                    HStack {
                        Toggle(isOn: $isNatural) {
                            Text(isNatural ? "Natural" : "Lab Grown")
                        }
                        //.toggleStyle(SegmentedToggleStyle())
                    }
                    .padding(.horizontal)

                    // Item Name
                    TextField("Item Name", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    // Purity Dropdown
                    HStack {
                        Text("Purity")
                            .font(.subheadline)
                        Spacer()
                        Picker("Purity", selection: $purity) {
                            Text("9K").tag("9K")
                            Text("14K").tag("14K")
                            Text("18K").tag("18K")
                            Text("22K").tag("22K")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                    }
                    .padding(.horizontal)

                    // Metal Weight and Rate
                    CalculationRow(label: "Metal wt.", value1: $metalWeight, value2: $metalRate)

                    // Labour Weight and Rate
                    CalculationRow(label: "Labour", value1: $labour, value2: $labourRate)

                    // Solitaire Weight and Rate
                    CalculationRow(label: "Solitaire wt.", value1: $solitaireWeight, value2: $solitaireRate)

                    // Side DIA Weight and Rate
                    CalculationRow(label: "Side DIA", value1: $sideDiaWeight, value2: $sideDiaRate)

                    // Colored Stone Weight and Rate
                    CalculationRow(label: "Col. Stone wt.", value1: $colStoneWeight, value2: $colStoneRate)

                    // Charges and Tax
                    VStack {
                        HStack {
                            Text("Charges")
                                .font(.subheadline)
                            Spacer()
                            TextField("0.0", value: $charges, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                        }
                        HStack {
                            Text("Tax %")
                                .font(.subheadline)
                            Spacer()
                            TextField("0.0", value: $taxPercentage, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                        }
                    }
                    .padding(.horizontal)

                    // Total Price
                    HStack {
                        Text("Total Price (INR)")
                            .font(.headline)
                        Spacer()
                        Text("\(totalPrice, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal)

                    // Save and Get Estimate Button
                    Button(action: calculateTotalPrice) {
                        Text("Save and Get Estimate")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Cost Calculator")
            .toolbar {
                // Add Metal Rate Menu Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MetalRateMenu()) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.purple)
                    }
                }
            }
        }
    }

    private func calculateTotalPrice() {
        let metalCost = metalWeight * metalRate
        let labourCost = labour * labourRate
        let solitaireCost = solitaireWeight * solitaireRate
        let sideDiaCost = sideDiaWeight * sideDiaRate
        let colStoneCost = colStoneWeight * colStoneRate
        let subtotal = metalCost + labourCost + solitaireCost + sideDiaCost + colStoneCost + charges
        let tax = subtotal * (taxPercentage / 100)
        totalPrice = subtotal + tax
    }
}

struct CalculationRow: View {
    let label: String
    @Binding var value1: Float
    @Binding var value2: Float

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            TextField("0.0", value: $value1, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(width: 80)
            Text("*")
            TextField("0.0", value: $value2, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(width: 80)
            Text("=")
            Text("\((value1 * value2), specifier: "%.2f")")
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal)
    }
}

