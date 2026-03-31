//
//  UIApplication.swift
//  Crypto
//
//  Created by Nafea Elkassas on 30/03/2026.
//

import Foundation
import SwiftUI
extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
