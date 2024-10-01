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

        // Render a grid using the configuration
        ZStack {
            Grid(rows: configuration.rows, columns: configuration.cols)
                .stroke(Color.black, lineWidth: 1)

            // Optionally, you can fill some areas of the grid (like blocked-out areas in puzzles)
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: CGFloat(configuration.cols) * 30, height: CGFloat(configuration.rows) * 30)
        }
        .frame(width: CGFloat(configuration.cols) * 30, height: CGFloat(configuration.rows) * 30)  // Adjust frame size dynamically
    }
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView(puzzleName: "6x10")
            .frame(width: 300, height: 180)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
