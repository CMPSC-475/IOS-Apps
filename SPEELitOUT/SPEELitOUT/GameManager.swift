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
        //print("Valid words loaded: \(validWords)")  // Debug:- Check if valid words are loaded
    }
    
    // MARK: - Game Logic
    
    private static func createScrambleProblem() -> ScrambleProblem {
            let letters = generateRandomLetters()
            return ScrambleProblem(letters: letters, validWords: [])
        }
    
    private static func generateRandomLetters() -> [String] {
            let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            var letters: [String] = []
            
            while letters.count < 5 {
                let randomLetter = String(alphabet.randomElement()!)
                if !letters.contains(randomLetter) {
                    letters.append(randomLetter)
                }
            }

            // Optionally check if the letters form at least one valid 5-letter word.
            return letters
        }
    
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

    
    
    // Load valid words from the Words.swift file
    private func loadValidWords() {
        validWords = Words.words.map { $0.uppercased() }  // Load and uppercase words from Words.swift
        //print("Loaded \(validWords.count) valid words.")  // Debugging: Check how many words were loaded
    }
    
    // Check if the current word is valid
    func checkWordValidity() {
        if validWords.contains(currentWord.uppercased()) {
            isValidWord = true
            print("'\(currentWord)' is a valid word.")  // Debugging: Show when a valid word is found
        } else {
            isValidWord = false
            print("'\(currentWord)' is not a valid word.")  // Debugging: Show when the word is invalid
        }
    }
}
