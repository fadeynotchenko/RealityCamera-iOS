//
//  PlacementView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 25.10.2023.
//

import SwiftUI

struct PlacementView: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            
            PlacementButton(systemName: "xmark.circle.fill") {
                withAnimation {
                    self.placementSettings.selectedModel = nil
                    
                    self.placementSettings.selected3DText = nil
                }
            }
            
            Spacer()
            
            PlacementButton(systemName: "checkmark.circle.fill") {
                withAnimation {
                    if let selectedModel = self.placementSettings.selectedModel {
                        FirebaseHelper.incrementLoads(by: selectedModel.name)
                        
                        //3d model
                        self.placementSettings.confirmedModel = selectedModel
                        self.placementSettings.selectedModel = nil
                        
                    } else {
                        //3d text
                        self.placementSettings.confirmed3DText = self.placementSettings.selected3DText
                        self.placementSettings.selected3DText = nil
                    }
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 40)
    }
    
    func PlacementButton(systemName: String, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(.plain)
        }
        .frame(width: 75, height: 75)
    }
}
