//
//  CoinImageService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 29/03/2026.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    var imageSubscriber: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName: String = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscriber = NetworkingManager.download(url: url)
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw NetworkingManager.NetworkingError.unknown
                }
                return image
            }
            .receive(on: DispatchQueue.main)

            .sink(
                receiveCompletion: { completion in
                    NetworkingManager.handleCompletion(completion: completion)
                },
                receiveValue: { [weak self] downloadedImage in
                    guard let self = self else { return }
                    
                    self.image = downloadedImage
                    
                    self.fileManager.saveImage(
                        image: downloadedImage,
                        imageName: self.imageName,
                        folderName: self.folderName
                    )
                    
                    self.imageSubscriber?.cancel()
                }
            )
    }
    
    
}
