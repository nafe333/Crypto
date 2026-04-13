//
//  SettingsView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 09/04/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    private let playlistUrl: URL = URL(string: "https://www.youtube.com/playlist?list=PLwvDm4Vfkdphbc3bgy_LpLRQ9DDfFGcFu")!
    private let coinGeckoUrl: URL = URL(string: "https://docs.coingecko.com")!
    private let linkedInUrl: URL = URL(string: "https://www.linkedin.com/in/nafea-mostafa")!
    private let githubUrl: URL = URL(string: "https://github.com/nafe333")!
    private let defaultUrl: URL = URL(string: "https://www.youtube.com/shorts/TNuHWJHzi_s")!

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    aboutAppSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    coinGeckoSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    aboutMeSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    applicationSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
                .scrollContentBackground(.hidden)
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton(dismiss: _dismiss)
                }
            })
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    private var aboutAppSection: some View {
        Section("About this App") {
            VStack(alignment: .leading, spacing: 8){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is made following Swiftful thinking playlist on youtube using MVVM pattern, Combine and Coredata.")
                    .foregroundStyle(Color.theme.secondaryText)
                    .opacity(0.8)
                Link("Youtube Playlist", destination: playlistUrl)
                    .font(.callout)
                    .fontWeight(.medium)
            }
        }
        .padding(.vertical)
    }
    
    private var coinGeckoSection: some View {
        Section("CoinGecko") {
            VStack(alignment: .leading, spacing: 8){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame( height: 100)
                Text("The crypro currency data which is used here is all from the Coin Gecko free api.")
                    .foregroundStyle(Color.theme.secondaryText)
                    .opacity(0.8)
                Link("Read docs", destination: coinGeckoUrl)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .padding(.vertical)
        }

    }
    
    private var aboutMeSection: some View {
        Section("Developer") {
            VStack(alignment: .leading, spacing: 16){
                
                HStack(spacing: 16) {
                    Image("thorifenn")
                        .resizable()
                        .frame( width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(color: Color.theme.accent,radius: 5)
                    VStack(alignment: .leading,spacing: 8) {
                        
                        HStack(spacing: 8) {
                            Text("Nafea Mostafa")
                                .font(.headline)
                            
                            Link(destination: linkedInUrl, label: {
                                Image("linkedin")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                            })
                            
                            Link(destination: githubUrl, label: {
                                Image("github")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                            })
                        }
                        
                        Text("Junior iOS Developer and ITI graduate ")
                            .font(.caption)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    private var applicationSection: some View {
        Section("Application") {
            Link("Terms of Service", destination: defaultUrl)
            Link("Privacy Policy", destination: defaultUrl)
            Link("Company Website", destination: defaultUrl)
            Link("Learn More", destination: defaultUrl)
        }
    }
}
