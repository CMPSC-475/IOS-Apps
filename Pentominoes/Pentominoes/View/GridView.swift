//
//  GridView.swift
//  Pentominoes
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/1/24.
//

import Foundation
import SwiftUI

struct GridView: View {
    let puzzle: PuzzleOutline

    var body: some View {
        GeometryReader { geometry in
            let gridWidth = geometry.size.width / CGFloat(puzzle.size.width)
            let gridHeight = geometry.size.height / CGFloat(puzzle.size.height)
            
            ForEach(0..<puzzle.size.height, id: \.self) { row in
                ForEach(0..<puzzle.size.width, id: \.self) { col in
                    Rectangle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: gridWidth, height: gridHeight)
                        .position(x: gridWidth * CGFloat(col) + gridWidth / 2,
                                  y: gridHeight * CGFloat(row) + gridHeight / 2)
                }
            }
        }
    }
}


struct PuzzleOutline: Codable {
    struct Size: Codable {
        let width: Int
        let height: Int
    }
    
    struct Point: Codable {
        let x: Int
        let y: Int
    }
    
    let name: String
    let size: Size
    let outlines: [[Point]]
}

func loadPuzzleOutlines() -> [PuzzleOutline] {
    guard let url = Bundle.main.url(forResource: "PuzzleOutlines", withExtension: "json") else {
        fatalError("Could not find PuzzleOutlines.json")
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let puzzleOutlines = try decoder.decode([PuzzleOutline].self, from: data)
        return puzzleOutlines
    } catch {
        fatalError("Error parsing PuzzleOutlines.json: \(error)")
    }
}
