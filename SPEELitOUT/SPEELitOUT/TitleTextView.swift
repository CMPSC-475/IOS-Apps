//
//  TitleTextView.swift
//  SPEELitOUT
//
//  Created by Hirpara, Nandan Ashvinbhai on 9/2/24.
//

import Foundation
import SwiftUI

struct TitleTextView: View {
    var TitleText = "Spell It out!!!"
    
    var body: some View {
        Text(TitleText)
            .bold()
            .font(.system(size: 36)) // increase font size here
            .foregroundStyle(Color.black)
        
            
    }
}

#Preview {
    ZStack {
        Color.blue
        TitleTextView(TitleText: "Spell It out!!!")
        
    }
}
