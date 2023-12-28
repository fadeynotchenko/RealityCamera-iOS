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
                        
                        Text("Проблема соединения")
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
            .navigationBarTitle("3D Модели", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        self.isModelsSheetShow.toggle()
                    }
                    .setSchemeColor()
                }
            }
            .alert("Премиальная модель", isPresented: $isAdAlertShow) {
                Button("Посмотреть") {
                    self.isAdViewShow = true
                }
                
                Button("Закрыть", role: .cancel) { }
            } message: {
                Text("Данная модель является премиальной, для ее загрузки требуется посмотреть рекламу")
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.label)
                .bold()
                .font(.title3)
                .setSchemeColor()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(models) { model in
                        ModelItem(model: model, isModelsSheetShow: $isModelsSheetShow, isAdAlertShow: $isAdAlertShow, selectedModel: $selectedModel)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
            }
        }
        .padding(.leading)
    }
}
