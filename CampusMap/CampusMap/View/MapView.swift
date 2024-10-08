//
//  MapView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel = BuildingViewModel()

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.displayedBuildings) { building in
                MapAnnotation(coordinate: building.coordinate) {
                    VStack {
                        Circle()
                            .fill(building.isFavorited ? Color.red : Color.blue)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                viewModel.selectedBuilding = building
                            }

                        Text(building.name)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            HStack {
                Spacer(minLength: 0.1)
                Button(action: {
                    viewModel.toggleFavoriteDisplay()
                }) {
                    Image(systemName: viewModel.showingFavorites ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.showingFavorites ? .red : .gray)
                        .font(.title)
                }

                Spacer()
                

                Button("Select Buildings") {
                    viewModel.showingDetail = true
                }
                .font(.title)
                .sheet(isPresented: $viewModel.showingDetail) {
                    BuildingSelectionView(viewModel: viewModel)
                }

                Spacer(minLength: 0.1)

                Button(action: {
                    viewModel.deselectAllBuildings()
                }) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                Spacer()
                
            }

            .sheet(item: $viewModel.selectedBuilding) { building in
                BuildingDetailView(building: building, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MapView()
}
