//
//  SettingsView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 26.10.2023.
//

import SwiftUI

struct SettingView: View {
    
    @Binding var isSettingSheetShow: Bool
    
    @EnvironmentObject private var placementSettings: PlacementSettings
    
    @AppStorage("modelsScale") private var modelsScale = 0.2
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Toggle("settings1", isOn: $placementSettings.peopleOcclusionEnable)
                    
                    Toggle("settings2", isOn: $placementSettings.objectOcclusionEnable)
                } footer: {
                    Label {
                        Text("settingsHint")
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundColor(.gray)
                }
                
                Section {
                    Slider(value: $modelsScale, in: 0.1...1, step: 0.1)
                } header: {
                    Text("settingsSlider")
                }
            }
            .navigationTitle("settings")
            .toolbar {
                ToolbarItem {
                    Button("close") {
                        self.isSettingSheetShow.toggle()
                    }
                    .setSchemeColor()
                }
            }
        }
    }
}
