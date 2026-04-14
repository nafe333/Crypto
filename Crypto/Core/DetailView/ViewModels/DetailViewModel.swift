//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 06/04/2026.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private let coinDataChartService: CoinChartDataService
    private var cancellables = Set<AnyCancellable>()
    @Published var coin: CoinModel
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var coinUrl: String? = nil
    @Published var redditUrl: String? = nil
    @Published var coinDataForChart: CoinChartData? = nil

    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin)
        coinDataChartService = CoinChartDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(getStatistics)
            .sink {[weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additionals
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetail
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.description?.en
                self?.coinUrl = returnedCoinDetails?.links?.homepage?.first
                self?.redditUrl = returnedCoinDetails?.links?.subredditUrl
            }            
            .store(in: &cancellables)
        
        coinDataChartService.$chartData
            .sink{ [weak self] (returnedChartData) in
                self?.coinDataForChart = returnedChartData
            }
            .store(in: &cancellables)

    }
    
    private func getStatistics(coinDetail: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additionals: [StatisticModel]){
        let overViewArr = getOverviewStat(coinModel: coinModel)
        let additionalArr = getAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetail)
        
        return (overViewArr, additionalArr)
        
    }
    
    private func getOverviewStat(coinModel: CoinModel) -> [StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWithDecimals(num: 6)
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: priceChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Voume", value: volume)
        
        let overViewArray: [StatisticModel] = [
        priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overViewArray
    }
    
    private func getAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel]{
        let high = coinModel.high24H?.asCurrencyWithDecimals(num: 6) ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWithDecimals(num: 6) ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWithDecimals(num: 6) ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercent = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapChangePercent)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
        highStat, lowStat, priceChangeStat, marketCapStat, blockStat, hashingStat
        ]
        return additionalArray
    }
    
}
