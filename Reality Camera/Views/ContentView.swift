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
    
    @AppStorage("isFirstEntry") private var isFirstEntry = true
    
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
//        .fullScreenCover(isPresented: $isFirstEntry) {
//            WelcomeView()
//        }
        .alert("actions", isPresented: $placementSettings.isModelActionSheetShow) {
            ARModelAlert()
        }
    }
}
