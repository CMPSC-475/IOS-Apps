//
//  MapView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = BuildingViewModel()

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.selectedBuildings) { building in
                MapMarker(coordinate: building.coordinate, tint: building.isFavorited ? .red : .blue)
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                viewModel.showingDetail = true
            }
            .sheet(item: $viewModel.selectedBuilding) { building in
                BuildingDetailView(building: building, viewModel: viewModel)
            }
            
            Button("Select Buildings") {
                viewModel.showingDetail = true
            }
            .sheet(isPresented: $viewModel.showingDetail) {
                BuildingSelectionView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MapView()
}
