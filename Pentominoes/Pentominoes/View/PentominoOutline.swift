//
//  PentominoOutline.swift
//  Pentominoes
//
//  Created by Hirpara, Nandan Ashvinbhai on 10/1/24.
//

import Foundation

// Define the struct for size
struct Size: Codable {
    let width: Int
    let height: Int
}

// Define the struct for outline points
struct OutlinePoint: Codable {
    let x: Int
    let y: Int
}

// Define the main struct for pentomino outlines
struct PentominoOutline: Codable {
    let name: String
    let size: Size
    let outline: [OutlinePoint]
}
