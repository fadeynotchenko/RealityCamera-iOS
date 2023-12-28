//
//  View Extensions.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 28.12.2023.
//

import SwiftUI

extension View {
    func setSchemeColor() -> some View {
        modifier(SchemeColor())
    }
}

struct SchemeColor: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content.foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
