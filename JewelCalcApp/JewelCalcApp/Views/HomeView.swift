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
            ZStack {
                // Purple gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
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
            }
            .navigationTitle("PANROSA JEWELS")
            .gridCellAnchor(.center)
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

struct TileView: View {
    let icon: String
    let title: String
    let color: Color // New parameter for icon color
    
    var body: some View {
        VStack {
            // Icon with custom color
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color) // Use the color passed in
                .padding()
                .background(color.opacity(0.2)) // Light background of the same color
                .clipShape(Circle())
            
            // Title with darker font
            Text(title)
                .font(.headline)
                .foregroundColor(.black) // Darker color for visibility
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140) // Increased minHeight for better spacing
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4) // Darker, deeper shadow
    }
}


#Preview {
    HomeView()
}
