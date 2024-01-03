//
//  LazyModelsGrid.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 03.01.2024.
//

import SwiftUI

struct LazyModelsGrid: View {
    let models: [USDZ3DModel]
    let title: String
    @Binding var isModelsSheetShow: Bool
    @Binding var isAdAlertShow: Bool
    @Binding var selectedModel: USDZ3DModel?
    
    //MARK: If this var == 0 -> show View, else -> hide
    @State private var rotationAngle: Double = 0
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 125))]
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    self.rotationAngle = self.rotationAngle == 0 ? 180 : 0
                }
            } label: {
                HStack {
                    Text(title)
                        .bold()
                        .font(.title2)
                        .setSchemeColor()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .setSchemeColor()
                        .rotationEffect(.degrees(rotationAngle))
                }
            }
            .padding(.horizontal)
            
            if self.rotationAngle == 0 {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(models) { model in
                        ModelItemView(model: model, isModelsSheetShow: $isModelsSheetShow, isAdAlertShow: $isAdAlertShow, selectedModel: $selectedModel)
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
}

