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
        VStack(alignment: .leading) {
            TextBody()
            
            Spacer()
            
            NextWelcomeItemButton {
                withAnimation {
                    self.selection = .third
                }
            }
        }
        .padding()
    }
    
    private func TextBody() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("secondWelcomeTitle")
                .bold()
                .font(.largeTitle)
            
            Group {
                (Text("secondWelcomeSubTitleStartStepOne") + Text(Image(systemName: "square.grid.2x2.fill")) + Text("secondWelcomeSubTitleEndStepOne"))
                
                Divider()
                
                Text("secondWelcomeSubTitleModelsIcons")
                    
                (Text(Image(systemName: "icloud.and.arrow.down")) + Text("secondWelcomeSubTitleIconOne"))
                
                (Text(Image(systemName: "star")) + Text("secondWelcomeSubTitleIconTwo"))
                
                (Text(Image(systemName: "play.circle")) + Text("secondWelcomeSubTitleIconThree"))
            }
            .font(.title3)
        }
        .setSchemeColor()
        .multilineTextAlignment(.leading)
    }
}
