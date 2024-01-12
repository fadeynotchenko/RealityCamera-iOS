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
    
    @Published var selectedModel: USDZ3DModel?
    
    @Published var confirmedModel: USDZ3DModel? {
        willSet {
            guard let model = newValue else { return }
            
            //MARK: Delete same model and append. Like Set, but with sort
            self.historyOfModels = self.historyOfModels.filter { $0.id != model.id }
            self.historyOfModels.append(model)
            
            guard let modelEntity = model.modelEntity else { return }
            
            self.modelsOnScene.append(modelEntity)
        }
    }
    
    @Published var modelsOnScene: [ModelEntity] = []
    @Published var historyOfModels: [USDZ3DModel] = []
    
    @Published var peopleOcclusionEnable = false
    @Published var objectOcclusionEnable = false
    
    @Published var isModelActionsAlertShow = false
    @Published var selectedModelEntity: ModelEntity?
    
    @Published var modelsAnimationDict = [Entity: Bool]()
    
    var sceneObserver: Cancellable?
}
