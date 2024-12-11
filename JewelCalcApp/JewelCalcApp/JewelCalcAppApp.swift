//
//  JewelCalcAppApp.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/4/24.
//

import SwiftUI
import UserNotifications

@main
struct JewelCalcApp: App {
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @StateObject private var invoiceViewModel = InvoiceViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(inventoryViewModel) // Inject the view model here
                .environmentObject(invoiceViewModel)
                .onAppear {
                    updateAppearance()
                }

        }
    }
    
    
    private func updateAppearance() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            print("Permission granted: \(granted)")
        }
        return true
    }
}
