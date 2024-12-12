//
//  MetalRateManager.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/12/24.
//

import Foundation

class MetalRateManager: ObservableObject {
    static let shared = MetalRateManager()

    @Published var ratesByPurity: [String: Float] = [:]

    private init() {}
}

