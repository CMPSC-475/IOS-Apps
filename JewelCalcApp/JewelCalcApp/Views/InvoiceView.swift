//
//  InvoiceView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI
import UIKit

struct InvoiceView: View {
    @EnvironmentObject var viewModel: InvoiceViewModel
    @State private var showingInvoiceForm = false
    @State private var selectedInvoice: Invoice?
    @State private var pdfURLToShare: URL?
    @State private var showingShareSheet = false

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
                        Text("Payment Status: \(invoice.paymentStatus.rawValue)")
                        Text("Due Date: \(invoice.dueDate, formatter: DateFormatter.shortDate)")
                    }
                    .contextMenu {
                        Button(action: {
                            if let pdfURL = viewModel.generatePDF(for: invoice) {
                                pdfURLToShare = pdfURL
                                showingShareSheet = true
                            }
                        }) {
                            Label("Share PDF", systemImage: "square.and.arrow.up")
                        }
                    }
                    .onTapGesture {
                        selectedInvoice = invoice
                        showingInvoiceForm = true
                    }
                }
            }
        }
        .navigationTitle("Invoices")
        .toolbar {
            Button(action: { showingInvoiceForm = true }) {
                Label("Add Invoice", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingInvoiceForm) {
            InvoiceFormView(viewModel: viewModel, invoiceToEdit: selectedInvoice)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let pdfURLToShare = pdfURLToShare {
                ShareSheet(activityItems: [pdfURLToShare])
            }
        }
    }
}



struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView()
            .environmentObject(InvoiceViewModel())
    }
}
