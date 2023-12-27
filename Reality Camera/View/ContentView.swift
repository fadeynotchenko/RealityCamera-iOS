//
//  ContentView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    @EnvironmentObject private var firebaseVM: FirebaseViewModel
    
    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                TopBarView()
                
                Spacer()
                
                if self.placementSettings.selectedModel == nil && self.placementSettings.selected3DText == nil {
                    BottomBarView()
                } else {
                    PlacementView()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .alert("Действия с объектом", isPresented: $placementSettings.isModelActionSheetShow) {
            AlertView()
        }
    }
    
    @ViewBuilder
    private func AlertView() -> some View {
        if let entity = self.placementSettings.selectedEntity {
            if entity.availableAnimations.isEmpty == false {
                Button("Включить анимацию") {
                    entity.availableAnimations.forEach {
                        entity.playAnimation($0.repeat())
                    }
                    
                    self.placementSettings.modelsAnimationDict[entity, default: false] = true
                }
                .disabled(placementSettings.modelsAnimationDict[entity, default: false] == true)

                Button("Выключить анимацию") {
                    entity.stopAllAnimations()

                    self.placementSettings.modelsAnimationDict[entity, default: false] = false

                }
                .disabled(placementSettings.modelsAnimationDict[entity, default: false] == false)
            }
            
            Button("Удалить", role: .destructive) {
                entity.removeFromParent()
                
                self.placementSettings.historyOfAnchors = self.placementSettings.historyOfAnchors.filter { $0 != entity }
            }
        }
        
        Button("Закрыть", role: .cancel) { }
    }
}
