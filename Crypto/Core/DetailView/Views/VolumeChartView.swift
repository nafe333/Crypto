//
//  VolumeChartView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 14/04/2026.
//

import SwiftUI
import Charts

struct VolumeChartView: View {
    private let data: [[Double]]
    private let minY: Double
    private let maxY: Double
    
    init(coinData: CoinChartData){
        self.data = coinData.totalVolumes ?? []
        let volumes = data.compactMap { $0.count >= 2 ? $0[1] : nil }
        self.maxY = volumes.max() ?? 0
        self.minY = volumes.min() ?? 0
    }
    
    var body: some View {
        VStack {
            chart
                .frame(height: 150)
                .clipped()
                .background(chartBackground)
                .overlay(
                    chartAxis.padding(.horizontal, 4),
                    alignment: .leading
                )
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
    
    private var chart: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                let item = data[index]
                
                if item.count >= 2 {
                    BarMark(
                        x: .value("Index", index),
                        y: .value("Volume", item[1])
                    )
                    .foregroundStyle(Color.theme.accent.opacity(0.6))
                }
            }
        }
        .chartYScale(domain: minY...maxY)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    private var chartAxis: some View {
        VStack(alignment: .leading) {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
}

//#Preview {
//    VolumeChartView(coinData: DeveloperPreview.instance.coin)
//}
