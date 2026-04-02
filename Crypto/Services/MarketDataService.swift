//
//  MarketDataService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 31/03/2026.
//

import Foundation
import Combine

// url = https://api.coingecko.com/api/v3/global


class MarketDataService {
    
       //MARK: - Properties
    @Published var marketData: MarketData? = nil
    var dataSubscriber: AnyCancellable?
    
    init(){
        getData()
    }
    
       //MARK: - Behaviour
     func getData(){
        let urlString = "https://api.coingecko.com/api/v3/global"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        dataSubscriber = NetworkingManager.download(url: URL(string: urlString)!)
            .decode(type: GlobalData.self, decoder: decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedData) in
                self? .marketData = returnedData.data
                self?.dataSubscriber?.cancel()
            })
    }
}
