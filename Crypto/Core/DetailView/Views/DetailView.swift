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

    
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
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
}
