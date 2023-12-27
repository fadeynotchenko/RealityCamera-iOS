//
//  GallerySaveButton.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct GSButton: View {
    let action: () -> ()
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text("Сохранить в галерею")
                .foregroundColor(.white)
                .bold()
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(15)
        }
        .padding()
    }
}
