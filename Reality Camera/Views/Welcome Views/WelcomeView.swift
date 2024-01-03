//
//  WelcomeView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 03.01.2024.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var selection: WelcomeItems = .first
    
    var body: some View {
        TabView(selection: $selection) {
            FirstWelcomeItemView(selection: $selection)
                .tag(WelcomeItems.first)
            
            SecondWelcomeItemView(selection: $selection)
                .tag(WelcomeItems.second)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
