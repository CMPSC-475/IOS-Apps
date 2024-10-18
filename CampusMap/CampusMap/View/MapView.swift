//
//  MapView.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last?.coordinate {
            location = newLocation
        }
    }
}


struct MapView: View {
    @ObservedObject var viewModel = BuildingViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var isCenteredOnUser = false

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.displayedBuildings) { building in
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
            .onAppear {
                if let userLocation = locationManager.location {
                    viewModel.region.center = userLocation
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            HStack {
                Spacer(minLength: 0.1)

                Button(action: {
                    if let userLocation = locationManager.location {
                        viewModel.region.center = userLocation
                        isCenteredOnUser = true
                    }
                }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .disabled(isCenteredOnUser)

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
