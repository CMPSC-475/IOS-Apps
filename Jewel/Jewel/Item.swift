//
//  Item.swift
//  Jewel
//
//  Created by Hirpara, Nandan Ashvinbhai on 11/10/24.
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
