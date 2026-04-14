//
//  CoinChartDataModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 14/04/2026.
//

import Foundation

struct CoinChartData: Codable {
    let prices, marketCaps, totalVolumes: [[Double]]?
}
