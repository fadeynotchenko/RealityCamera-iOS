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
            let size = reader.size
            
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
                }
                .frame(width: size.width, height: size.width)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(7)
                .overlay {
                    if case .loading(let percent) = self.model.loadStatus {
                        RoundedRectangle(cornerRadius: 8)
                            .trim(from: 0.0, to: CGFloat(percent))
                            .stroke(Color.blue, lineWidth: 4.0)
                            .animation(.linear, value: percent)
                    }
                }
                .overlay {
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
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 5) {
                        Text("\(model.loads)")
                            .bold()
                            .font(.system(size: 16))
                            .setSchemeColor()
                        
                        MiniIcon(systemName: "square.and.arrow.down")
                        
                        Spacer()
                        
                        Group {
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
                    }
                    .padding(5)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func MiniIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .frame(width: 20, height: 20)
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
            //show placement view
            self.model.asyncLoadModelEntity { isLoaded in
                if isLoaded {
                    self.isModelsSheetShow = false
                    
                    self.placementSettings.selectedModel = model
                }
            }
        case .loading(_):
            self.model.stopDownload()
        case .notLoaded:
            self.model.asyncLoadModelEntity()
        }
    }
}
