//
//  HintsButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct HintsButtonView: View {
    var body: some View {
        Button(action: {

        }) {
            Image(systemName: "lightbulb")
                .font(.title2)
                .foregroundColor(.white)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.blue
        HintsButtonView()
    }
}
