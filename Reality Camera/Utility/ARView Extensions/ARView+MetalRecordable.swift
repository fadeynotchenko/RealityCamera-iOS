//
//  ARView+MetalRecordable.swift
//  AR Photo
//
//  Created by Fadey Notchenko on 27.12.2022.
//

import Foundation
import RealityKit
import SCNRecorder

private var sceneRecorderKey: UInt8 = 0
private var cancellableKey: UInt8 = 0

@available(iOS 13.0, *)
extension ARView: MetalRecordable {
    
#if !targetEnvironment(simulator)
    public var recordableLayer: RecordableLayer? { layer.sublayers?.first as? RecordableLayer }
#else
    public var recordableLayer: RecordableLayer? { layer as? RecordableLayer }
#endif
}
