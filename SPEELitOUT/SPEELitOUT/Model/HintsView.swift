//
//  HintsView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/18/24.
//

import Foundation
import SwiftUI

struct HintsView: View {
    @Binding var totalWords: Int
    @Binding var totalPoints: Int
    @Binding var pangrams: Int
    @Binding var wordStats: [String: Int]

    var body: some View {
        Form {
            Section(header: Text("Summary")) {
                Text("Total number of words: \(totalWords)")
                Text("Total possible points: \(totalPoints)")
                Text("Number of Pangrams: \(pangrams)")
            }
            
            Section(header: Text("Words by Length")) {
                ForEach(wordStats.keys.sorted(), id: \.self) { letter in
                    if let count = wordStats[letter] {
                        Text("\(letter): \(count)")
                    }
                }
            }
        }
    }
}
