//
//  BuildingDetailView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI

struct BuildingDetailView: View {
    var building: Building
    @ObservedObject var viewModel: BuildingViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text(building.name)
                .font(.largeTitle)
                .padding()

            if let photo = building.photo {
                Image(photo)
                    .resizable()
                    .scaledToFit()
            }

            Text("Year Constructed: \(building.year_constructed ?? 0)")
                .padding()

            HStack {
                Button("Set as Start") {
                    viewModel.setRoutePoint(building.coordinate, asStart: true)
                    viewModel.showingRoute = true
                }
                .padding()

                Button("Set as End") {
                    viewModel.setRoutePoint(building.coordinate, asStart: false)
                    viewModel.showingRoute = true
                }
                .padding()
                
                Button("Dismiss") {
                                dismiss()
                            }
                            .padding()
                            .foregroundColor(.blue)
            }
            
            HStack {

                Button("Set Current Location as Start") {
                    if let userLocation = viewModel.userLocation {
                        viewModel.setRoutePoint(userLocation, asStart: true)
                    }
                }
                
                .padding()

                Button("Set Current Location as End") {
                    if let userLocation = viewModel.userLocation {
                        viewModel.setRoutePoint(userLocation, asStart: false)
                    }
                }


                .padding()
                .foregroundColor(.blue)
            }
        }
        .navigationBarTitle("Building Details", displayMode: .inline)
    }
}
