//
//  SubmitButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct SubmitButtonView: View {
    let isEnabled: Bool  // Controls whether the button is enabled or not
    let onSubmit: () -> Void  // Closure to handle submission logic
    
    var body: some View {
        Button(action: {
            onSubmit()  // Execute submission logic when button is pressed
        }) {
            Text("Submit")
                .padding()
                .background(isEnabled ? Color.green : Color.gray)  // Green if enabled, gray if disabled
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .disabled(!isEnabled)  // Disable the button when it's not enabled
    }
}

#Preview {
    ZStack {
        Color.blue
        SubmitButtonView(isEnabled: true, onSubmit: {})
    }
}
