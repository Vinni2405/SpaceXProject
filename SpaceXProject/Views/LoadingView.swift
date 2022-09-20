//
//  LoadingView.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    var animation: AnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpAnimation() {
        let rocketAnimation = Animation.named("rocket-loader")
        animation = AnimationView(animation: rocketAnimation)
        animation?.frame.size = CGSize(width: 200, height: 200)
        animation?.center = center
        animation?.contentMode = .scaleAspectFit
        animation?.loopMode = .loop
        addSubview(animation!)
        animation?.play()
    }
}
