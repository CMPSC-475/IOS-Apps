//
//  ContentView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentWord: String = ""  // Track the current word being formed
    var gameManager = GameManager()
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                HStack{
                    TitleTextView()
                }
                .padding(.top, 0) // Adjust this value to move HStack down
                
                // Header with score and new game button
                HStack {
                    Text("Score: \(gameManager.score)") // Display the current score
                        .font(.headline)
                        .foregroundStyle(Color.white)
                    Spacer()
                    NewGameButtonView()
                }
                .padding()
                
                // Scrollable list of found words
                FoundWordsScrollView(foundWords: gameManager.foundWords)
                    .padding(.horizontal)
                
                // Letters being constructed
                HStack {
                    Text("Current Word: ")
                        .font(.headline)
                    Text(currentWord)
                        .font(.title)
                        .bold()
                }
                .padding()
                
                // 5 Buttons with letters
                HStack {
                    ForEach(["I", "O", "C", "N", "L"], id: \.self) { letter in
                        LetterButtonView(letter: letter, currentWord: $currentWord, isValidWord: .constant(gameManager.isValidWord))  // Keep gameManager.isValidWord synced
                            .onChange(of: currentWord) { _ in
                                gameManager.currentWord = currentWord // Sync the word with the GameManager
                                gameManager.checkWordValidity() // Check if the word is valid
                            }
                    }
                }
                .padding()
                
                // Delete and submit buttons
                HStack {
                    DeleteButtonView(currentWord: $currentWord, isValidWord: .constant(gameManager.isValidWord))
                        .onTapGesture {
                            gameManager.deleteLastLetter() // Sync with GameManager's delete logic
                            gameManager.checkWordValidity() // Recheck validity after deletion
                        }
                    Spacer(minLength: 2)
                    SubmitButtonView(
                        isEnabled: gameManager.isValidWord,  // Check the word validity from GameManager
                        onSubmit: {
                            gameManager.submitWord()  // Call the GameManager's submission logic
                            currentWord = "" // Reset current word after submission
                        }
                    )
                    .padding()
                }
                .padding()
                
                // Shuffle, hints, and preferences buttons
                HStack {
                    ShuffleButtonView()
                        .onTapGesture {
                            gameManager.shuffleLetters()  // Call GameManager's shuffle logic
                        }
                    Spacer(minLength: 20)
                    HintsButtonView()
                    Spacer(minLength: 20)
                    PreferencesButtonView()
                }
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        Color.blue
        ContentView()
    }
}
