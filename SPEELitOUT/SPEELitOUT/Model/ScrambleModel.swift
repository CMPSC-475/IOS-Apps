//
//  ScrambleModel.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/17/24.
//

import Foundation

struct ScrambleModel {
    var letters: [String]
    var centerLetter: String
    var preferences: Preferences
    var validWords: [String]

    // Add computed properties to calculate hints and statistics.
    var totalWords: Int { validWords.count }
    var totalPoints: Int { validWords.reduce(0) { $0 + $1.count } }
    var pangrams: Int { validWords.filter { Set($0).count == letters.count }.count }
    var wordStats: [String: Int] {
        var stats = [String: Int]()
        for word in validWords {
            let firstLetter = String(word.first!)
            stats[firstLetter, default: 0] += 1
        }
        return stats
    }

    // Initialize the game with preferences, letters, and valid words
    init(preferences: Preferences, letters: [String], centerLetter: String, validWords: [String]) {
        self.preferences = preferences
        self.letters = letters
        self.centerLetter = centerLetter
        self.validWords = validWords
    }
}

