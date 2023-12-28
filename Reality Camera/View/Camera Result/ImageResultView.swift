//
//  ImageResultView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct ImageResultView: View {
    
    @State var image: UIImage
    @Binding var isImageViewShow: Bool
    
    @State private var isShareSheetViewShow = false
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { reader in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 3)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                HStack(spacing: 15) {
                    SButton {
                        self.isShareSheetViewShow.toggle()
                    }
                    .sheet(isPresented: $isShareSheetViewShow) {
                        ShareSheetView(itemsToShare: [self.image])
                    }
                    
                    GSButton {
                        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
                        
                        self.isImageViewShow.toggle()
                    }
                }
            }
            .navigationBarTitle("Фото", displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button("Закрыть") {
                        self.isImageViewShow = false
                    }
                    .setSchemeColor()
                }
            }
        }
    }
}
