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
        // Same PDF generation code as before
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
                
                let title = "Invoice"
                title.draw(at: CGPoint(x: 36, y: 36), withAttributes: titleAttributes)
                
                let customerInfo = "Customer: \(invoice.customerName)\nDate: \(invoice.date)"
                customerInfo.draw(at: CGPoint(x: 36, y: 60), withAttributes: textAttributes)
                
                var yOffset: CGFloat = 100
                for item in invoice.items {
                    let itemInfo = "\(item.description) - Qty: \(item.quantity) - $\(item.price)"
                    itemInfo.draw(at: CGPoint(x: 36, y: yOffset), withAttributes: textAttributes)
                    yOffset += 20
                }
                
                let total = "Total Amount: $\(invoice.totalAmount)"
                total.draw(at: CGPoint(x: 36, y: yOffset + 20), withAttributes: titleAttributes)
            }
            return url
        } catch {
            print("Could not create PDF: \(error)")
            return nil
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

