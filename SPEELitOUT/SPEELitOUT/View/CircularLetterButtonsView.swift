//
//  CircularLetterButtonsView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/19/24.
//

import Foundation
import SwiftUI

struct CircularLetterButtonsView: View {
    var letters: [String]
    var centerLetter: String
    var action: (String) -> Void
    var sides: Int
    
    var body: some View {
        ZStack {
            ForEach(0..<letters.count, id: \.self) { index in
                let letter = letters[index]
                let angle = Double(index) / Double(letters.count) * 360.0
                
                // Non-center letters
                if letter != centerLetter {
                    Button(action: {
                        action(letter)
                    }) {
                        Text(letter)
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(PolygonShape(sides: sides)
                                .fill(Color.gray))
                            .clipShape(Circle())
                    }
                    .position(x: 150 + CGFloat(cos(angle * .pi / 180) * 100),
                              y: 150 + CGFloat(sin(angle * .pi / 180) * 100))
                }
            }

            // Center letter
            Button(action: {
                action(centerLetter)
            }) {
                Text(centerLetter)
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(PolygonShape(sides: sides)
                        .fill(Color.yellow))
                    .clipShape(Circle())
            }
            .position(x: 150, y: 150)
        }
        .frame(width: 300, height: 300)
    }
}
