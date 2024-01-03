//
//  ModelsMenuView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct ModelsView: View {
    
    @Binding var isModelsViewShow: Bool
    
    @State private var isAdViewShow = false
    
    //MARK: Alerts
    @State private var isAdAlertShow = false
    @State private var isConnectionAlertShow = false
    
    //MARK: Is needed to track the availability of viewed advertisements for a given model
    @State private var selectedModel: USDZ3DModel?
    
    @EnvironmentObject private var firebaseViewModel: FirebaseViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var placementSettings: PlacementSettings
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    //MARK: History of models
                    if self.placementSettings.historyOfModels.isEmpty == false {
                        LazyModelsGrid(models: placementSettings.historyOfModels, title: NSLocalizedString("history", comment: ""), isModelsSheetShow: $isModelsViewShow, isAdAlertShow: $isAdAlertShow, selectedModel: $selectedModel)
                    }
                    
                    //MARK: All models sorted by category
                    ForEach(ModelCategory.allCases, id: \.self) { category in
                        let modelsByCategory = self.firebaseViewModel.models.filter({ $0.category == category })
                        
                        if modelsByCategory.isEmpty == false {
                            LazyModelsGrid(models: modelsByCategory, title: "\(category.label) (\(modelsByCategory.count))", isModelsSheetShow: $isModelsViewShow, isAdAlertShow: $isAdAlertShow, selectedModel: $selectedModel)
                        }
                    }
                }
                
                if self.firebaseViewModel.models.isEmpty {
                    ProgressView()
                }
                
                if let selectedModel = self.selectedModel, self.isAdViewShow, self.networkMonitor.isConnected {
                    AdView(model: selectedModel, isAdViewShow: $isAdViewShow)
                }
            }
            .navigationTitle("3d")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("close") {
                        self.isModelsViewShow.toggle()
                    }
                    .setSchemeColor()
                }
            }
            .alert("prem", isPresented: $isAdAlertShow) {
                Button("show") {
                    self.isAdViewShow = true
                }
                
                Button("close", role: .cancel) { }
            } message: {
                Text("premHint")
            }
            .alert("error", isPresented: $isConnectionAlertShow) {
                Button("close", role: .cancel) { }
            } message: {
                Text("badConnection")
            }
            .onChange(of: networkMonitor.isConnected) { _ in
                if self.networkMonitor.isConnected == false {
                    self.isConnectionAlertShow = true
                }
            }
            .onAppear {
                if self.networkMonitor.isConnected == false {
                    self.isConnectionAlertShow = true
                }
            }
        }
    }
}
