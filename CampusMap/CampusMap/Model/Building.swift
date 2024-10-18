//
//  Building.swift
//  CampusMap
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/6/24.
//

import Foundation
import CoreLocation

struct Building: Codable, Identifiable {
    var id: Int {
        opp_bldg_code
    }
    
    let latitude: Double
    let longitude: Double
    let name: String
    let opp_bldg_code: Int
    let year_constructed: Int?
    let photo: String?
    var isSelected: Bool = false
    var isFavorited: Bool = false
    var isRouteStart: Bool = false
    var isRouteEnd: Bool = false
    var isDisplayedOnMap: Bool = false
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    private enum CodingKeys: String, CodingKey {
        case name, latitude, longitude, opp_bldg_code, year_constructed, photo
    }
}


