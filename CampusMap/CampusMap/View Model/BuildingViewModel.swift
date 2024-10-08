//
//  BuildingViewModel.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import SwiftUI
import MapKit

class BuildingViewModel: ObservableObject {
    @Published var buildings: [Building] = []
    @Published var selectedBuildings: [Building] = []
    @Published var region: MKCoordinateRegion
    @Published var showingDetail: Bool = false
    @Published var selectedBuilding: Building?
    @Published var showingFavorites: Bool = false // Track if favorites are being shown

    private let userDefaultsKey = "selectedBuildings"

    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.798214, longitude: -77.859909),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
        
        loadBuildings()
        loadPersistedData()
    }
    
    // Load buildings from buildings.json
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
    
    // Get displayed buildings based on current state
    var displayedBuildings: [Building] {
        showingFavorites ? buildings.filter { $0.isFavorited } : selectedBuildings
    }

    // Toggle the display mode between showing selected and favorited buildings
    func toggleFavoriteDisplay() {
        showingFavorites.toggle()
        updateSelectedBuildings() // Update the selected buildings based on current selection
    }

    // Deselect all buildings
    func deselectAllBuildings() {
        for index in buildings.indices {
            buildings[index].isSelected = false
        }
        selectedBuildings.removeAll()
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
            objectWillChange.send()
        }
    }

    func persistSelectedBuildings() {
        let selectedCodes = selectedBuildings.map { $0.opp_bldg_code }
        UserDefaults.standard.set(selectedCodes, forKey: userDefaultsKey)
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
}
