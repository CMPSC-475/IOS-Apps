//
//  InvoiceView.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
//

import SwiftUI
import PDFKit
import UIKit

struct InvoiceView: View {
    @State private var customerName = ""
    @State private var items: [JewelryItem] = [
        JewelryItem(name: "Diamond Ring", quantity: 2),
        JewelryItem(name: "Gold Necklace", quantity: 1)
    ]
    @State private var totalCost: Double = 1500.0

    var body: some View {
        Form {
            Section(header: Text("Customer Information")) {
                TextField("Customer Name", text: $customerName)
            }
            
            Section(header: Text("Items")) {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("Qty: \(item.quantity)")
                    }
                }
            }
            
            Section(header: Text("Total Cost")) {
                Text("Total: $\(totalCost, specifier: "%.2f")")
            }
        }
        .navigationTitle("Invoice Generator")
        .navigationBarItems(trailing: Button("Generate & Share Invoice") {
            shareInvoice()
        })
    }
    
    // Function to generate PDF of the Invoice
    func generateInvoicePDF() -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "JewelCalc",
            kCGPDFContextAuthor: "Your Company Name",
            kCGPDFContextTitle: "Invoice"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let fileName = "\(UUID().uuidString).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let pageWidth: CGFloat = 8.5 * 72.0
        let pageHeight: CGFloat = 11 * 72.0
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        do {
            try renderer.writePDF(to: url, withActions: { (context) in
                context.beginPage()
                
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 18)
                ]
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14)
                ]
                
                // Invoice Title
                let title = "Invoice for \(customerName)"
                title.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)
                
                // Customer and Items Section
                var yOffset: CGFloat = 60
                for item in items {
                    let itemText = "\(item.name) - Qty: \(item.quantity)"
                    itemText.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: textAttributes)
                    yOffset += 20
                }
                
                // Total Cost
                let totalText = "Total: $\(totalCost)"
                totalText.draw(at: CGPoint(x: 20, y: yOffset + 20), withAttributes: textAttributes)
            })
            
            return url
        } catch {
            print("Could not create PDF file: \(error)")
            return nil
        }
    }
    
    // Function to share the generated PDF
    func shareInvoice() {
        if let pdfURL = generateInvoicePDF() {
            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}


