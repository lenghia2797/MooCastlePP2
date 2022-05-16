//
//  CoinObject.swift
//  SPEEDBOAT
//
//  Created by Mr. Joker on 9/5/19.
//  Copyright © 2019 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class CoinObject : Sprite {
    override init() {
        super.init()
    }
    
    init(size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(imageNamed: "img_coin_1", size: size, position: position, zPosition: zPosition)
        
        var animateFrames = [SKTexture]()
        for i in 1...10 {
            animateFrames.append(SKTexture(imageNamed: "Images/img_coin_" + "\(i)"))
        }
        
        run(SKAction.repeatForever(SKAction.animate(with: animateFrames,
                                                    timePerFrame: 0.05,
                                                    resize: false,
                                                    restore: false)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
