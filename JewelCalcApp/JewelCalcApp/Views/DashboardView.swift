//
//  DashboardView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @EnvironmentObject var invoiceViewModel: InvoiceViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Analytics Dashboard")
                    .font(.largeTitle)
                    .padding(.bottom)

                VStack(alignment: .leading) {
                    Text("Total Inventory Value:")
                        .font(.headline)
                    Text("$\(inventoryViewModel.totalInventoryValue, specifier: "%.2f")")
                }

                VStack(alignment: .leading) {
                    Text("Top Gemstones:")
                        .font(.headline)
                    ForEach(inventoryViewModel.topGemstones, id: \.self) { gemstone in
                        Text(gemstone)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Monthly Invoice Totals:")
                        .font(.headline)
                    ForEach(invoiceViewModel.monthlyInvoiceTotals.sorted(by: { $0.key < $1.key }), id: \.key) { month, total in
                        Text("\(month): $\(total, specifier: "%.2f")")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}
