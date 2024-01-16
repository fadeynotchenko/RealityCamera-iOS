//
//  TopBarView.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 24.10.2023.
//

import SwiftUI

struct TopBarView: View {

    @EnvironmentObject private var placementSettings: PlacementSettings
    @EnvironmentObject private var cameraVM: CameraViewModel
    
    @AppStorage("isFirstEntry") private var isFirstEntry = true
    
    var body: some View {
        HStack {
            //MARK: Need for text tearing out, there will be another button in the future,
            CButton(iconName: "info.circle.fill", color: .white, size: 25) {
                self.isFirstEntry = true
            }
            .hidden()
            
            Spacer()
            
            VStack(spacing: 15) {
                Text("Reality Camera")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 19))
                    .frame(maxWidth: .infinity, alignment: .center)

                if self.cameraVM.isVideoRecord {
                    Text(cameraVM.recordTimeSeconds.secondsToHoursMinutesSeconds())
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 90)
                        .padding(5)
                        .background(.red)
                        .cornerRadius(5)
                }
            }
            
            Spacer()
            
            CButton(iconName: "info.circle.fill", color: .white, size: 25) {
                self.isFirstEntry = true
            }
            .padding(.trailing)
        }
    }
}
