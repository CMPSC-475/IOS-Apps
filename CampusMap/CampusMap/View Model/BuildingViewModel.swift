//
//  BuildingViewModel.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

class BuildingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var buildings: [Building] = []
    @Published var selectedBuildings: [Building] = []
    @Published var region: MKCoordinateRegion
    @Published var showingDetail: Bool = false
    @Published var selectedBuilding: Building?
    @Published var showingFavorites: Bool = false
    @Published var showingRoute: Bool = false
    @Published var route: MKRoute?
    @Published var routeSteps: [MKRoute.Step] = []
    @Published var currentStepIndex: Int = 0
    @Published var expectedTravelTime: TimeInterval = 0
    @Published var isMapCentered: Bool = false
    @Published var isCenterButtonDisabled: Bool = false
    @Published var routeStart: CLLocationCoordinate2D?
    @Published var routeEnd: CLLocationCoordinate2D?
    @Published var selectedFilter: BuildingFilter = .all
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var mapCenter: CLLocationCoordinate2D?
    @Published var shouldDisplayBuildings: Bool = false
    
    var mapView: MKMapView?
    
    private let userDefaultsKey = "selectedBuildings"
    private let favoritesUserDefaultsKey = "favoritedBuildings"

    // Location Manager
    private var locationManager: CLLocationManager?

    override init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.798214, longitude: -77.859909),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        self.locationManager = CLLocationManager()
        super.init()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()

        loadBuildings()
        loadPersistedData()
        loadPersistedFavorites()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        if mapCenter == nil {
            mapCenter = location.coordinate
        }
        if isMapCentered {
            region.center = location.coordinate
        }
    }


    func mapViewDidChangeVisibleRegion() {
        isCenterButtonDisabled = false
        isMapCentered = false
    }

    func loadBuildings() {
        if let url = Bundle.main.url(forResource: "buildings", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                do {
                    buildings = try decoder.decode([Building].self, from: data)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    }

    func applyFilter() {
        switch selectedFilter {
        case .all:
            shouldDisplayBuildings = false
        default:
            shouldDisplayBuildings = true
        }
        objectWillChange.send()
    }
    
    var displayedBuildings: [Building] {
        switch selectedFilter {
        case .all:
            return buildings.filter { !$0.isHidden }
        case .favorited:
            return buildings.filter { $0.isFavorited && !$0.isHidden }
        case .selected:
            return selectedBuildings.filter {!$0.isHidden }
        case .nearby:
            return nearbyBuildings(maxDistance: 500).filter { !$0.isHidden }
        }
    }

    func nearbyBuildings(maxDistance: Double) -> [Building] {
        guard let userLocation = locationManager?.location else { return [] }
        return buildings.filter { building in
            let buildingLocation = CLLocation(latitude: building.latitude, longitude: building.longitude)
            return userLocation.distance(from: buildingLocation) <= maxDistance
        }
    }

    func toggleFavoriteDisplay() {
        showingFavorites.toggle()
        updateSelectedBuildings()
    }

    func deselectAllBuildings() {
        for index in buildings.indices {
            buildings[index].isSelected = false
        }
        selectedBuildings.removeAll()
        persistSelectedBuildings()
    }

    func toggleBuildingSelection(_ building: Building) {
        if let index = buildings.firstIndex(where: { $0.opp_bldg_code == building.opp_bldg_code }) {
            buildings[index].isSelected.toggle()
            updateSelectedBuildings()
        }
    }

    func updateSelectedBuildings() {
        selectedBuildings = buildings.filter { $0.isSelected }
        persistSelectedBuildings()
    }

    func toggleFavoriteStatus(_ building: Building) {
        if let index = buildings.firstIndex(where: { $0.opp_bldg_code == building.opp_bldg_code }) {
            buildings[index].isFavorited.toggle()
            persistFavoriteBuildings()
        }
    }

    func persistSelectedBuildings() {
        let selectedCodes = selectedBuildings.map { $0.opp_bldg_code }
        UserDefaults.standard.set(selectedCodes, forKey: userDefaultsKey)
    }

    func persistFavoriteBuildings() {
        let favoritedCodes = buildings.filter { $0.isFavorited }.map { $0.opp_bldg_code }
        UserDefaults.standard.set(favoritedCodes, forKey: favoritesUserDefaultsKey)
    }

    func loadPersistedData() {
        if let selectedCodes = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            buildings = buildings.map { building in
                var mutableBuilding = building
                mutableBuilding.isSelected = selectedCodes.contains(building.opp_bldg_code)
                return mutableBuilding
            }
            updateSelectedBuildings()
        }
    }

    func loadPersistedFavorites() {
        if let favoritedCodes = UserDefaults.standard.array(forKey: favoritesUserDefaultsKey) as? [Int] {
            buildings = buildings.map { building in
                var mutableBuilding = building
                mutableBuilding.isFavorited = favoritedCodes.contains(building.opp_bldg_code)
                return mutableBuilding
            }
        }
    }
    
    func setRoutePoint(_ coordinate: CLLocationCoordinate2D, asStart: Bool) {
        if asStart {
            routeStart = coordinate
            print("Start Point Set: \(coordinate)")
        } else {
            routeEnd = coordinate
            print("End Point Set: \(coordinate)")
        }
        if routeStart != nil && routeEnd != nil {
            calculateRoute()
        }
    }

    func calculateRoute() {
        guard let start = routeStart, let end = routeEnd else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = true

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self?.route = route
                    self?.routeSteps = route.steps.filter { !$0.instructions.isEmpty }
                    self?.expectedTravelTime = route.expectedTravelTime
                    self?.currentStepIndex = 0
                    self?.showingRoute = true
                }
            } else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }



    // Function to hide displayed buildings
    func hideDisplayedBuildings() {
        for index in buildings.indices {
            if displayedBuildings.contains(where: { $0.opp_bldg_code == buildings[index].opp_bldg_code }) {
                buildings[index].isHidden = true
            }
        }
    }

    // Function to show all buildings again
    func showAllBuildings() {
        for index in buildings.indices {
            buildings[index].isHidden = false
        }
    }
    
}

enum BuildingFilter: String, CaseIterable {
    case all = "All"
    case favorited = "Favorited"
    case selected = "Selected"
    case nearby = "Nearby"
}
