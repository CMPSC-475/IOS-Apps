//
//  PuzzleView.swift
//  Pentominoes
//
// Created by Nandan Hirpara on 09/21/24
//

import Foundation
import SwiftUI

struct PuzzleView: View {
    var puzzleName: String
    var puzzleSolution: [[Int]]  // New variable for puzzle solution

    // Different grid configurations based on the selected puzzle
    var puzzleConfigurations: [String: (rows: Int, cols: Int)] = [
        "6x10": (6, 10),
        "5x12": (5, 12),
        "OneHole": (6, 10),
        "FourNotches": (6, 10),
        "FourHoles": (6, 10),
        "13Holes": (6, 10),
        "Flower": (6, 10)
    ]

    var body: some View {
        // Get the configuration for the selected puzzle
        let configuration = puzzleConfigurations[puzzleName] ?? (6, 10)

        // Render the puzzle grid
        ZStack {
            VStack(spacing: 1) {
                ForEach(0..<configuration.rows, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<configuration.cols, id: \.self) { col in
                            Rectangle()
                                .fill(self.getColorForCell(row: row, col: col))
                                .frame(width: 30, height: 30)
                        }
                    }
                }
            }
        }
        .frame(width: CGFloat(configuration.cols) * 30, height: CGFloat(configuration.rows) * 30)
    }
    
    // New function to determine the background color of each cell
    func getColorForCell(row: Int, col: Int) -> Color {
        if puzzleSolution.indices.contains(row) && puzzleSolution[row].indices.contains(col) {
            return puzzleSolution[row][col] == 1 ? Color.blue : Color.gray.opacity(0.6)
        } else {
            return Color.gray.opacity(0.8)  // Default color for empty/blocked spaces
        }
    }
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView(puzzleName: "6x10", puzzleSolution: Array(repeating: Array(repeating: 0, count: 10), count: 6))
            .frame(width: 300, height: 180)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
