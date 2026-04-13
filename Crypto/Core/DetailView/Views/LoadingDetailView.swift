//
//  LoadingDetailView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 05/04/2026.
//

import SwiftUI

struct LoadingDetailView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        if let coin = coin {
            ZStack {
                DetailView(coin: coin)
            }
        }
    }
}

