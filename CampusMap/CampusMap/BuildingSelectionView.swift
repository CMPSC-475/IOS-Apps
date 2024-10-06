//
//  BuildingSelectionView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import Foundation
import SwiftUI

struct BuildingSelectionView: View {
    @ObservedObject var viewModel: BuildingViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.buildings) { building in
                    HStack {
                        Toggle(isOn: Binding<Bool>(
                            get: { building.isSelected },
                            set: { _ in viewModel.toggleBuildingSelection(building) }
                        )) {
                            Text(building.name)
                        }
                        
                        if building.isFavorited {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
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
