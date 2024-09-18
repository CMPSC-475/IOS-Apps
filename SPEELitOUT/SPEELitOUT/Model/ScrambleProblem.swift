//
//  ScrambleProblem.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/9/24.
//

import Foundation

struct ScrambleProblem {
    var letters: [String]
    var validWords: Set<String> = []
    
    // Example of computed property for the pangram
    var pangram: String? {
        validWords.first { Set($0).count == letters.count }
    }
    
    init(letters: [String], validWords: Set<String>) {
        self.letters = letters
        self.validWords = validWords
    }
}
