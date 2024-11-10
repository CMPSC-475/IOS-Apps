//
//  HomeView.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("Inventory Management", destination: InventoryView())
                NavigationLink("Jewelry Cost Calculator", destination: CalculatorView())
                NavigationLink("Invoice Generator", destination: InvoiceView())
                NavigationLink("Messaging", destination: MessagingView())
            }
            .navigationTitle("JewelCalc")
        }
    }
}

#Preview {
    HomeView()
}
