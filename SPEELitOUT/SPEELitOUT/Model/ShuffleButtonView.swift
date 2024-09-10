//
//  ShuffleButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct ShuffleButtonView: View {
    var action: () -> Void  // Add a closure for the button's action

    var body: some View {
        Button(action: {
            action()  // Perform the action passed in
        }) {
            Image(systemName: "shuffle")
                .font(.title2)
                .foregroundColor(.white)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.blue
        //ShuffleButtonView()
    }
}
