//
//  CoinChartDataService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 14/04/2026.
//

import Foundation
import Combine

class CoinChartDataService {
    
    private let coin: CoinModel
    @Published var chartData: CoinChartData? = nil
    var coinChartSubscriber: AnyCancellable?
    private let baseUrl: String = "https://api.coingecko.com/api/v3/coins"
    
    init(coin: CoinModel){
        self.coin = coin
        getCoins()
    }
    
       //MARK: - Behaviour
    func getCoins(){
        let urlString = "\(baseUrl)/\(coin.id)/market_chart?vs_currency=usd&days=7"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        coinChartSubscriber = NetworkingManager.download(url: URL(string: urlString)!)
            .decode(type: CoinChartData.self, decoder: decoder)
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedData) in
                self? .chartData = returnedData
                self?.coinChartSubscriber?.cancel()
            })
    }
    
    
}
