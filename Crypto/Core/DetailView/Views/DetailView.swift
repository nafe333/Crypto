//
//  DetailView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 05/04/2026.
//

import SwiftUI

// don't depend on init for checking persistance
// as it may be recreated or called many times for the first creation of the view

struct DetailView: View {
   @StateObject private var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30.0
    @State private var showingDescription: Bool = false
    @State private var chartType: ChartType = .line


    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    chartTabs
                    swipeableCharts
                }
                .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionView
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    linksView
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                trailingToolBarButton
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
}
extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
                .font(.title)
                .bold()
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    private var trailingToolBarButton: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 30, height: 30)
        }
    }
    
    private var descriptionView: some View {
        ZStack {
            VStack(alignment: .leading) {
                if let coinDescript = vm.coinDescription {
                    Text(coinDescript)
                        .lineLimit(showingDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    
                }
                Button(action: {
                    withAnimation {
                        showingDescription.toggle()
                    }
                }, label: {
                    Text(showingDescription ? "Less" : "Show more..")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.vertical, 4)
                    
                })
                .tint(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var linksView: some View {
        HStack {
            if let homeUrlString = vm.coinUrl,
               let homeUrl = URL(string: homeUrlString) {
                Link("Website", destination: homeUrl)
            }
            Spacer()
            if let redditUrlString = vm.redditUrl,
               let redditUrl = URL(string: redditUrlString) {
                Link("Reddit", destination: redditUrl)
            }
        }
        .tint(.blue)
        .padding()
    }
    
    private var chartTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(title(for: type))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            chartType == type
                            ? Color.theme.accent.opacity(0.5)
                            : Color.theme.background.opacity(0.5)
                        )
                        .foregroundStyle(
                            chartType == type
                            ? .white
                            : Color.theme.secondaryText
                        )
                        .clipShape(Capsule())
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                chartType = type
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    private func title(for type: ChartType) -> String {
        switch type {
        case .line: return "Line"
        case .points: return "Points"
        case .volume: return "Volume"
        }
    }
    private var swipeableCharts: some View {
        TabView(selection: $chartType) {
            
            ChartView(coin: vm.coin)
                .tag(ChartType.line)
            
            PointChartView(coin: vm.coin)
                .tag(ChartType.points)
            
            Group {
                if let chartData = vm.coinDataForChart {
                    VolumeChartView(coinData: chartData)
                } else {
                    ProgressView()
                }
            }
            .tag(ChartType.volume)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 220)
    }
}
