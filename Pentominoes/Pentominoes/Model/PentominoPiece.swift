//
//  PentominoPiece.swift
//  Pentominoes
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/1/24.
//

import Foundation

struct Orientation {
    var xRotations: Int  // 180-degree rotations around X-axis
    var yRotations: Int  // 180-degree rotations around Y-axis
    var zRotations: Int  // 90-degree rotations around Z-axis
}


struct PentominoPiece: Identifiable {
    let id: UUID
    var outline: PentominoOutline
    var position: CGPoint  // Current position on the grid
    var orientation: Orientation
    
    // Initialize with defaults
    init(outline: PentominoOutline) {
        self.id = UUID()
        self.outline = outline
        self.position = CGPoint(x: 0, y: 0)
        self.orientation = Orientation(xRotations: 0, yRotations: 0, zRotations: 0)
    }

    // Add functions for rotation and flipping
    mutating func rotate90Degrees() {
        orientation.zRotations = (orientation.zRotations + 1) % 4
    }

    mutating func flip() {
        orientation.yRotations = (orientation.yRotations + 1) % 2
    }
}

func snapToGrid(location: CGPoint) -> CGPoint {
    let gridSize: CGFloat = 40 // Assuming a square size of 40
    let x = round(location.x / gridSize) * gridSize
    let y = round(location.y / gridSize) * gridSize
    return CGPoint(x: x, y: y)
}
