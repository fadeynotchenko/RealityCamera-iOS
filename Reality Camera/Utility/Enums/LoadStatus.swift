//
//  LoadStatus.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import Foundation

enum LoadStatus: Equatable {
    case loaded
    case notLoaded
    case loading(progress: Double)
}
