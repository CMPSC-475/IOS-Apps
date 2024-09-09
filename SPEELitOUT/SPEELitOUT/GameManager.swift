//
//  GameManager.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/9/24.
//

import Foundation


class GameManager: ObservableObject {
    @Published private(set) var scrambleProblem: ScrambleProblem
    @Published var currentWord: String = ""
    @Published private(set) var foundWords: [String] = []
    @Published var score: Int = 0
    @Published var isValidWord: Bool = false  // Tracks if the current word is valid
    
    var validWords: [String] = []  // Loaded from the Words.swift file
    
    init() {
        self.scrambleProblem = GameManager.createScrambleProblem()
        loadValidWords()  // Load words from Words.swift file
        //checkWordValidity()
    }
    
    // MARK: - Game Logic
    
    func addLetter(_ letter: String) {
        guard currentWord.count < 5 else { return }
        currentWord += letter
        checkWordValidity()  // Check validity after adding a letter
    }

    func deleteLastLetter() {
        guard !currentWord.isEmpty else { return }
        currentWord.removeLast()
        checkWordValidity()  // Check validity after removing a letter
    }

    func submitWord() {
        guard isValidWord, !foundWords.contains(currentWord) else { return }
        foundWords.append(currentWord)
        updateScore()
        resetCurrentWord()
    }

    func newGame() {
        self.scrambleProblem = GameManager.createScrambleProblem()
        foundWords.removeAll()
        score = 0
        resetCurrentWord()
    }

    func shuffleLetters() {
        scrambleProblem.letters.shuffle()
    }

    private func updateScore() {
        score += currentWord.count  // Base score on word length
        if currentWord.count == 5, currentWord == scrambleProblem.pangram {
            score += 10 // Pangram bonus
        }
    }

    private func resetCurrentWord() {
        currentWord = ""
        isValidWord = false  // Reset the word validity
    }

    private static func createScrambleProblem() -> ScrambleProblem {
        let letters = ["I", "O", "C", "N", "L","A"] // Example set of letters
        return ScrambleProblem(letters: letters, validWords: [])  // Empty valid words initially
    }
    
    // Load valid words from the Words.swift file
    private func loadValidWords() {
        validWords = Words.words.map { $0.uppercased() }  // Load and uppercase words from Words.swift
    }
    
    // Check if the current word is valid
    func checkWordValidity() {
        if validWords.contains(currentWord.uppercased()) {isValidWord = true}
        else{isValidWord = false}
        
    }
}
