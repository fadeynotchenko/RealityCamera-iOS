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
                    Toggle("Перекрывать людей", isOn: $placementSettings.peopleOcclusionEnable)
                }
                
                Section {
                    Toggle("Перекрывать объекты", isOn: $placementSettings.objectOcclusionEnable)
                } footer: {
                    Label {
                        Text("При включенном режиме 3D модель может 'прятаться' за объектом или человеком, если оно находится за ним. Данные функции работают при наличии LiDAR датчика в устройстве.")
                    } icon: {
                        Image(systemName: "info.circle")
                    }
                    .foregroundColor(.gray)
                }
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .large)
            .toolbar {
                ToolbarItem {
                    Button("Закрыть") {
                        self.isSettingSheetShow.toggle()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}
