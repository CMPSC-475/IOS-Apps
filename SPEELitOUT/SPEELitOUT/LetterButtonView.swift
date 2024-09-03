//
//  LetterButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct LetterButtonView: View {
    let letter: String
    
    var body: some View {
        Button(action: {
 
        }) {
            Text(letter)
                .font(.title)
                .padding()
                .frame(width: 60, height: 60)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Circle())
            
        }
    }
}



#Preview {
    ZStack {
        Color.blue
        LetterButtonView(letter: "A")
        
    }
}
