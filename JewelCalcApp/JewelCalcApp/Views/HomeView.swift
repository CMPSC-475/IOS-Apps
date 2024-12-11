//
//  HomeView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var invoiceViewModel = InvoiceViewModel()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: InventoryView()
                    .environmentObject(InventoryViewModel()) // Ensure the EnvironmentObject is passed
                ) {
                    Text("Inventory Management")
                }
                NavigationLink(destination: CostCalculatorView()) {
                    Text("Jewelry Cost Calculator")
                }
                NavigationLink(destination: InvoiceView().environmentObject(invoiceViewModel)) {
                    Text("Invoice Generation")
                }
                
                NavigationLink(destination: DashboardView()
                    .environmentObject(InventoryViewModel())
                    .environmentObject(InvoiceViewModel())
                ) {
                    Text("Analytics Dashboard")
                }

            }
            .navigationTitle("JewelCalc")
        }
    }
}


#Preview {
    HomeView()
}
