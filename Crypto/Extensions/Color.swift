//
//  Color.swift
//  Crypto
//
//  Created by Nafea Elkassas on 21/03/2026.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenishColor")
    let red = Color("RedishColor")
    let secondaryText = Color("SecondaryTextColor")
}
