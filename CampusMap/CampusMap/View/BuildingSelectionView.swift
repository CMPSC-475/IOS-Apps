//
//  BuildingSelectionView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI

struct BuildingSelectionView: View {
    @ObservedObject var viewModel: BuildingViewModel

    var body: some View {
        NavigationView {
            List {
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(BuildingFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ForEach(viewModel.displayedBuildings.sorted(by: { $0.name < $1.name })) { building in
                    HStack {
                        Toggle(isOn: Binding<Bool>(
                            get: { building.isSelected },
                            set: { _ in viewModel.toggleBuildingSelection(building) }
                        )) {
                            Text(building.name)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.toggleFavoriteStatus(building)
                        }) {
                            Image(systemName: building.isFavorited ? "heart.fill" : "heart")
                                .foregroundColor(building.isFavorited ? .red : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationBarTitle("Select Buildings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                viewModel.showingDetail = false
            })
        }
    }
}
