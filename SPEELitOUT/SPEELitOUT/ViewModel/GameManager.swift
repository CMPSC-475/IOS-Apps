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

        let initialPreferences = Preferences(language: .english, letterCount: .five)
        self.preferences = initialPreferences
        
        let letters = GameManager.generateRandomLetters(count: initialPreferences.letterCount.rawValue)
        let centerLetter = letters.first!

        self.scrambleProblem = ScrambleModel(
            preferences: initialPreferences,
            letters: letters,
            centerLetter: centerLetter,
            validWords: Array(GameManager.validWords)
        )
    }

    func calculateHints() {
        // Convert letters to Set of Characters
        let lettersSet = Set(scrambleProblem.letters.flatMap { $0 })
        
        // Filter words that can be formed with the displayed letters
        let filteredWords = GameManager.validWords.filter { word in
            let wordSet = Set(word)  // Convert word to Set of Characters
            return wordSet.isSubset(of: lettersSet)
        }
        
        // Calculate total possible points
        totalWords = filteredWords.count
        totalPoints = filteredWords.reduce(0) { result, word in
            result + (word.count == 5 ? 10 : word.count)
        }
        
        // Calculate pangrams (adjust this logic if needed)
        pangrams = filteredWords.filter { $0.count == 7 }.count
        
        // Count words by length
        wordStats = Dictionary(grouping: filteredWords, by: { String($0.count) }).mapValues { $0.count }
    }

    private static func createScrambleProblem(preferences: Preferences) -> ScrambleModel {
        let letters = generateRandomLetters(count: preferences.letterCount.rawValue)
        return ScrambleModel(
            preferences: preferences,
            letters: letters,
            centerLetter: letters.first!,
            validWords: Array(validWords)
        )
    }

    private static func generateRandomLetters(count: Int) -> [String] {
        let (fourLetterWords, fiveLetterWords) = getFilteredWords()
        var letters: Set<String> = Set()
        
        if count == 5, let fiveLetterWord = fiveLetterWords.randomElement() {
            letters = Set(fiveLetterWord.map { String($0) })
        } else if count == 6, let sixLetterWord = validWords.filter({ $0.count == 6 }).randomElement() {
            letters = Set(sixLetterWord.map { String($0) })
        } else if count == 7, let sevenLetterWord = validWords.filter({ $0.count == 7 }).randomElement() {
            letters = Set(sevenLetterWord.map { String($0) })
        } else {
            while letters.count < count {
                letters.insert(String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!))
            }
        }
        
        return Array(letters).shuffled()
    }
    
    func addLetter(_ letter: String) {
        guard currentWord.count < preferences.letterCount.rawValue else { return }
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
        self.scrambleProblem = GameManager.createScrambleProblem(preferences: preferences)
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
        self.scrambleProblem = GameManager.createScrambleProblem(preferences: preferences)
    }

    private func updateScore() {
        // Update score based on the current word
        score += (currentWord.count == 7) ? 20 : (currentWord.count == 5) ? 10 : currentWord.count
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
    
    func updateHints() {
        calculateHints()
    }
}
