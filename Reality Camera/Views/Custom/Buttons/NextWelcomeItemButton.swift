//
//  NextItem.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 03.01.2024.
//

import SwiftUI

struct NextWelcomeItemButton: View {
    let action: () -> ()
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .setSchemeColor()
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Circle())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 15))
        }
    }
}
