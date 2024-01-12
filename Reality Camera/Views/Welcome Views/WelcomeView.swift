//
//  WelcomeView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 03.01.2024.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var selection: WelcomeItems = .first
    
    @AppStorage("isFirstEntry") private var isFirstEntry = true
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                FirstWelcomeItemView(selection: $selection)
                    .tag(WelcomeItems.first)
                
                SecondWelcomeItemView(selection: $selection)
                    .tag(WelcomeItems.second)
                
                ThirdWelcomeItemView(selection: $selection)
                    .tag(WelcomeItems.third)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .toolbar {
                ToolbarItem {
                    Button("close") { self.isFirstEntry = false }
                        .setSchemeColor()
                }
            }
        }
    }
}
