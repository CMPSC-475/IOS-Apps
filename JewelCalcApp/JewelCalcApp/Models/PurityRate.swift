//
//  PurityRate.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/12/24.
//

import SwiftUI

class PurityRate: ObservableObject, Identifiable {
    let id = UUID()
    let purity: String
    @Published var percentage: Float

    init(purity: String, percentage: Float) {
        self.purity = purity
        self.percentage = percentage
    }
}

