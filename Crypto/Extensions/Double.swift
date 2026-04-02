//
//  Double.swift
//  Crypto
//
//  Created by Nafea Elkassas on 22/03/2026.
//

import Foundation
extension Double {
    
    // regarding making the number formatted as a 6 digits number
    // first making the formatter that has properties we need for the desired number
    // بيخلي اقل رقم بعد الكسر ٢ واقصى رقم ٦ وده كله في حالة انه بعد الكسر
    private var currencyFormatter6: NumberFormatter {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencyCode = "USD"
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
        
    }
    
    private var currencyFormatter2: NumberFormatter {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencyCode = "USD"
        
        return formatter
        
    }
    
       //MARK: - Behaviour
    
    func asCurrencyWithDecimals(num: Int) -> String {
        let number = NSNumber(value: self)
        if num == 6 {
            return currencyFormatter6.string(from: number) ?? "$0.00"
        } else {
            return currencyFormatter2.string(from: number) ?? "$0.00"
        }
    }
    

    
    func asNumberString() -> String {
     return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }
}
