//
//  VideoResultView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI
import AVKit
import Photos

struct VideoResultView: View {
    
    let url: URL
    @Binding var isVideoViewShow: Bool
    
    @State private var isShareSheetViewShow = false
    
    @State private var player = AVPlayer()
    
    var body: some View {
        NavigationView {
            VStack {
                VideoPlayer(player: player)
                    .onAppear {
                        self.player = AVPlayer(url: url)
                        
                        self.player.play()
                    }
                
                HStack(spacing: 15) {
                    SButton {
                        self.isShareSheetViewShow.toggle()
                    }
                    .sheet(isPresented: $isShareSheetViewShow) {
                        ShareSheetView(itemsToShare: [url])
                    }
                    
                    GSButton {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                        }) { isSaved, error in
                            if isSaved {
                                self.isVideoViewShow.toggle()
                            }
                        }
                    }
                }
                .shadow(radius: 3)
            }
            .navigationBarTitle("Видео", displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button("Закрыть") {
                        self.isVideoViewShow = false
                    }
                    .setSchemeColor()
                }
            }
        }
    }
}
