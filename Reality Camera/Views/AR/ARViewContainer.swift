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

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
        ARVariables.arView = CustomARView(frame: .zero, placementSettings: placementSettings)
        
        return ARVariables.arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) { }
}

struct ARVariables {
    static var arView: CustomARView!
}
