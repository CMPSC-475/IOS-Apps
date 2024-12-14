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
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    // Inventory Management Tile
                    NavigationLink(destination: InventoryView()
                        .environmentObject(InventoryViewModel()) // Ensure EnvironmentObject is passed
                    ) {
                        TileView(icon: "archivebox.fill", title: "Inventory Management", color: .blue)
                    }
                    
                    // Jewelry Cost Calculator Tile
                    NavigationLink(destination: CostCalculatorView()) {
                        TileView(icon: "dollarsign.circle.fill", title: "Jewelry Cost Calculator", color: .purple)
                    }
                    
                    // Invoice Generation Tile
                    NavigationLink(destination: InvoiceView().environmentObject(invoiceViewModel)) {
                        TileView(icon: "doc.text.fill", title: "Invoice Generation", color: .green)
                    }
                    
                    // Messaging Tile
                    NavigationLink(destination: MessagingView(invoices: invoiceViewModel.invoices)) {
                        TileView(icon: "message.fill", title: "Messaging", color: .orange)
                    }
                    
                    // Analytics Dashboard Tile
                    NavigationLink(destination: AnalyticsDashboardView(invoices: invoiceViewModel.invoices)) {
                        TileView(icon: "chart.bar.fill", title: "Analytics Dashboard", color: .red)
                    }
                }
                .padding()
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

// Reusable TileView for the grid items
struct TileView: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding()
                .background(color)
                .clipShape(Circle())
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    HomeView()
}

