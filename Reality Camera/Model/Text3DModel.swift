//
//  Text3DModel.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

class Text3DModel {
    var text: String
    var color: Color
    var size: CGFloat
    var font: String
    
    init(text: String, color: Color, size: CGFloat, font: String) {
        self.text = text
        self.color = color
        self.size = size
        self.font = font
    }
}
