//
//  Building.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import Foundation
import CoreLocation

struct Building: Identifiable, Codable {
    var id: UUID = UUID() // A unique identifier for each building
    let opp_bldg_code: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let year_constructed: Int?
    var isSelected: Bool = false
    var isFavorited: Bool = false
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

