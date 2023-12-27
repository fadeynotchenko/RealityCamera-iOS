//
//  Reality_CameraApp.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 27.12.2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import YandexMobileAds

@main
struct Reality_CameraApp: App {
    
    @StateObject private var placementSettings = PlacementSettings()
    @StateObject private var firebaseVM = FirebaseViewModel()
    @StateObject private var cameraVM = CameraViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    init() {
        FirebaseApp.configure()
        
        Auth.auth().signInAnonymously()
        
        YMAMobileAds.initializeSDK()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(firebaseVM)
                .environmentObject(cameraVM)
                .environmentObject(networkMonitor)
                .onAppear {
                    self.firebaseVM.fetchData()
                }
        }
    }
}
