//
//  HapticManager.swift
//  Crypto
//
//  Created by Nafea Elkassas on 02/04/2026.
//

import Foundation
import SwiftUI
class HapticManager {
    
    private static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
    
}
