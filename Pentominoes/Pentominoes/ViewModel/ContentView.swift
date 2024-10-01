//
//  ContentView.swift
//  Pentominoes
//
//  Created by Nandan Hirpara on 09/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPuzzle = "6x10"  // Default puzzle
    @State private var puzzleSolution: [[Int]] = Array(repeating: Array(repeating: 0, count: 10), count: 6)  // Default solution grid
    private var puzzleOutlines: [PuzzleOutline] = loadPuzzleOutlines()  // Load the puzzle outlines
    private var pentominoOutlines: [PentominoOutline] = loadPentominoOutlines()
    @State private var pentominoPieces: [PentominoPiece] = loadPentominoOutlines().map { PentominoPiece(outline: $0) }

    
    var body: some View {
        VStack {
            // Top Area: Puzzle Board and Options
            HStack {
                // Left Puzzle Selection Buttons (0-3)
                VStack {
                    ForEach(0..<4) { index in
                        Button(action: {
                            changePuzzle(index: index)
                        }) {
                            Image("Board\(index)")  // Show image on the button
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .border(Color.black, width: 1)
                        }
                        .padding(.bottom, 10)
                    }
                }
                .frame(width: 120)
                
                Spacer()

                // Puzzle Board Display
                ZStack {
                    Grid(rows: 14, columns: 14)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 420, height: 420)

                    PuzzleView(puzzleName: selectedPuzzle, puzzleSolution: puzzleSolution)
                        .frame(width: 300, height: 180)
                }

                Spacer()

                // Right Puzzle Selection Buttons (4-7)
                VStack {
                    ForEach(4..<8) { index in
                        Button(action: {
                            changePuzzle(index: index)
                        }) {
                            Image("Board\(index)")  // Show image on the button
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .border(Color.black, width: 1)
                        }
                        .padding(.bottom, 10)
                    }
                }
                .frame(width: 120)
            }
            .padding()

            // Middle Area: Reset and Solve Buttons
            HStack {
                Button("Reset") {
                    resetGame()
                }
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
                
                Spacer()
                
                Button("Solve") {
                    solveGame()
                }
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            .padding()

            // Bottom Area: Pentomino Pieces
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<4) { column in
                            let index = row * 4 + column
                            if index < pentominoPieces.count {  // Check to avoid out of bounds
                                PentominoView(piece: $pentominoPieces[index])
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.orange)
        .edgesIgnoringSafeArea(.all)
    }
    
    func changePuzzle(index: Int) {
        let puzzles = ["6x10", "5x12", "OneHole", "FourNotches", "FourHoles", "13Holes", "Flower"]
        
        if index < puzzles.count {
            selectedPuzzle = puzzles[index]
            updatePuzzleSolution(for: selectedPuzzle)  // Update puzzle solution
        } else {
            selectedPuzzle = "6x10"  // Default to a valid puzzle
            updatePuzzleSolution(for: selectedPuzzle)
        }
    }
    
    // New function to update the puzzle solution based on the selected puzzle
    func updatePuzzleSolution(for puzzleName: String) {
        if let outline = puzzleOutlines.first(where: { $0.name == puzzleName }) {
            puzzleSolution = Array(repeating: Array(repeating: 0, count: outline.size.width), count: outline.size.height)
            // Additional logic to fill puzzleSolution based on outlines could be added here
        }
    }

    func resetGame() {
        changePuzzle(index: 0)  // Reset to the first puzzle
    }

    func solveGame() {
        // Simulate solving the game by filling some cells in the grid
        for row in 0..<puzzleSolution.count {
            for col in 0..<puzzleSolution[row].count {
                puzzleSolution[row][col] = Int.random(in: 0...1)  // Random 0 or 1
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 768))  // iPad dimensions
    }
}
