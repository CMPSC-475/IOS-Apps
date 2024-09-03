//
//  SubmitButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct SubmitButtonView: View {
    var body: some View {
        Button(action: {

        }) {
            Text("Submit")
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        SubmitButtonView()
        
    }
}
