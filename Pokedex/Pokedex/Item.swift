//
//  Item.swift
//  Pokedex
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/28/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
