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
    @ObservedObject var gameManager = GameManager()  // Observe the game manager to reflect changes

    @State private var showingPreferences = false
    @State private var showingHints = false
    @State private var preferences = Preferences(language: .english, letterCount: .five)
    @State private var isPreferencesPresented = false

    var body: some View {
        ZStack {
            Color.orange
            VStack {
                HStack {
                    TitleTextView()
                }
                .padding(.top, 0)

                // Header with score and new game button
                HStack {
                    Text("Score: \(gameManager.score)") // Display the current score
                        .font(.headline)
                        .foregroundStyle(Color.white)
                    Spacer()
                    NewGameButtonView(action: {
                        gameManager.newGame()
                        currentWord = ""
                        gameManager.updateHints()
                    })
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

                // Circular layout for letter buttons
                CircularLetterButtonsView(
                    letters: gameManager.scrambleProblem.letters,
                    centerLetter: gameManager.scrambleProblem.centerLetter,
                    action: { letter in
                        gameManager.addLetter(letter)
                        currentWord.append(letter)
                        gameManager.checkWordValidity()
                    },
                    sides: gameManager.preferences.letterCount.rawValue
                    
                )

                // Delete and submit buttons
                HStack {
                    DeleteButtonView(currentWord: $currentWord, isValidWord: .constant(gameManager.isValidWord))
                        .onTapGesture {
                            gameManager.deleteLastLetter()
                            gameManager.checkWordValidity()
                        }
                    Spacer(minLength: 2)
                    SubmitButtonView(
                        isEnabled: gameManager.isValidWord,  // Check the word validity from GameManager
                        onSubmit: {
                            gameManager.submitWord()  // Call the GameManager's submission logic
                            currentWord = "" // Reset current word after submission
                            gameManager.updateHints()
                        }
                    )
                    .padding()
                }
                .padding()

                // Shuffle, hints, and preferences buttons
                HStack {
                    ShuffleButtonView(action: {
                        gameManager.shuffleLetters()
                    })
                    Spacer(minLength: 20)

                    HintsView(
                        isPresented: $showingHints,
                        totalWords: $gameManager.totalWords,
                        totalPoints: $gameManager.totalPoints,
                        pangrams: $gameManager.pangrams,
                        wordStats: $gameManager.wordStats
                    )
                    .onAppear {
                        gameManager.calculateHints() // Ensure hints are updated
                    }

                    Spacer(minLength: 20)
                    
                    

                    PreferencesView(
                                    isPresented: $isPreferencesPresented,
                                    preferences: $preferences,
                                    onPreferencesUpdated: { newPreferences in
                                        gameManager.updatePreferences(newPreferences: newPreferences)
                                    }
                                    )
                }
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        Color.orange
        ContentView()
    }
}
