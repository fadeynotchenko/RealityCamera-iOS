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
                }
            }
            
            Spacer()
            
            PlacementButton(systemName: "checkmark.circle.fill") {
                withAnimation {
                    if let selectedModel = self.placementSettings.selectedModel {
                        FirebaseHelper.incrementLoads(by: selectedModel.name)
                        
                        self.placementSettings.confirmedModel = selectedModel
                        self.placementSettings.selectedModel = nil
                        
                    }
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 40)
    }
    
    private func PlacementButton(systemName: String, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(.plain)
        }
        .frame(width: 75, height: 75)
    }
}
