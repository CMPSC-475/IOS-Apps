//
//  EstimateView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/14/24.
//

import SwiftUI
import UIKit

struct EstimateView: View {
    let itemName: String
    let isNatural: Bool
    let purity: String
    let metalWeight: Float
    let metalRate: Float
    let labourWeight: Float
    let labourRate: Float
    let solitaireWeight: Float
    let solitaireRate: Float
    let sideDiaWeight: Float
    let sideDiaRate: Float
    let colStoneWeight: Float
    let colStoneRate: Float
    let charges: Float
    let taxPercentage: Float
    let totalPrice: Float

    @State private var isSharing = false
    @State private var shareImage: UIImage?

    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack {
                Text("PANROSA JEWELS")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.purple)
                Text(isNatural ? "Natural Diamond" : "Lab Grown")
                    .font(.title2)
                    .foregroundColor(.purple)
                Text("Price Estimate , Date : \(Date.now.formatted(date: .numeric, time: .shortened))")
                    .font(.subheadline)
            }
            Divider()

            // Item Info
            Text(itemName)
                .font(.headline)

            // Purity
            Text(purity)
                .font(.headline)
                .foregroundColor(.purple)

            // Estimate Table
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Details").bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("Weight").bold().frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Rate").bold().frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Total").bold().frame(maxWidth: .infinity, alignment: .trailing)
                }
                Divider()
                estimateRow("Metal", weight: metalWeight, rate: metalRate)
                estimateRow("Labour", weight: labourWeight, rate: labourRate)
                estimateRow("Solitaire", weight: solitaireWeight, rate: solitaireRate)
                estimateRow("Side DIA", weight: sideDiaWeight, rate: sideDiaRate)
                estimateRow("Col. Stone", weight: colStoneWeight, rate: colStoneRate)
                estimateRow("Other Charges", weight: nil, rate: charges)
                estimateRow("Tax%", weight: nil, rate: taxPercentage, total: taxAmount())

                Divider()
                HStack {
                    Text("Total Price (INR)*")
                        .font(.headline)
                    Spacer()
                    Text("\(totalPrice, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.purple)
                }
                Text("Price may differ as per actual product")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Divider()

            // Notes Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Note: -")
                    .bold()
                Text("Solitaire:")
                Text("Side DIA:")
                Text("Other Charges:")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            // Share Button
            Button(action: shareEstimate) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Estimate")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
        .sheet(isPresented: $isSharing) {
            if let shareImage = shareImage {
                ShareSheet(activityItems: [shareImage])
            }
        }
    }

    private func estimateRow(_ label: String, weight: Float? = nil, rate: Float, total: Float? = nil) -> some View {
        HStack {
            Text(label)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let weight = weight {
                Text("\(weight, specifier: "%.2f")")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                Text("--")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Text("\(rate, specifier: "%.2f")")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("\(total ?? (weight ?? 1) * rate, specifier: "%.2f")")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func taxAmount() -> Float {
        let subtotal = metalWeight * metalRate +
            labourWeight * labourRate +
            solitaireWeight * solitaireRate +
            sideDiaWeight * sideDiaRate +
            colStoneWeight * colStoneRate +
            charges
        return subtotal * (taxPercentage / 100)
    }

    private func shareEstimate() {
        let renderer = UIGraphicsImageRenderer(size: UIScreen.main.bounds.size)
        let image = renderer.image { _ in
            let hostingController = UIHostingController(rootView: self)
            hostingController.view.frame = UIScreen.main.bounds
            hostingController.view.backgroundColor = .white
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        shareImage = image
        isSharing = true
    }
}


