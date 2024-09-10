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
    @Published var isValidWord: Bool = false // Tracks if the current word is valid
    
    private static var validWords: [String] = [] // Loaded from the Words.swift file
    
    init() {
        // Initialize validWords before creating scrambleProblem
        GameManager.loadValidWords() // Load valid words
        self.scrambleProblem = GameManager.createScrambleProblem()
    }
    
    // MARK: - Game Logic
    
    private static func createScrambleProblem() -> ScrambleProblem {
        let letters = generateRandomLetters()
        return ScrambleProblem(letters: letters, validWords: validWords) // Use validWords loaded in init
    }
    
    private static func generateRandomLetters() -> [String] {
        let (fourLetterWords, fiveLetterWords) = getFilteredWords()
        var letters: Set<String> = Set()
        
        // Ensure we get 5 unique letters
        if let fiveLetterWord = fiveLetterWords.randomElement() {
            letters = Set(fiveLetterWord.map { String($0) })
        } else if let fourLetterWord = fourLetterWords.randomElement() {
            var tempLetters = Set(fourLetterWord.map { String($0) })
            while letters.count < 5 {
                let randomLetter = String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!)
                tempLetters.insert(randomLetter)
            }
            letters = tempLetters
        }
        
        // Shuffle the letters
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
        let shuffledLetters = scrambleProblem.letters.shuffled()
        //print("Shuffled letters: \(shuffledLetters)")
        scrambleProblem = ScrambleProblem(letters: shuffledLetters, validWords: scrambleProblem.validWords)
    }
    
    private func updateScore() {
        //score += currentWord.count  // Base score on word length
        if currentWord.count == 4 {score+=1}
        if currentWord.count > 4 {
            score += currentWord.count
        }
        if currentWord.count == 5 {score+=10}
    }

    

    
    private func resetCurrentWord() {
        currentWord = ""
        isValidWord = false // Reset the word validity
    }
    
    // Load valid words from the Words.swift file
    private static func loadValidWords() {
        validWords = Words.words.map { $0.uppercased() } // Load and uppercase words from Words.swift
    }
    
    private static func getFilteredWords() -> ([String], [String]) {
        let fourLetterWords = validWords.filter { $0.count == 4 }
        let fiveLetterWords = validWords.filter { $0.count == 5 }
        return (fourLetterWords, fiveLetterWords)
    }
    
    // Check if the current word is valid
    func checkWordValidity() {
        if GameManager.validWords.contains(currentWord.uppercased()) {
            isValidWord = true
            //print("'\(currentWord)' is a valid word.")
        } else {
            isValidWord = false
            //print("'\(currentWord)' is not a valid word.") 
        }
    }
}
