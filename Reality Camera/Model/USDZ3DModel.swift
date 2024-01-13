//
//  3DModel.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import SwiftUI
import RealityKit
import Combine
import FirebaseStorage

class USDZ3DModel: Identifiable, ObservableObject {
    var modelEntity: ModelEntity?
    
    let id = UUID()
    let name: String
    let isAnimation: Bool
    let isPremium: Bool
    let category: ModelCategory
    let loads: Int
    
    @Published var isAdViewed = false
    @Published var thumbnail: UIImage?
    @Published var loadStatus: LoadStatus = .notLoaded
    
    private var cancellable: AnyCancellable?
    private var storageTask: StorageDownloadTask?
    
    @AppStorage("modelsScale") private var modelsScale = 0.2
    
    init(name: String, isAnimation: Bool, isPremium: Bool, category: ModelCategory, loads: Int) {
        self.name = name
        self.isAnimation = isAnimation
        self.isPremium = isPremium
        self.category = category
        self.loads = loads
        
        Task {
            await self.asyncDownloadThumbnail()
        }
    }
    
    func asyncDownloadThumbnail() async {
        let _ = FirebaseHelper.asyncDownloadToFileSystem(path: "thumbnails/\(self.name).png") { localURL in
            do {
                let imageData = try Data(contentsOf: localURL)
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.thumbnail = UIImage(data: imageData)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        self.setLoadedStatus()
    }
    
    func asyncLoadModelEntity(completion: @escaping (Bool) -> () = { _ in }) {
        self.storageTask = FirebaseHelper.asyncDownloadToFileSystem(path: "models/\(self.name).usdz") { localURL in
            self.cancellable = Entity.loadAsync(contentsOf: localURL).sink { status in
                switch status {
                case .failure(let error):
                    print(error.localizedDescription)
                    
                    completion(false)
                case .finished:
                    withAnimation {
                        self.loadStatus = .loaded
                    }
                    
                    completion(true)
                }
            } receiveValue: { entity in
                // Creating parent ModelEntity
                let parentEntity = ModelEntity()
                parentEntity.addChild(entity)
                
                // Anchoring the entity and adding it to the scene
                let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
                anchor.addChild(parentEntity)
                
                // Add a collision component to the parentEntity with a rough shape and appropriate offset for the model that it contains
                let entityBounds = entity.visualBounds(relativeTo: parentEntity)
                parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                
                self.modelEntity = parentEntity
                self.modelEntity?.scale *= Float(self.modelsScale)
            }
        } progressHandler: { percent in
            withAnimation {
                self.loadStatus = .loading(progress: percent)
            }
        }
    }
    
    private func setLoadedStatus() {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docURL.appendingPathComponent("models/\(name).usdz")
        
        DispatchQueue.main.async {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                self.loadStatus = .loaded
            } else {
                self.loadStatus = .notLoaded
            }
        }
    }
    
    func stopDownload() {
        if let storageTask = self.storageTask {
            storageTask.cancel()
        }
        
        self.loadStatus = .notLoaded
    }
}
