//
//  Grid.swift
//  Pentominoes
//
// Created by Nandan Hirpara on 09/21/24.
//

import Foundation
import SwiftUI

struct Grid: Shape {
    var rows: Int
    var columns: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for i in 0...rows {
            let y = rect.height / CGFloat(rows) * CGFloat(i)
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        for i in 0...columns {
            let x = rect.width / CGFloat(columns) * CGFloat(i)
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        return path
    }
}
struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid(rows: 14, columns: 14)
            .stroke(Color.black, lineWidth: 1)
            .frame(width: 420, height: 420)  // Adjust to the size of your game board
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
