//
//  ModelItem.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct ModelItemView: View {
    @ObservedObject var model: USDZ3DModel
    @Binding var isModelsSheetShow: Bool
    @Binding var isAdAlertShow: Bool
    @Binding var selectedModel: USDZ3DModel?
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    
    var body: some View {
        GeometryReader { reader in
            let width = reader.size.width
            
            Button {
                self.downloadModelEntity()
            } label: {
                ZStack {
                    if let image = self.model.thumbnail {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        ProgressView()
                    }
                    
                    HStack {
                        Spacer()
                        
                        if self.model.loadStatus == .notLoaded {
                            MiniIcon(systemName: "icloud.and.arrow.down")
                        }
                        
                        if self.model.isPremium && self.model.isAdViewed == false {
                            MiniIcon(systemName: "star")
                        }
                        
                        if self.model.isAnimation {
                            MiniIcon(systemName: "play.circle")
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(5)
                    
                    //MARK: Loading progress View
                    if case .loading(let percent) = self.model.loadStatus {
                        RoundedRectangle(cornerRadius: 8)
                            .trim(from: 0.0, to: CGFloat(percent))
                            .stroke(Color.blue, lineWidth: 4.0)
                            .animation(.linear, value: percent)
                    }
                    
                    //MARK: Cancel loading button
                    if case .loading(_) = self.model.loadStatus {
                        Button {
                            self.model.stopDownload()
                        } label: {
                            Image(systemName: "xmark")
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: width, height: width)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(7)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func MiniIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .frame(width: 17, height: 17)
            .foregroundColor(.white)
        
    }
}

extension ModelItemView {
    private func downloadModelEntity() {
        //MARK: Ads logic
        if self.model.isPremium && self.model.isAdViewed == false {
            self.isAdAlertShow = true
            self.selectedModel = self.model
            
            return
        }
        
        switch self.model.loadStatus {
        case .loaded:
            //MARK: Model is loaded -> show Placement View
            self.model.asyncLoadModelEntity { isLoaded in
                if isLoaded {
                    self.isModelsSheetShow = false
                    
                    self.placementSettings.selectedModel = model
                }
            }
        case .loading(_):
            self.model.stopDownload()
        case .notLoaded:
            //MARK: First Load
            self.model.asyncLoadModelEntity()
        }
    }
}
