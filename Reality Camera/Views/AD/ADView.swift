//
//  ADView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 14.01.2024.
//

import SwiftUI

struct ADView: View {
    @ObservedObject var selectedModel: USDZ3DModel
    @Binding var isAdViewShow: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                InterstitialView(model: selectedModel, isAdViewShow: $isAdViewShow)
                
                VStack {
                    Text("adLoading")
                    
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("close") { }
                }
            }
        }
    }
}
