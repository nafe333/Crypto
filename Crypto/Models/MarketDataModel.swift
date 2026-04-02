//
//  MarketDataModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 31/03/2026.
//

import Foundation

// MARK: - Welcome
struct GlobalData: Codable {
    let data: MarketData?
}

// MARK: - DataClass
struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd, volumeChangePercentage24HUsd: Double
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$ " + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$ " + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }){
            return "BTC " + item.value.asPercentString()
        }
        return ""
    }
}
