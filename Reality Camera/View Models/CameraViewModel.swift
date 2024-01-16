//
//  CameraViewModel.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import AVFoundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var isVideoRecord = false
    
    @Published var cameraPermissionGranted = false
    @Published var audioPermissionGranted = false
    
    @Published var recordTimeSeconds = 0
    
    //MARK: Camera result
    @Published var imageFromCamera: UIImage?
    @Published var videoURL: URL?
    
    func requestCameraAndAudioPermissions() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            DispatchQueue.main.async {
                self.cameraPermissionGranted = accessGranted
            }
        })
        
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { accessGranted in
            DispatchQueue.main.async {
                self.audioPermissionGranted = accessGranted
            }
        })
    }
}
