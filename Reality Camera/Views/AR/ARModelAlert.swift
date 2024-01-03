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
        if let entity = self.placementSettings.selectedEntity {
            if entity.availableAnimations.isEmpty == false {
                Button("animOn") {
                    entity.availableAnimations.forEach {
                        entity.playAnimation($0.repeat())
                    }
                    
                    self.placementSettings.modelsAnimationDict[entity, default: false] = true
                }
                .disabled(placementSettings.modelsAnimationDict[entity, default: false] == true)

                Button("animOff") {
                    entity.stopAllAnimations()

                    self.placementSettings.modelsAnimationDict[entity, default: false] = false

                }
                .disabled(placementSettings.modelsAnimationDict[entity, default: false] == false)
            }
            
            Button("delete", role: .destructive) {
                entity.removeFromParent()
                
                self.placementSettings.anchorOnScene = self.placementSettings.anchorOnScene.filter { $0 != entity }
            }
        }
        
        Button("close", role: .cancel) { }
    }
}
