//
//  ARViewContainer.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import RealityKit
import ARKit
import Combine
import SwiftUI

struct ARVariables {
    static var arView: CustomARView!
    static var configuration: ARWorldTrackingConfiguration!
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
        ARVariables.arView = CustomARView(frame: .zero, placementSettings: placementSettings)
        
        //3d models light
        ARVariables.arView.environment.lighting.intensityExponent = 1
        
        self.placementSettings.sceneObserver = ARVariables.arView.scene.subscribe(to: SceneEvents.Update.self) { _ in
            self.updateScene()
        }
        
        ARVariables.arView.prepareForRecording()
        
        return ARVariables.arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
    
    private func updateScene() {
        ARVariables.arView.focusEntity?.isEnabled = (self.placementSettings.selectedModel != nil) || (self.placementSettings.selected3DText != nil)
        
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            self.place(modelEntity)
            
            self.placementSettings.confirmedModel = nil
        } else if let textModel = self.placementSettings.confirmed3DText {
            let modelEntity = self.generate3DText(textModel: textModel)
            
            self.place(modelEntity)
            
            self.placementSettings.confirmed3DText = nil
        }
        
    }
    
    private func place(_ modelEntity: ModelEntity) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        
        ARVariables.arView.installGestures([.all], for: clonedEntity)
        
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        ARVariables.arView.scene.addAnchor(anchorEntity)
        
        self.placementSettings.historyOfAnchors.append(anchorEntity)
    }
}

extension ARViewContainer {
    func generate3DText(textModel: Text3DModel) -> ModelEntity {
        let materialVar = SimpleMaterial(color: UIColor(textModel.color), isMetallic: false)
        
        let mesh = MeshResource.generateText(
            textModel.text,
            extrusionDepth: 0.1,
            font: .init(name: textModel.font, size: textModel.size)!,
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byTruncatingTail)
        
        let textEntity = ModelEntity(mesh: mesh, materials: [materialVar])
        textEntity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
        
        return textEntity
    }
}
