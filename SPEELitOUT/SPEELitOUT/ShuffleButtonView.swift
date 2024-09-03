//
//  ShuffleButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct ShuffleButtonView: View {
    var body: some View {
        Button(action: {

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
        ShuffleButtonView()
    }
}
