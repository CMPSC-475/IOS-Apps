//
//  ContentView.swift
//  Pentominoes
//
//  Created by Nandan Hirpara on 09/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPuzzle = "6x10"  // Default puzzle

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
                            Image("Board\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)  // Explicit frame size for visibility
                                .border(Color.black, width: 1) // Add border to ensure visibility
                        }
                        .padding(.bottom, 10)  // Add spacing between buttons
                    }
                }
                .frame(width: 120)  // Set fixed width for the VStack to avoid collapsing
                
                Spacer()

                // Puzzle Board Display
                ZStack {
                    Grid(rows: 14, columns: 14)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 420, height: 420)

                    PuzzleView(puzzleName: selectedPuzzle)
                        .frame(width: 300, height: 180)
                }

                Spacer()

                // Right Puzzle Selection Buttons (4-7)
                VStack {
                    ForEach(4..<8) { index in
                        Button(action: {
                            changePuzzle(index: index)
                        }) {
                            Image("Board\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)  // Explicit frame size for visibility
                                .border(Color.black, width: 1) // Add border to ensure visibility
                        }
                        .padding(.bottom, 10)  // Add spacing between buttons
                    }
                }
                .frame(width: 120)  // Set fixed width for the VStack to avoid collapsing
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
                        ForEach(0..<4) { col in
                            let pieceIndex = row * 4 + col
                            PentominoView(pieceIndex: pieceIndex)
                                .frame(width: 100, height: 100)
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
        selectedPuzzle = puzzles[index]
    }
    
    func resetGame() {
        // Logic to reset the game
    }

    func solveGame() {
        // Logic to solve the game
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 768))  // iPad dimensions
    }
}
