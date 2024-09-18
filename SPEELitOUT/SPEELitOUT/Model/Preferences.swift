//
//  Preferences.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/17/24.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "English"
    case french = "French"
    
    var id: String { self.rawValue }
}

enum LetterCount: Int, CaseIterable, Identifiable {
    case five = 5
    case six = 6
    case seven = 7
    
    var id: Int { self.rawValue }
}

struct Preferences {
    var language: Language
    var letterCount: LetterCount
}
