//
//  ARModelAlert.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 28.12.2023.
//

import SwiftUI

struct ARModelAlert: View {
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    
    var body: some View {
        if let modelEntity = self.placementSettings.selectedModelEntity {
            if modelEntity.availableAnimations.isEmpty == false {
                Button("animOn") {
                    modelEntity.availableAnimations.forEach {
                        modelEntity.playAnimation($0.repeat())
                    }
                    
                    self.placementSettings.modelsAnimationDict[modelEntity, default: false] = true
                }
                .disabled(placementSettings.modelsAnimationDict[modelEntity, default: false] == true)

                Button("animOff") {
                    modelEntity.stopAllAnimations()

                    self.placementSettings.modelsAnimationDict[modelEntity, default: false] = false

                }
                .disabled(placementSettings.modelsAnimationDict[modelEntity, default: false] == false)
            }
            
            Button("delete", role: .destructive) {
                modelEntity.removeFromParent()
                
                self.placementSettings.modelsOnScene = self.placementSettings.modelsOnScene.filter { $0 != modelEntity }
            }
        }
        
        Button("close", role: .cancel) { }
    }
}
