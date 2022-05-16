//
//  NewMenuScene.swift
//  B-RUNN
//
//  Created by ldmanh on 6/1/20.
//  Copyright © 2020 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene : Scene  {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        if UserDefaults.standard.integer(forKey: "maxLevel") < 1 {
            UserDefaults.standard.set(1, forKey: "maxLevel")
        }
        addChild([backgroundSpr, playBtn, soundBtn, shopBtn])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            if soundBtn.contains(location) {
                soundBtn.run(SKAction.scale(to: 0.85, duration: 0.025))
            }
            
            touchDownButtons(atLocation: location)
            location0 = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            soundBtn.changeSwitchState(ifInLocation: location)
            if playBtn.contains(location) || swipe(location: location) == 1 {
                UserDefaults.standard.set(0, forKey: GameConfig.mode)
                self.changeSceneTo(scene: LevelScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
            } else if shopBtn.contains(location) {
                self.changeSceneTo(scene: ShopConsumableScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
            }
        }
        soundBtn.run(SKAction.scale(to: 1.0, duration: 0.025))
        touchUpAllButtons()
    }
    
}
