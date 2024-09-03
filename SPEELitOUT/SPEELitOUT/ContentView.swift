//
//  ContentView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import SwiftUI
import SwiftData



struct ContentView: View {
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
                    Text("Score: 0")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                    Spacer()
                    NewGameButtonView()
                }
                .padding()
                .padding()
                .padding()
                
                // Scrollable list of found words
                    FoundWordsScrollView()                       .padding(.horizontal)
                
                // Letters being constructed
                HStack {
                    Text("Current Word: ")
                        .font(.headline)
                    Text("LION")
                        .font(.title)
                        .bold()
                }
                .padding()
                .padding()
                
                // 5 Buttons with letters
                HStack {
                    ForEach(["I", "O", "C", "N", "L"], id: \.self) { letter in
                        LetterButtonView(letter: letter)
                    }
                }
                .padding()
                
                // Delete and submit buttons
                HStack {
                    DeleteButtonView()
                    Spacer(minLength: 2)
                    SubmitButtonView()
                }
                .padding()
                .padding()
                .padding()
                
                // Shuffle, hints, and preferences buttons
                HStack {
                    ShuffleButtonView()
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
