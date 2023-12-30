//
//  ModelsMenuView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct ModelsSheetView: View {
    
    @Binding var isModelsSheetShow: Bool
    
    @State private var isAdAlertShow = false
    @State private var isAdViewShow = false
    @State private var selectedModel: USDZ3DModel?
    
    @EnvironmentObject private var firebaseViewModel: FirebaseViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(ModelCategory.allCases, id: \.self) { category in
                        let modelsByCategory = self.firebaseViewModel.models.filter({ $0.category == category })
                        
                        if modelsByCategory.isEmpty == false {
                            HStackByCategory(models: modelsByCategory, category: category, isModelsSheetShow: $isModelsSheetShow, isAdAlertShow: $isAdAlertShow, selectedModel: $selectedModel)
                        }
                    }
                }
                
                if self.networkMonitor.isConnected == false && self.firebaseViewModel.models.isEmpty {
                    VStack {
                        Image(systemName: "wifi.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("badConnection")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                    }
                } else if self.firebaseViewModel.models.isEmpty {
                    ProgressView()
                }
                
                if let selectedModel = self.selectedModel, self.isAdViewShow, self.networkMonitor.isConnected {
                    AdView(model: selectedModel, isAdViewShow: $isAdViewShow)
                }
            }
            .navigationBarTitle("3d", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("close") {
                        self.isModelsSheetShow.toggle()
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
        }
    }
}

struct HStackByCategory: View {
    let models: [USDZ3DModel]
    let category: ModelCategory
    @Binding var isModelsSheetShow: Bool
    @Binding var isAdAlertShow: Bool
    @Binding var selectedModel: USDZ3DModel?
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 150))]
    
    var body: some View {
        VStack {
            Text(category.label)
                .bold()
                .font(.title2)
                .setSchemeColor()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(models) { model in
                    ModelItemView(model: model, isModelsSheetShow: $isModelsSheetShow, isAdAlertShow: $isAdAlertShow, selectedModel: $selectedModel)
                }
            }
        }
    }
}
