//
//  ScrollView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct FoundWordsScrollView: View {
    var foundWords: [String]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(foundWords, id: \.self) { word in
                    Text(word)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .background(Color.black)
        .cornerRadius(10)
    }
}

#Preview {
    ZStack {
        Color.blue
        FoundWordsScrollView(foundWords: ["A","B"])
        
    }
}
