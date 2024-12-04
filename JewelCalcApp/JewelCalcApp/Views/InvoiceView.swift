//
//  InvoiceView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct InvoiceView: View {
    @EnvironmentObject var viewModel: InvoiceViewModel
    @State private var showingPDFExportAlert = false
    @State private var exportedPDFURL: URL?

    var body: some View {
        VStack {
            if viewModel.invoices.isEmpty {
                Text("No Invoices Available")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                List(viewModel.invoices) { invoice in
                    VStack(alignment: .leading) {
                        Text("Customer: \(invoice.customerName)")
                            .font(.headline)
                        Text("Total: $\(invoice.totalAmount, specifier: "%.2f")")
                    }
                    .onTapGesture {
                        if let url = viewModel.generatePDF(for: invoice) {
                            exportedPDFURL = url
                            showingPDFExportAlert = true
                        }
                    }
                }
            }
        }
        .navigationTitle("Invoices")
        .toolbar {
            Button(action: addSampleInvoice) {
                Label("Add Invoice", systemImage: "plus")
            }
        }
        .alert("PDF Exported", isPresented: $showingPDFExportAlert, actions: {
            if let url = exportedPDFURL {
                Button("Open PDF") {
                    UIApplication.shared.open(url)
                }
            }
            Button("OK", role: .cancel) {}
        }, message: {
            Text("The invoice was successfully exported.")
        })
    }

    private func addSampleInvoice() {
        let sampleItems = [
            InvoiceItem(description: "Gold Necklace", quantity: 1, price: 500.0),
            InvoiceItem(description: "Silver Ring", quantity: 2, price: 75.0)
        ]
        let newInvoice = Invoice(
            id: UUID(),
            date: Date(),
            customerName: "John Doe",
            items: sampleItems,
            totalAmount: 650.0
        )
        viewModel.addInvoice(newInvoice)
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView()
            .environmentObject(InvoiceViewModel())
    }
}

