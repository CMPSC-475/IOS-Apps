//
//  AnalyticsDashboardView.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import SwiftUI
import Charts

struct AnalyticsDashboardView: View {
    @StateObject private var viewModel: SalesAnalyticsViewModel

    init(invoices: [Invoice]) {
        _viewModel = StateObject(wrappedValue: SalesAnalyticsViewModel(invoices: invoices))
    }

    var body: some View {
        VStack {
            // Filters
            Form {
                Section(header: Text("Filters")) {
                    DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        Text("All Categories").tag(nil as String?)
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category as String?)
                        }
                    }
                    Button("Apply Filters") {
                        viewModel.filterInvoices()
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
                        x: .value("Date", dataPoint.0),
                        y: .value("Sales", dataPoint.1)
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Analytics Dashboard")
    }
}
