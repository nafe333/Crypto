//
//  ChatViewModel.swift
//  Crypto
//
//  Created by Nafea Elkassas on 19/04/2026.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    @Published var suggestions: [String] = [
        "What is Bitcoin?",
        "Explain Ethereum",
        "Top trending coins",
        "What is market cap?"
    ]
    
    
    func send(_ text: String) {
        let userMessage = ChatMessage(role: "user", content: text)
        messages.append(userMessage)
        isLoading = true
        updateSuggestions(for: text)
        let systemMessage = ChatMessage(
            role: "system",
            content: """
                You are a crypto assistant inside a trading app.
                Rules:
                - Only answer crypto-related questions.
                - Be concise.
                - just stich with the question user asks pleaaaase.
                """
        )
        let fullMessages = [systemMessage] + messages
        AIService.shared.sendMessage(messages: fullMessages)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.messages.append(
                        ChatMessage(role: "assistant", content: " \(error.localizedDescription)")
                    )
                }
                
            } receiveValue: { [weak self] reply in
                self?.messages.append(
                    ChatMessage(role: "assistant", content: reply)
                )
            }
            .store(in: &cancellables)
    }
    
    
    private func updateSuggestions(for input: String) {
        let lower = input.lowercased()
        
        let newSuggestions: [String]
        
        if lower.contains("bitcoin") {
            newSuggestions = [
                "Is Bitcoin a good investment?",
                "Why is Bitcoin valuable?",
                "Bitcoin vs Ethereum",
                "What affects BTC price?"
            ]
        } else {
            newSuggestions = [
                "Top trending coins",
                "Best coins to watch",
                "Explain crypto basics",
                "How to start investing?"
            ]
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.suggestions = newSuggestions
            }
        }
    }
}
