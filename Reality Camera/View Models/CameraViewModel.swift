//
//  CameraViewModel.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import SwiftUI

class CameraViewModel: ObservableObject {
    @Published var isVideoRecord = false
    @Published var recordTimeSeconds = 0
    
    @Published var imageFromCamera: UIImage?
    @Published var videoURL: URL?
}
