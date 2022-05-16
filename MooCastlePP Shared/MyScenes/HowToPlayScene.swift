//
//  HowToPlayScece.swift
//  Star-Puzzle
//
//  Created by hehehe on 6/17/21.
//  Copyright © 2021 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class HowToPlay: Scene {
    
    
    override func didMove(to view: SKView) {
        
        if self.size.height > 800 {
            backgroundSpr.texture = SKTexture(imageNamed: "Images/_HowToPlayBg_6.5.png")
        } else {
            backgroundSpr.texture = SKTexture(imageNamed: "Images/_HowToPlayBg_5.5.png")
        }
        
        addChild([backgroundSpr, backBtn])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
//            if soundBtn.contains(location) {
//                soundBtn.run(SKAction.scale(to: 0.85, duration: 0.025))
//            }
            touchDownButtons(atLocation: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
//            if soundBtn.contains(location) {
//                soundBtn.changeSwitchState()
//            } else
            if backBtn.contains(location){
                self.changeSceneTo(scene: MenuScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
            }
        }
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.025))
        soundBtn.run(SKAction.scale(to: 1.0, duration: 0.025))
        touchUpAllButtons()
    }
}
