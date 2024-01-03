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
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("settings1", isOn: $placementSettings.peopleOcclusionEnable)
                }
                
                Section {
                    Toggle("settings2", isOn: $placementSettings.objectOcclusionEnable)
                } footer: {
                    Label {
                        Text("settingsHint")
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundColor(.gray)
                }
            }
            .navigationBarTitle("settings", displayMode: .large)
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
