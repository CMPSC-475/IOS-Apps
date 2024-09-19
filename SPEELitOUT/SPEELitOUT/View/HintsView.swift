//
//  HintsView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/18/24.
//

import Foundation
import SwiftUI

struct HintsView: View {
    @Binding var isPresented: Bool
    @Binding var totalWords: Int
    @Binding var totalPoints: Int
    @Binding var pangrams: Int
    @Binding var wordStats: [String: Int]

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }) {
            Image(systemName: "lightbulb")
                .font(.title2)
                .foregroundColor(.white)
        }
        .sheet(isPresented: $isPresented) {
            Form {
                Section(header: Text("Summary")) {
                    Text("Total number of words: \(totalWords)")
                    Text("Total possible points: \(totalPoints)")
                    Text("Number of Pangrams: \(pangrams)")
                }
                
                Section(header: Text("Words by Length")) {
                    ForEach(wordStats.keys.sorted(), id: \.self) { length in
                        Text("\(length)-letter words: \(wordStats[length] ?? 0)")
                    }
                }
                
                Button("Done") {
                    isPresented = false  // Close the hints view
                }
            }
        }
    }
}

