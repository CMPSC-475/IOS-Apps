//
//  DeleteButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct DeleteButtonView: View {
    @Binding var currentWord: String  // Bind to the current word
    @Binding var isValidWord: Bool    // Bind to word validation state
    
    var body: some View {
        Button(action: {
            if !currentWord.isEmpty {
                currentWord.removeLast()  // Remove the last letter
                checkWord()               // Check if the word is valid after deletion
            }
        }) {
            Text("Delete")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
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
        //DeleteButtonView(currentWord: Binding<String>, isValidWord: Binding<true>)
        
    }
}
