//
//  PortfolioView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 31/03/2026.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    
    var body: some View {
        
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton(dismiss: _dismiss)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingBarButtonItem
                }
            }
        }
    }
}


#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}
extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins: vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( selectedCoin?.id == coin.id ? Color.theme.green :Color.clear, lineWidth: 1 )
                        }
                }
            }
            .background(Color.theme.background)
               .scrollIndicators(.hidden)
            .frame(height: 120)
            .padding(.leading)
        }
        .background(Color.theme.background)
        .scrollIndicators(.hidden)
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWithDecimals(num: 6) ?? "")
            }
            Divider()
            HStack {
                Text("Holdings Amount")
                Spacer()
                TextField("Ex: 1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value")
                Spacer()
                Text(getCurrentValue().asCurrencyWithDecimals(num: 2))
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingBarButtonItem: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0 )
            
            Button(action: {
                saveButtonTapped()
            }, label: {
                Text("save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0 )
        }
        .font(.headline)
    }
    
    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonTapped(){
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
        else { return }
        // save to portfolio first , will do later
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show the checkmark , will hide it in a minute
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hiding the keyboard using the extension we made before
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
        
        
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }), 
            let amount = portfolioCoin.currentHoldings
        {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
