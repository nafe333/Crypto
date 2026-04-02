//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 23/03/2026.
//

import Foundation
import Combine
class HomeViewModel: ObservableObject {
    
       //MARK: - Properties
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
addSubscribers()
    }
    
       //MARK: - Behaviour
    private func addSubscribers(){
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        // portfolio updates
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (recievedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: recievedCoins)
            }
            .store(in: &cancellable)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalData)
            .sink {[weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellable)

    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercased = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercased) ||
            coin.symbol.lowercased().contains(lowercased) ||
            coin.id.contains(lowercased)
        }
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
       var filteredCoins = filterCoins(text: text, coins: coins)
        // sort goes under here
        sortCoins(sort: sort, coins: &filteredCoins)
        
        return filteredCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank, .holdings:
             coins.sort(by: { $0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
             coins.sort(by: { $0.rank > $1.rank})
        case .price:
             coins.sort(by: { $0.currentPrice > $1.currentPrice})
        case .priceReversed:
             coins.sort(by: { $0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(coinsModel: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        coinsModel
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalData(marketData: MarketData?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketData else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue =
        portfolioCoins.map({ $0.currentHoldingsValue})
            .reduce(0, +)
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }
            .reduce(0, +)
        
        let percentageChange: Double

        if previousValue == 0 {
            percentageChange = 0
        } else {
            percentageChange = ((portfolioValue - previousValue) / previousValue * 100)
        }
        
        let portfolio = StatisticModel(
            title: "Portfolio",
            value: portfolioValue.asCurrencyWithDecimals(num: 2),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap
                                  , volume
                                  , btcDominance
                                  , portfolio])
        
        return stats
    }
    
}
