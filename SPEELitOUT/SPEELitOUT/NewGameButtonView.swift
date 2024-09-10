//
//  NewGameButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct NewGameButtonView: View {
    var action: () -> Void  // Add a closure for the button's action

    var body: some View {
        Button(action: {
            action()  // Perform the action passed in
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
        //NewGameButtonView()
        
    }
}

