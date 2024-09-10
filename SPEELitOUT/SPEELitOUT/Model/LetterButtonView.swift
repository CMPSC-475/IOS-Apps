//
//  LetterButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct LetterButtonView: View {
    let letter: String
    @Binding var currentWord: String  // Bind to the current word
    @Binding var isValidWord: Bool    // Bind to word validation state
    
    var body: some View {
        Button(action: {
            currentWord += letter  // Add the letter to the current word
            checkWord()            // Check if the word is valid
        }) {
            Text(letter)
                .font(.title)
                .padding()
                .frame(width: 60, height: 60)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
    
    // Function to check if the current word is valid
    func checkWord() {
        isValidWord = Words.words.contains(currentWord.lowercased())
    }
}





#Preview {
    ZStack {
        Color.blue
        
    }
}
