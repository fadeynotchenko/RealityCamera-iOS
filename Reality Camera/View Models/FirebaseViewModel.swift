//
//  FirebaseViewModel.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

class FirebaseViewModel: ObservableObject {
    @Published var models = [USDZ3DModel]()
    
    func fetchData() {
        FirebaseHelper.fetchData { model in
            self.models = model
        }
    }
}
