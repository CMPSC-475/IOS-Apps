//
//  ScrollView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct FoundWordsScrollView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(["Nandan", "Spells", "Gamma", "and", "rays"], id: \.self) { word in
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
    FoundWordsScrollView()
}
