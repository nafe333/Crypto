//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Nafea Elkassas on 24/03/2026.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String?{
            switch self {
            case.badURLResponse(url: let url): return "Bad response from the url \(url)"
            case .unknown: return "Unknown error happenned"
            }
        }
    }
    
    static func handleUrl(url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("CG-qyCXc2qh3hf183NcLWsruonC", forHTTPHeaderField: "x-cg-api-key")
        return request
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        
        guard let request = handleUrl(url: url.absoluteString) else {
            return Fail(error: NetworkingError.badURLResponse(url: url))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
