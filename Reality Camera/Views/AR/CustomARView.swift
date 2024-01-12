//
//  CustomARView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation
import FocusEntity
import SwiftUI
import Combine
import ARKit
import RealityKit

class CustomARView: ARView {
    
    var focusEntity: FocusEntity?
    var placementSettings: PlacementSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, placementSettings: PlacementSettings) {
        self.placementSettings = placementSettings
        
        super.init(frame: frameRect)
        
        self.focusEntity = FocusEntity(on: self, style: .classic(color: .yellow))
        
        self.configure()
        
        self.setupSubscribers()
        
        self.enableGesture()        
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Config
extension CustomARView {
    private func configure() {
        self.environment.lighting.intensityExponent = 1
        
        self.placementSettings.sceneObserver = self.scene.subscribe(to: SceneEvents.Update.self) { _ in
            self.updateScene()
        }
        
        self.prepareForRecording()
        
        self.configureARWorldTracking()
    }
    
    private func configureARWorldTracking() {
        let config = ARWorldTrackingConfiguration()
        
        config.providesAudioData = true
        config.planeDetection = [.horizontal, .vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
}

//MARK: Object and People occlusion
extension CustomARView {
    
    //MARK: Tracking changes to camera settings
    private func setupSubscribers() {
        self.peopleOcclusionCancellable = placementSettings.$peopleOcclusionEnable.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusionState(isEnabled: isEnabled)
        }
        
        self.objectOcclusionCancellable = placementSettings.$objectOcclusionEnable.sink { [weak self] isEnabled in
            self?.updateObjectOcclusionState(isEnabled: isEnabled)
        }
    }
    
    private func updatePeopleOcclusionState(isEnabled: Bool) {
        print("\(#file): people occlusion is \(isEnabled)")
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else { return }
        
        guard let config = self.session.configuration as? ARWorldTrackingConfiguration else { return }
        
        if config.frameSemantics.contains(.personSegmentationWithDepth) {
            config.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.session.run(config)
    }
    
    private func updateObjectOcclusionState(isEnabled: Bool) {
        print("\(#file): object occlusion is \(isEnabled)")
        
        guard let config = self.session.configuration as? ARWorldTrackingConfiguration else { return }
        
        if self.environment.sceneUnderstanding.options.contains(.occlusion) {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
        
        self.session.run(config)
    }
}

//MARK: Tap gesture logic
extension CustomARView {
    func enableGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(findEntity(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Find entity by tap location, if model find -> open actions alert
    @objc func findEntity(_ rec: UITapGestureRecognizer) {
        let location = rec.location(in: self)
        
        if let entity = self.entity(at: location), let modelEntity = entity as? ModelEntity {
            self.placementSettings.isModelActionsAlertShow = true
            
            self.placementSettings.selectedModelEntity = modelEntity
        }
    }
}

//MARK: Update scene and place models
extension CustomARView {
    private func updateScene() {
        self.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            self.place(modelEntity)
            
            self.placementSettings.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        
        self.installGestures([.all], for: clonedEntity)
        
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        self.scene.addAnchor(anchorEntity)
    }
}
