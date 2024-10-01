//
//  PentominoView.swift
//  Pentominoes
//
// Created by Nandan Hirpara on 09/21/24.
//

import Foundation
import SwiftUI

struct PentominoView: View {
    var pentominoOutline: PentominoOutline
    var pieceIndex: Int
    
    var body: some View {
        Path { path in
            let outlinePoints = pentominoOutline.outline
            
            for (index, point) in outlinePoints.enumerated() {
                let x = CGFloat(point.x) * 20  // Scale to make the shapes larger
                let y = CGFloat(point.y) * 20
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
        .fill(Color.blue)
    }
}

struct PentominoView_Previews: PreviewProvider {
    static var previews: some View {
        let pentominoOutlines = loadPentominoOutlines()
        
        return Group {
            ForEach(0..<pentominoOutlines.count, id: \.self) { index in
                PentominoView(pentominoOutline: pentominoOutlines[index], pieceIndex: index)
                    .frame(width: 100, height: 100)
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}

