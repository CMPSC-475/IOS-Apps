//
//  NewGameButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct NewGameButtonView: View {
    var body: some View {
        Button(action: {

        }) {
            Text("New Game")
            .foregroundStyle(Color.white)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.blue
        NewGameButtonView()
        
    }
}

