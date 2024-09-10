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

    var body: some View {
        ZStack {
            //Color.blue
            Color.orange
            VStack {
                HStack{
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
                        //print("New Game tapped")
                        gameManager.newGame()
                        currentWord = ""
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

                // 5 Buttons with letters from scrambleProblem
                HStack {
                    ForEach(gameManager.scrambleProblem.letters, id: \.self) { letter in
                        LetterButtonView(letter: letter, currentWord: $currentWord, isValidWord: .constant(gameManager.isValidWord))
                            .onChange(of: currentWord) { newValue in
                                gameManager.currentWord = newValue
                                gameManager.checkWordValidity()
                            }
                    }
                }
                .padding()

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
                        }
                    )
                    .padding()
                }
                .padding()

                // Shuffle, hints, and preferences buttons
                HStack {
                    ShuffleButtonView(action: {
                        //print("Shuffle tapped!")
                        gameManager.shuffleLetters()
                    })
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
