//
//  ARView+SelfSceneRecordable.swift
//  AR Photo
//
//  Created by Fadey Notchenko on 27.12.2022.
//

import Foundation
import RealityKit
import SCNRecorder
import Combine

private var cancellableKey: UInt8 = 0

@available(iOS 13.0, *)
extension ARView: SelfSceneRecordable {
    
    var _cancelable: Cancellable? {
        get {
            objc_getAssociatedObject(self, &cancellableKey) as? Cancellable
        }
        set {
            objc_setAssociatedObject(self, &cancellableKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func injectRecorder() {
        do {
            sceneRecorder = try SceneRecorder(self)
            
            #if !targetEnvironment(simulator)
            session.delegate = sceneRecorder
            #endif
            
            _cancelable?.cancel()
            _cancelable = scene.subscribe(to: SceneEvents.Update.self) { [weak sceneRecorder] (_) in
                sceneRecorder?.render()
            }
        }
        catch {
            assertionFailure("\(error)")
        }
    }
}
