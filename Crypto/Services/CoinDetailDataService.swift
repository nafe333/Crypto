//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 06/04/2026.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel? = nil
    var coinDetailSubscriber: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinDetails()
    }
    
       //MARK: - Behaviour
     func getCoinDetails(){
        let urlString = "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
         coinDetailSubscriber = NetworkingManager.download(url: URL(string: urlString)!)
            .decode(type: CoinDetailModel.self, decoder: decoder)
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedDetails) in
                self? .coinDetail = returnedDetails
                self?.coinDetailSubscriber?.cancel()
            })
    }
}
