//
//  GameManager.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/9/24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var currentWord: String = ""
    @Published private(set) var foundWords: [String] = []
    @Published var score: Int = 0
    @Published var isValidWord: Bool = false // Tracks if the current word is valid
    
    @Published var preferences: Preferences
    @Published var scrambleProblem: ScrambleModel
    @Published var totalWords: Int = 0
    @Published var totalPoints: Int = 0
    @Published var pangrams: Int = 0
    @Published var wordStats: [String: Int] = [:]
    
    private static var validWords: Set<String> = [] // Use Set for faster lookups
    
    init() {
        GameManager.loadValidWords() // Load valid words
        self.preferences = Preferences(language: .english, letterCount: .five)
        self.scrambleProblem = ScrambleModel(preferences: preferences)
    }
    
    // MARK: - Game Logic
    
    func calculateHints() {
        totalWords = scrambleProblem.totalWords
        totalPoints = scrambleProblem.totalPoints
        pangrams = scrambleProblem.pangrams
        wordStats = scrambleProblem.wordStats
    }

    private static func createScrambleProblem() -> ScrambleModel {
        let letters = generateRandomLetters()
        return ScrambleModel(
            preferences: Preferences(language: .english, letterCount: .five),
            letters: letters,
            centerLetter: letters.first!,
            validWords: Array(validWords)
        )
    }

    private static func generateRandomLetters() -> [String] {
        let (fourLetterWords, fiveLetterWords) = getFilteredWords()
        var letters: Set<String> = Set()
        
        if let fiveLetterWord = fiveLetterWords.randomElement() {
            letters = Set(fiveLetterWord.map { String($0) })
        } else if let fourLetterWord = fourLetterWords.randomElement() {
            letters = Set(fourLetterWord.map { String($0) })
            while letters.count < 5 {
                letters.insert(String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!))
            }
        } else {
            while letters.count < 5 {
                letters.insert(String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!))
            }
        }
        
        return Array(letters).shuffled()
    }
    
    
    func addLetter(_ letter: String) {
        guard currentWord.count < 5 else { return }
        currentWord += letter
        checkWordValidity() // Check validity after adding a letter
    }
    
    func deleteLastLetter() {
        guard !currentWord.isEmpty else { return }
        currentWord.removeLast()
        checkWordValidity() // Check validity after removing a letter
    }
    
    func submitWord() {
        guard isValidWord, !foundWords.contains(currentWord.lowercased()) else { return }
        foundWords.append(currentWord.lowercased())
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
        var nonCenterLetters = scrambleProblem.letters.filter { $0 != scrambleProblem.centerLetter }
        nonCenterLetters.shuffle()
        scrambleProblem.letters = [scrambleProblem.centerLetter] + nonCenterLetters
    }
    
    func updatePreferences(newPreferences: Preferences) {
        preferences = newPreferences

        // Regenerate the scramble problem based on the new preferences
        let letters = GameManager.generateRandomLetters()
        guard let centerLetter = letters.first else {
            // Handle the case where letters are empty
            print("Error: No letters generated.")
            return
        }

        scrambleProblem = ScrambleModel(
            preferences: preferences,
            letters: letters,
            centerLetter: centerLetter,
            validWords: Array(GameManager.validWords)
        )
    }

    
    private func updateScore() {
        // Update score based on the current word
        score += (currentWord.count == 5) ? 10 : currentWord.count
    }

    private func resetCurrentWord() {
        currentWord = ""
        isValidWord = false // Reset the word validity
    }
    
    // Load valid words from the Words.swift file
    private static func loadValidWords() {
        validWords = Set(Words.words.map { $0.lowercased() }) // Use Set for fast lookups
    }
    
    private static func getFilteredWords() -> ([String], [String]) {
        let fourLetterWords = validWords.filter { $0.count == 4 }
        let fiveLetterWords = validWords.filter { $0.count == 5 }
        return (Array(fourLetterWords), Array(fiveLetterWords))
    }
    
    // Check if the current word is valid
    func checkWordValidity() {
        isValidWord = GameManager.validWords.contains(currentWord.lowercased())
    }
}
