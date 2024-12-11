//
//  HomeView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var invoiceViewModel = InvoiceViewModel()
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @State private var showingPreferences = false
    
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
                
                NavigationLink(destination: MessagingView(invoices: invoiceViewModel.invoices)) {
                    Text("Messaging")
                }

            }
            .navigationTitle("JewelCalc")
            .toolbar {
                Button(action: { showingPreferences = true }) {
                    Label("Preferences", systemImage: "gear")
                }
            }
            .sheet(isPresented: $showingPreferences) {
                PreferencesView()
            }
            .onAppear {
                inventoryViewModel.checkLowInventory()
                invoiceViewModel.checkPendingInvoices()
            }
        }
    }
}


#Preview {
    HomeView()
}
