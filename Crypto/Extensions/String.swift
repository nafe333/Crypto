//
//  String.swift
//  Crypto
//
//  Created by Nafea Elkassas on 07/04/2026.
//

import Foundation
extension String {
    
    var removeHTMLOccurences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
