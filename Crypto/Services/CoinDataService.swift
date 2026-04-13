//
//  CoinDataService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 24/03/2026.
//

import Foundation
import Combine

class CoinDataService {
    
       //MARK: - Properties
    @Published var allCoins: [CoinModel] = []
    var coinSubscriber: AnyCancellable?
    
    init(){
        getCoins()
    }
    
       //MARK: - Behaviour
     func getCoins(){
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&price_change_percentage=24h&order=market_cap_desc&per_page=250&page=1&sparkline=true"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        coinSubscriber = NetworkingManager.download(url: URL(string: urlString)!)
            .decode(type: [CoinModel].self, decoder: decoder)
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedCoins) in
                self? .allCoins = returnedCoins
                self?.coinSubscriber?.cancel()
            })
    }
}
