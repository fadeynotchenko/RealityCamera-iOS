//
//  ModelCategory.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 26.10.2023.
//

import Foundation

enum ModelCategory: String, CaseIterable {
    case memes
    case horror
    
    var label: String {
        switch self {
        case .memes:
            return "Мемы"
        case .horror:
            return "Хоррор"
        }
    }
}
