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
    
    var body: some View {
        ZStack {
            if self.placementSettings.historyOfAnchors.isEmpty == false {
                CButton(iconName: "arrow.uturn.backward", color: .red, size: 25) {
                    if let anchor = self.placementSettings.historyOfAnchors.last {
                        anchor.removeFromParent()
                        
                        withAnimation {
                            self.placementSettings.historyOfAnchors = self.placementSettings.historyOfAnchors.filter { $0 != anchor }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading)
            }
            
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
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

private extension Int {
    func secondsToHoursMinutesSeconds() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        var result = ""
        
        if hours < 10 {
            result.append("0\(hours):")
        } else {
            result.append("\(hours):")
        }
        
        if minutes < 10 {
            result.append("0\(minutes):")
        } else {
            result.append("\(minutes):")
        }
        
        if seconds < 10 {
            result.append("0\(seconds)")
        } else {
            result.append("\(seconds)")
        }
        
        return result
    }
}
