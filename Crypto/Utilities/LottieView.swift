//
//  LottieView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 13/04/2026.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let name: String
    var loop: LottieLoopMode = .loop
    var speed: CGFloat = 1.5
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: name)
        
        animationView.loopMode = loop
        animationView.animationSpeed = speed
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        context.coordinator.animationView = animationView
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.animationView?.play()
    }
    
    class Coordinator {
        var animationView: LottieAnimationView?
    }
}
