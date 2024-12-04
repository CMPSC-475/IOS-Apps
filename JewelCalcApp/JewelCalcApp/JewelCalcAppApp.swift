//
//  JewelCalcAppApp.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI

@main
struct JewelCalcApp: App {
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @StateObject private var invoiceViewModel = InvoiceViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(inventoryViewModel) // Inject the view model here
                .environmentObject(invoiceViewModel)
        }
    }
}

