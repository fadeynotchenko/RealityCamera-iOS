//
//  f.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 03.01.2024.
//

import SwiftUI

struct FirstWelcomeItemView: View {
    @Binding var selection: WelcomeItems
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Logo()
            
            Header()
            
            Spacer()
            
            NextWelcomeItemButton {
                withAnimation {
                    self.selection = .second
                }
            }
        }
        .padding()
    }
    
    private func Logo() -> some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .cornerRadius(7)
    }
    
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("firstWelcomeTitle")
                .bold()
                .font(.largeTitle)
            
            Text("firstWelcomeSubTitle")
                .font(.title3)
        }
        .setSchemeColor()
        .multilineTextAlignment(.leading)
    }
}
