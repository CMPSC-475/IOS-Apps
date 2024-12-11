//
//  SalesAnalyticsViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import Foundation

class SalesAnalyticsViewModel: ObservableObject {
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var selectedCategory: String? = nil
    @Published var filteredInvoices: [Invoice] = []
    @Published var totalSales: Double = 0.0
    @Published var salesByCategory: [String: Double] = [:]
    @Published var salesOverTime: [(Date, Double)] = []

    private var allInvoices: [Invoice]
    var categories: [String] // List of unique categories

    init(invoices: [Invoice]) {
        self.allInvoices = invoices
        self.categories = Array(Set(invoices.flatMap { $0.items.map { $0.category } }))
        let today = Date()
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        self.endDate = today
        filterInvoices()
    }

    func filterInvoices() {
        filteredInvoices = allInvoices.filter { invoice in
            let withinDateRange = invoice.date >= startDate && invoice.date <= endDate
            let matchesCategory = selectedCategory == nil || invoice.items.contains { $0.category == selectedCategory }
            return withinDateRange && matchesCategory
        }

        calculateSalesMetrics()
    }

    private func calculateSalesMetrics() {
        totalSales = filteredInvoices.reduce(0) { total, invoice in
            total + invoice.totalAmount
        }

        salesByCategory = filteredInvoices
            .flatMap { $0.items }
            .reduce(into: [:]) { result, item in
                result[item.category, default: 0] += item.price * Double(item.quantity)
            }

        salesOverTime = filteredInvoices
            .reduce(into: [:]) { result, invoice in
                let day = Calendar.current.startOfDay(for: invoice.date)
                result[day, default: 0] += invoice.totalAmount
            }
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value) }
    }
}
