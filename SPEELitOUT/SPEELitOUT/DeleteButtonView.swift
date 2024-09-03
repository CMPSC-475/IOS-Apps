//
//  DeleteButtonView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct DeleteButtonView: View {
    var body: some View {
        Button(action: {
 
        }) {
            Text("Delete")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        DeleteButtonView()
        
    }
}
