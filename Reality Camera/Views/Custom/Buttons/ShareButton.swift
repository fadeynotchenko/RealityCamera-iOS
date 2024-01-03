//
//  ShareButton.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct SButton: View {
    let action: () -> ()
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.5)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(15)
        }
    }
}
