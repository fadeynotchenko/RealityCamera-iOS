//
//  SecondWelcomeItemView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 03.01.2024.
//

import SwiftUI

struct SecondWelcomeItemView: View {
    @Binding var selection: WelcomeItems
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading) {
                Header()
                
                Spacer()
                
                NextWelcomeItemButton {
                    withAnimation {
                        self.selection = .third
                    }
                }
            }
        }
    }
    
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("secondWelcomeTitle")
                .bold()
                .font(.largeTitle)
            
            Text("secondWelcomeSubTitle")
                .font(.title3)
        }
        .setSchemeColor()
        .multilineTextAlignment(.leading)
    }
}
