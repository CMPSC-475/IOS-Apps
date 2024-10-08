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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {

            if let photoName = building.photo, let uiImage = UIImage(named: photoName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200) 
                    .clipped()
            } else {

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200) 
                    .overlay(Text("No Image Available").foregroundColor(.white))
            }
            
            Text(building.name)
                .font(.title)
            
            if let year = building.year_constructed {
                Text("Year of Construction \(year)")
                    .font(.subheadline)
            }
            
            Button(action: {
                viewModel.toggleFavoriteStatus(building)
            }) {
                Label(building.isFavorited ? "Unfavorite" : "Favorite", systemImage: building.isFavorited ? "heart.fill" : "heart")
            }
            .padding()
            
            Button("Dismiss") {
                dismiss()
            }
            .padding()
            .foregroundColor(.blue)
        }
        .padding()
    }
}
