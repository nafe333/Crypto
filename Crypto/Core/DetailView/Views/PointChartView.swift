//
//  CandleChartView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 14/04/2026.
//

import SwiftUI
import Charts

struct PointChartView: View {
    
    private let data: [Double]
    private let lineColor: Color
    @State private var animate: Bool = false
    private let minY: Double
    private let maxY: Double
    private let startingDate: Date
    private let endingDate: Date
    
    init(coin: CoinModel){
        // same as we did before in the chart view by just getting coins data
        
        let prices = coin.sparklineIn7D?.price ?? []
        self.data = prices
        let priceChange = (prices.last ?? 0) - (prices.first ?? 0)
        self.lineColor = priceChange >= 0 ? Color.theme.green : Color.theme.red
        self.maxY = prices.max() ?? 0
        self.minY = prices.min() ?? 0
        self.endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    
    var body: some View {
        VStack {
            chart
                .frame(height: 200)
                .clipped()
                .background(chartBackground)
                .overlay(
                    chartAxis.padding(.horizontal, 4),
                    alignment: .leading
                )
            
            dateView
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                animate = true
            }
        }
    }
    
    
    private var chart: some View {
        let step = max(data.count / 20, 1)
        
        return Chart {
            
            ForEach(data.indices, id: \.self) { index in
                let price = data[index]
                
                LineMark(
                    x: .value("Index", index),
                    y: .value("Price", animate ? price : data.first ?? 0)
                )
                .opacity(0.2)
                .foregroundStyle(lineColor)
                .interpolationMethod(.catmullRom)
            }
            
            ForEach(data.indices.filter { $0 % step == 0 }, id: \.self) { index in
                let price = data[index]
                
                PointMark(
                    x: .value("Index", index),
                    y: .value("Price", animate ? price : data.first ?? 0)
                )
                .symbol {
                    Circle()
                        .fill(Color.theme.background)
                        .frame(width: 6, height: 6)
                        .overlay(
                            Circle().stroke(lineColor, lineWidth: 2)
                        )
                }
            }
        }
        .chartYScale(domain: minY...maxY)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .shadow(color: Color.theme.accent.opacity(0.7), radius: 10)
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
    
    private var dateView: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}

#Preview {
    PointChartView(coin: DeveloperPreview.instance.coin)
}
