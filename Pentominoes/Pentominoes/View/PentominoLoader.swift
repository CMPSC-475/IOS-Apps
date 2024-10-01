//
//  PentominoLoader.swift
//  Pentominoes
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/1/24.
//

import Foundation

// Function to load pentomino outlines from JSON
func loadPentominoOutlines() -> [PentominoOutline] {
    guard let url = Bundle.main.url(forResource: "PentominoOutlines", withExtension: "json") else {
        fatalError("Unable to find PentominoOutlines.json in the bundle")
    }
    
    do {
        let data = try Data(contentsOf: url)
        let outlines = try JSONDecoder().decode([PentominoOutline].self, from: data)
        return outlines
    } catch {
        fatalError("Failed to load Pentomino outlines: \(error)") // Error handling
    }
}
