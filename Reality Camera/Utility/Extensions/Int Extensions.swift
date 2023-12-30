//
//  Int Extensions.swift
//  Reality Camera
//
//  Created by Fadey Notchenko on 28.12.2023.
//

import Foundation

extension Int {
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
