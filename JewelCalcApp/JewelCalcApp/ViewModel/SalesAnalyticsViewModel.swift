//
//  SalesAnalyticsViewModel.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import Foundation

class SalesAnalyticsViewModel: ObservableObject {
    @Published var filteredInvoices: [Invoice] = []
    @Published var totalSales: Double = 0.0
    @Published var salesByCategory: [String: Double] = [:]
    @Published var salesOverTime: [(Date, Double)] = []

    private var allInvoices: [Invoice]

    init(invoices: [Invoice]) {
        self.allInvoices = invoices
    }

    func filterInvoices(by startDate: Date, endDate: Date, category: String?) {
        filteredInvoices = allInvoices.filter { invoice in
            let withinDateRange = invoice.date >= startDate && invoice.date <= endDate
            let matchesCategory = category == nil || invoice.items.contains { $0.category == category }
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

