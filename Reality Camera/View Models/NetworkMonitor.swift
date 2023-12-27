//
//  NetworkMonitor.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    
    var isConnected = false

    init() {
        self.networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        
        self.networkMonitor.start(queue: workerQueue)
    }
}
