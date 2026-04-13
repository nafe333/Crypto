//
//  LaunchView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 12/04/2026.
//

import SwiftUI
import Lottie

struct LaunchView: View {
    @State private var loadingText: [String] = "Loading your portfolio..".map{ String($0)}
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @Binding var showLaunchView: Bool
    @State private var loops: Int = 0
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            LottieView(name: "Bitcoin")
                .frame(width: 100, height: 100)
                .scaleEffect(1.0) 
                .padding(.bottom, 20)
            
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices, id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launch.accent)
                                .transition(AnyTransition.scale.animation(.easeIn))
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                }
            }
            .offset(y: 70)
        }
        .onAppear(perform: {
            showLoadingText.toggle()
        })
        .onReceive(timer, perform: { _ in
            withAnimation {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1

                }
                
            }
        })
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
