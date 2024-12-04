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
    @State private var showingInvoiceForm = false // New state for showing form

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
            Button(action: { showingInvoiceForm.toggle() }) {
                Label("Add Invoice", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingInvoiceForm) {
            InvoiceFormView(viewModel: viewModel)
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
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView()
            .environmentObject(InvoiceViewModel())
    }
}


struct InvoiceFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: InvoiceViewModel

    @State private var customerName = ""
    @State private var items: [InvoiceItem] = []
    @State private var newItemDescription = ""
    @State private var newItemQuantity = 1
    @State private var newItemPrice = 0.0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Information")) {
                    TextField("Customer Name", text: $customerName)
                }

                Section(header: Text("Items")) {
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            Text(items[index].description)
                            Spacer()
                            Text("Qty: \(items[index].quantity)")
                            Text("$\(items[index].price, specifier: "%.2f")")
                        }
                    }
                    .onDelete(perform: deleteItem)

                    HStack {
                        TextField("Description", text: $newItemDescription)
                        TextField("Price", value: $newItemPrice, format: .number)
                            .keyboardType(.decimalPad)
                        Stepper("Qty: \(newItemQuantity)", value: $newItemQuantity, in: 1...100)
                        Button("Add") {
                            addItem()
                        }
                    }
                }

                Button("Save Invoice") {
                    saveInvoice()
                }
            }
            .navigationTitle("New Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addItem() {
        guard !newItemDescription.isEmpty, newItemPrice > 0 else { return }
        let newItem = InvoiceItem(description: newItemDescription, quantity: newItemQuantity, price: newItemPrice)
        items.append(newItem)
        newItemDescription = ""
        newItemPrice = 0.0
        newItemQuantity = 1
    }

    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func saveInvoice() {
        guard !customerName.isEmpty, !items.isEmpty else { return }
        let totalAmount = items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let newInvoice = Invoice(id: UUID(), date: Date(), customerName: customerName, items: items, totalAmount: totalAmount)
        viewModel.addInvoice(newInvoice)
        dismiss()
    }
}

struct InvoiceFormView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceFormView(viewModel: InvoiceViewModel())
    }
}


