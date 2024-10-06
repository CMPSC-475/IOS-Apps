//
//  BuildingDetailView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import Foundation
import SwiftUI

struct BuildingDetailView: View {
    var building: Building
    @ObservedObject var viewModel: BuildingViewModel

    var body: some View {
        VStack {
            Text(building.name)
                .font(.title)
            
            if let year = building.year_constructed {
                Text("Constructed in \(year)")
                    .font(.subheadline)
            }
            
            Button(action: {
                viewModel.toggleFavoriteStatus(building)
            }) {
                Label(building.isFavorited ? "Unfavorite" : "Favorite", systemImage: building.isFavorited ? "heart.fill" : "heart")
            }
            .padding()
        }
    }
}
