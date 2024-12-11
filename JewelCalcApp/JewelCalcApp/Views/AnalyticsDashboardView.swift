//
//  AnalyticsDashboardView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI
import Charts

struct AnalyticsDashboardView: View {
    @StateObject private var viewModel = SalesAnalyticsViewModel(invoices: sampleInvoices)
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    @State private var endDate = Date()
    @State private var selectedCategory: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Filters
                Form {
                    Section(header: Text("Filters")) {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        Picker("Category", selection: $selectedCategory) {
                            Text("All Categories").tag(nil as String?)
                            ForEach(["Jewelry", "Gemstones", "Gold", "Silver"], id: \.self) { category in
                                Text(category).tag(category as String?)
                            }
                        }
                        Button("Apply Filters") {
                            viewModel.filterInvoices(by: startDate, endDate: endDate, category: selectedCategory)
                        }
                    }
                }

                // Sales Summary
                VStack(alignment: .leading) {
                    Text("Total Sales: $\(viewModel.totalSales, specifier: "%.2f")")
                        .font(.headline)
                    Text("Sales by Category")
                        .font(.subheadline)

                    List(viewModel.salesByCategory.keys.sorted(), id: \.self) { category in
                        let sales = viewModel.salesByCategory[category] ?? 0
                        HStack {
                            Text(category)
                            Spacer()
                            Text("$\(sales, specifier: "%.2f")")
                        }
                    }
                }
                .padding()

                // Sales Trends Chart
                VStack {
                    Text("Sales Over Time")
                        .font(.headline)

                    Chart(viewModel.salesOverTime, id: \.0) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.0, unit: .day),
                            y: .value("Sales", dataPoint.1)
                        )
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { date in
                            AxisValueLabel(format: .dateTime.month(.wide).day())
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Analytics Dashboard")
        }
    }
}

let sampleInvoices: [Invoice] = [
    Invoice(
        id: UUID(),
        date: Date(),
        customerName: "John Doe",
        items: [
            InvoiceItem(description: "Gold Ring", quantity: 2, price: 500.0, category: "Jewelry")
        ],
        totalAmount: 1000.0,
        paymentStatus: .paid,
        dueDate: Date()
    )
]

