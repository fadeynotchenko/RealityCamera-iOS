//
//  PlacementSettings .swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import Combine
import RealityKit
import ARKit

class PlacementSettings: ObservableObject {
    
    @Published var selectedModel: USDZ3DModel? {
        willSet {
            guard let model = newValue else {
                return
            }
            
            print("Selected model \(model.name)")
        }
    }
    
    @Published var confirmedModel: USDZ3DModel? {
        willSet {
            guard let model = newValue else {
                return
            }
            
            print("Confirmed model \(model.name)")
        }
    }
    
    @Published var historyOfAnchors: [AnchorEntity] = []
    
    @Published var peopleOcclusionEnable = false
    @Published var objectOcclusionEnable = false
    
    @Published var selected3DText: Text3DModel?
    @Published var confirmed3DText: Text3DModel?
    
    @Published var isModelActionSheetShow = false
    @Published var selectedEntity: Entity?
    
    @Published var modelsAnimationDict = [Entity: Bool]()
    
    var sceneObserver: Cancellable?
}
