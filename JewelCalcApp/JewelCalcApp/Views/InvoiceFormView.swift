//
//  InvoiceFormView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI

struct InvoiceFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: InvoiceViewModel

    @State private var customerName = ""
    @State private var phoneNumber = ""
    @State private var items: [InvoiceItem] = []
    @State private var newItemDescription = ""
    @State private var newItemCategory = "" // New field for category
    @State private var newItemQuantity = 1
    @State private var newItemPrice = 0.0
    @State private var paymentStatus: PaymentStatus = .unpaid
    @State private var dueDate = Date()

    var invoiceToEdit: Invoice? // Optional parameter for editing

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Information")) {
                    TextField("Customer Name", text: $customerName)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
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

                    VStack {
                        TextField("Description", text: $newItemDescription)
                        TextField("Category", text: $newItemCategory) // Field for category
                        TextField("Price", value: $newItemPrice, format: .number)
                            .keyboardType(.decimalPad)
                        Stepper("Quantity: \(newItemQuantity)", value: $newItemQuantity, in: 1...100)
                        Button("Add") {
                            addItem()
                        }
                    }
                }

                Section(header: Text("Payment Details")) {
                    Picker("Payment Status", selection: $paymentStatus) {
                        ForEach(PaymentStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }

                Button("Save Invoice") {
                    saveInvoice()
                }
            }
            .navigationTitle(invoiceToEdit == nil ? "New Invoice" : "Edit Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let invoice = invoiceToEdit {
                    loadInvoiceDetails(invoice)
                }
            }
        }
    }

    private func addItem() {
        guard !newItemDescription.isEmpty, !newItemCategory.isEmpty, newItemPrice > 0 else { return }
        let newItem = InvoiceItem(
            description: newItemDescription,
            quantity: newItemQuantity,
            price: newItemPrice,
            category: newItemCategory // Pass category here
        )
        items.append(newItem)
        newItemDescription = ""
        newItemCategory = ""
        newItemPrice = 0.0
        newItemQuantity = 1
    }

    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func saveInvoice() {
        guard !customerName.isEmpty, !items.isEmpty else { return }
        let totalAmount = items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let newInvoice = Invoice(
            id: invoiceToEdit?.id ?? UUID(),
            date: Date(),
            customerName: customerName,
            items: items,
            totalAmount: totalAmount,
            paymentStatus: paymentStatus,
            dueDate: dueDate,
            phoneNumber: phoneNumber
        )
        if invoiceToEdit != nil {
            viewModel.updateInvoice(newInvoice)
        } else {
            viewModel.addInvoice(newInvoice)
        }
        dismiss()
    }

    private func loadInvoiceDetails(_ invoice: Invoice) {
        customerName = invoice.customerName
        phoneNumber = invoice.phoneNumber ?? ""
        items = invoice.items
        paymentStatus = invoice.paymentStatus
        dueDate = invoice.dueDate
    }
}


struct InvoiceFormView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceFormView(viewModel: InvoiceViewModel())
    }
}
