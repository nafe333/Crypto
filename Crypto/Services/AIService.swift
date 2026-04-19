//
//  AIService.swift
//  Crypto
//
//  Created by Nafea Elkassas on 19/04/2026.
//

import Foundation
import Combine

class AIService {
    
    static let shared = AIService()
    private init() {}
    private let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
    
    func sendMessage(messages: [ChatMessage]) -> AnyPublisher<String, Error> {
            
            guard let key = apiKey else {
                return Fail(error: URLError(.userAuthenticationRequired))
                    .eraseToAnyPublisher()
            }
            
            guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
                return Fail(error: URLError(.badURL))
                    .eraseToAnyPublisher()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("https://yourapp.com", forHTTPHeaderField: "HTTP-Referer")
            request.addValue("Cryptio", forHTTPHeaderField: "X-Title")
            
            let body: [String: Any] = [
                "model": "openai/gpt-3.5-turbo",
                "messages": messages.map {
                    ["role": $0.role, "content": $0.content]
                }
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let decoder = JSONDecoder()
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let response = output.response as? HTTPURLResponse,
                          200..<300 ~= response.statusCode else {
                        
                        let raw = String(data: output.data, encoding: .utf8) ?? "Unknown error"
                        throw NSError(domain: "API_ERROR", code: 0, userInfo: [NSLocalizedDescriptionKey: raw])
                    }
                    return output.data
                }
                .decode(type: OpenAIResponse.self, decoder: decoder)
                .map { $0.choices.first?.message.content ?? "No reply" }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
}
