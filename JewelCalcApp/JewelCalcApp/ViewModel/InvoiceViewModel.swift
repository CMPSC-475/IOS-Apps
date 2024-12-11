//
//  InvoiceViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import Foundation
import UIKit

class InvoiceViewModel: ObservableObject {
    @Published var invoices: [Invoice] = [] {
        didSet {
            saveInvoices()
        }
    }

    private let invoicesFileURL: URL

    init() {
        // Set up the file URL for saving and loading
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        invoicesFileURL = documentsDirectory.appendingPathComponent("invoices.json")
        loadInvoices()
    }

    func addInvoice(_ invoice: Invoice) {
        invoices.append(invoice)
    }

    func generatePDF(for invoice: Invoice) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "JewelCalc",
            kCGPDFContextAuthor: "JewelCalc App",
            kCGPDFContextTitle: "Invoice"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Invoice-\(invoice.id).pdf")

        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()

                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 18)
                ]
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12)
                ]
                let headerAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 14)
                ]

                let title = "Invoice"
                title.draw(at: CGPoint(x: 36, y: 36), withAttributes: titleAttributes)

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short

                let customerInfo = """
                Customer: \(invoice.customerName)
                Date: \(dateFormatter.string(from: invoice.date))
                Payment Status: \(invoice.paymentStatus.rawValue)
                Due Date: \(dateFormatter.string(from: invoice.dueDate))
                """
                customerInfo.draw(at: CGPoint(x: 36, y: 60), withAttributes: textAttributes)

                var yOffset: CGFloat = 140
                let itemHeader = "Items"
                itemHeader.draw(at: CGPoint(x: 36, y: yOffset), withAttributes: headerAttributes)

                yOffset += 20
                for item in invoice.items {
                    let itemInfo = "\(item.description) - Qty: \(item.quantity) - $\(String(format: "%.2f", item.price))"
                    itemInfo.draw(at: CGPoint(x: 36, y: yOffset), withAttributes: textAttributes)
                    yOffset += 20
                }

                let total = "Total Amount: $\(String(format: "%.2f", invoice.totalAmount))"
                total.draw(at: CGPoint(x: 36, y: yOffset + 20), withAttributes: titleAttributes)
            }
            return url
        } catch {
            print("Could not create PDF: \(error)")
            return nil
        }
    }



    // Method to update an invoice
    func updateInvoice(_ updatedInvoice: Invoice) {
        if let index = invoices.firstIndex(where: { $0.id == updatedInvoice.id }) {
            invoices[index] = updatedInvoice
        }
    }
    
    private func saveInvoices() {
        do {
            let data = try JSONEncoder().encode(invoices)
            try data.write(to: invoicesFileURL)
        } catch {
            print("Failed to save invoices: \(error)")
        }
    }

    private func loadInvoices() {
        do {
            let data = try Data(contentsOf: invoicesFileURL)
            invoices = try JSONDecoder().decode([Invoice].self, from: data)
        } catch {
            print("No saved invoices found or failed to load: \(error)")
            invoices = []
        }
    }
}

extension InvoiceViewModel {
    var monthlyInvoiceTotals: [String: Double] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return invoices.reduce(into: [:]) { totals, invoice in
            let month = dateFormatter.string(from: invoice.date)
            totals[month, default: 0] += invoice.totalAmount
        }
    }
}
