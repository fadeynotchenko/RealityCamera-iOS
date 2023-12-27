//
//  Button.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import SwiftUI

struct CButton: View {
    let iconName: String
    let color: Color
    var size: CGFloat = 35
    let action: () -> ()
    
    var body: some View {
        Button(action: self.action) {
            Image(systemName: self.iconName)
                .font(.system(size: self.size))
                .foregroundColor(self.color)
                .buttonStyle(.plain)
        }
        .shadow(radius: 3)
    }
}
