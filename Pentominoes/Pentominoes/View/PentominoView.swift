//
//  PentominoView.swift
//  Pentominoes
//
// Created by Nandan Hirpara on 09/21/24.
//

import Foundation
import SwiftUI

struct PentominoView: View {
    var pieceIndex: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.blue)
    }
}
struct PentominoView_Previews: PreviewProvider {
    static var previews: some View {
        PentominoView(pieceIndex: 0)  // For example, this could represent the first pentomino piece
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
