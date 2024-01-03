//
//  BottomBar.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI
import RealityKit
import ARKit
import StoreKit

struct BottomBarView: View {
    
    @State private var isModelsSheetShow = false
    @State private var isSettingSheetShow = false
    @State private var isImageViewShow = false
    @State private var isVideoViewShow = false
    @State private var isAdd3DTextViewShow = false
    
    @State private var isTorchOn = false
    
    @State private var cameraModeSelection: CameraMode = .photo
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    @EnvironmentObject private var cameraVM: CameraViewModel
    
    @AppStorage("IMAGE_TAP_COUNT") private var IMAGE_TAP_COUNT = 0
    
    @Namespace private var videoAnimation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
            HStack {
                VStack(spacing: 30) {
                    CButton(iconName: "square.grid.2x2.fill", color: cameraVM.isVideoRecord ? .gray : .white) {
                        self.isModelsSheetShow.toggle()
                    }
                    .disabled(cameraVM.isVideoRecord)
                    .fullScreenCover(isPresented: $isModelsSheetShow) {
                        ModelsView(isModelsViewShow: $isModelsSheetShow)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    CameraModeSelectionView()
                    
                    if self.cameraModeSelection == .photo {
                        PhotoButtonView()
                    } else {
                        VideoButtonView()
                    }
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    CButton(iconName: self.isTorchOn ? "bolt.fill" : "bolt.slash.fill", color: .white) {
                        self.toggleTorch()
                    }
                    
                    CButton(iconName: "gearshape.fill", color: cameraVM.isVideoRecord ? .gray : .white) {
                        self.isSettingSheetShow.toggle()
                    }
                    .disabled(cameraVM.isVideoRecord)
                    .sheet(isPresented: $isSettingSheetShow) {
                        SettingView(isSettingSheetShow: $isSettingSheetShow)
                    }
                }
            }
            .frame(maxWidth: 400)
            .padding(30)
        }
    }
    
    private func PhotoButtonView() -> some View {
        Button {
            self.getPhoto()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 65, height: 65)
                
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 75, height: 75)
            }
        }
        .shadow(radius: 3)
        .sheet(isPresented: $isImageViewShow) {
            if let image = self.cameraVM.imageFromCamera {
                ImageResultView(image: image, isImageViewShow: $isImageViewShow)
            }
        }
        .onChange(of: cameraVM.imageFromCamera) { _ in
            self.isImageViewShow.toggle()
            
            self.showRateView()
        }
    }
    
    private func VideoButtonView() -> some View {
        Button {
            self.getVideo()
        } label: {
            ZStack {
                if self.cameraVM.isVideoRecord {
                    Rectangle()
                        .fill(.red)
                        .matchedGeometryEffect(id: "video", in: self.videoAnimation)
                        .frame(width: 35, height: 35)
                        .cornerRadius(10)
                } else {
                    Circle()
                        .fill(.red)
                        .matchedGeometryEffect(id: "video", in: self.videoAnimation)
                        .frame(width: 65, height: 65)
                }
                
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 75, height: 75)
            }
            .animation(.easeIn(duration: 1), value: self.videoAnimation)
        }
        .shadow(radius: 3)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if self.cameraVM.isVideoRecord {
                self.cameraVM.recordTimeSeconds += 1
            }
        }
        .sheet(isPresented: $isVideoViewShow) {
            if let url = self.cameraVM.videoURL {
                VideoResultView(url: url, isVideoViewShow: $isVideoViewShow)
            }
        }
        .onChange(of: cameraVM.videoURL) { _ in
            self.isVideoViewShow.toggle()
            
            self.showRateView()
        }
    }
    
    private func CameraModeSelectionView() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    self.cameraModeSelection = .photo
                }
            } label: {
                Text("photo")
                    .bold()
                    .font(.system(size: 17))
                    .foregroundColor(self.cameraModeSelection == .photo ? .white : .gray)
            }
            .disabled(cameraVM.isVideoRecord)
            
            Button {
                withAnimation {
                    self.cameraModeSelection = .video
                }
            } label: {
                Text("video")
                    .bold()
                    .font(.system(size: 17))
                    .foregroundColor(self.cameraModeSelection == .video ? .white : .gray)
            }
            .disabled(cameraVM.isVideoRecord)
        }
    }
}

extension BottomBarView {
    private func getPhoto() {
        ARVariables.arView.snapshot(saveToHDR: false) { (image) in
            if let data = image?.pngData(), let compressedImage = UIImage(data: data) {
                simpleSuccess()
                
                self.cameraVM.imageFromCamera = compressedImage
            }
        }
    }
    
    private func getVideo() {
        if self.cameraVM.isVideoRecord {
            ARVariables.arView.finishVideoRecording { videoInfo in
                
                withAnimation {
                    self.cameraVM.isVideoRecord.toggle()
                    self.cameraVM.recordTimeSeconds = 0
                }
                
                self.cameraVM.videoURL = videoInfo.url
                
                self.simpleSuccess()
            }
        } else {
            do {
                try ARVariables.arView.startVideoRecording()
                
                withAnimation {
                    self.cameraVM.isVideoRecord.toggle()
                }
                
                self.simpleSuccess()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    device.torchMode = .on
                    
                    self.isTorchOn = true
                } else {
                    device.torchMode = .off
                    
                    self.isTorchOn = false
                }
                
                device.unlockForConfiguration()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func showRateView() {
        self.IMAGE_TAP_COUNT += 1

        if self.IMAGE_TAP_COUNT % 5 == 0 {
            guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

            SKStoreReviewController.requestReview(in: currentScene)
        }
    }
}
