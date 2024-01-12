//
//  ThirdWelcomeItemView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 11.01.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ThirdWelcomeItemView: View {
    @Binding var selection: WelcomeItems
    
    var body: some View {
        VStack {
            TextBody()
            
            Spacer()
            
//            NextWelcomeItemButton {
//                withAnimation {
//                    self.selection = .third
//                }
//            }
        }
        .padding()
    }
    
    private func TextBody() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("thirdWelcomeTitle")
                .bold()
                .font(.largeTitle)
            
            Text("thirdWelcomeSubTitleStepOneHeader")
                .font(.title3)
            
            AnimatedImage(name: "focus.gif")
                .frame(height: 150)
                .padding(.vertical)
            
            (Text("thirdWelcomeSubTitleStepOneFooter") + Text(Image(systemName: "checkmark.circle.fill")))
                .font(.title3)
            
            //            Group {
            //                (Text("secondWelcomeSubTitleStartStepOne") + Text(Image(systemName: "square.grid.2x2.fill")) + Text("secondWelcomeSubTitleEndStepOne"))
            //
            //                Divider()
            //
            //                Text("secondWelcomeSubTitleModelsIcons")
            //
            //                (Text(Image(systemName: "icloud.and.arrow.down")) + Text("secondWelcomeSubTitleIconOne"))
            //
            //                (Text(Image(systemName: "star")) + Text("secondWelcomeSubTitleIconTwo"))
            //
            //                (Text(Image(systemName: "play.circle")) + Text("secondWelcomeSubTitleIconThree"))
            //            }
            //            .font(.title3)
        }
        .setSchemeColor()
        .multilineTextAlignment(.leading)
    }
}
