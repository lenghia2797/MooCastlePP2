//
//  EnemyObject.swift
//  SPEEDBOAT
//
//  Created by Mr. Joker on 8/15/19.
//  Copyright © 2019 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyObject : Sprite {
    var animateFrames = [SKTexture]()
    var isEnable : Bool = true
    
    override init() {
        super.init()
    }
    
    init(size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(imageNamed: "img_effect_1", size: size, position: position, zPosition: zPosition)
        
        for i in 1...11 {
            animateFrames.append(SKTexture(imageNamed: "Images/img_effect_" + "\(i)"))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runEffectAnimation() {
        self.isEnable = false
        self.setScale(0.65)
        run(SKAction.sequence([SKAction.animate(with: animateFrames,
                                                timePerFrame: 0.05,
                                                resize: true,
                                                restore: true), SKAction.hide()]))
    }
    
    func reset() {
        self.setScale(1)
        self.isEnable = true
        self.isHidden = false
        self.texture = SKTexture(imageNamed: "Images/img_enemy_" + String(Int.random(in: 1...4)))
    }
}
