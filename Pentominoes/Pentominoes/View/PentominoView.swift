//
//  PentominoView.swift
//  Pentominoes
//
// Created by Nandan Hirpara on 09/21/24.
//

import Foundation
import SwiftUI

struct PentominoView: View {
    @Binding var piece: PentominoPiece  // Bind to the piece model
    @State private var isDragging = false
    @State private var isInCorrectPosition = false
    
    var body: some View {
        Path { path in
            let outlinePoints = piece.outline.outline
            
            for (index, point) in outlinePoints.enumerated() {
                let x = CGFloat(point.x) * 20  // Scale
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
        .scaleEffect(isDragging ? 1.1 : 1.0) // Scale effect while dragging
        .gesture(
            DragGesture()
                .onChanged { value in
                    piece.position = value.location // Update position
                }
                .onEnded { _ in
                    // Snap to grid logic can be implemented here
                }
        )
        .onTapGesture {
            piece.rotate90Degrees() // Rotate on tap
        }
        .onLongPressGesture {
            piece.flip() // Flip on long press
        }
        .rotation3DEffect(.degrees(Double(piece.orientation.zRotations) * 90), axis: (0, 0, 1))
        .rotation3DEffect(.degrees(Double(piece.orientation.yRotations) * 180), axis: (1, 0, 0))
        .rotation3DEffect(.degrees(Double(piece.orientation.xRotations) * 180), axis: (0, 1, 0))
        .opacity(isInCorrectPosition ? 0.5 : 1) // Visual indication for correct position
    }
}

/*
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
} */

