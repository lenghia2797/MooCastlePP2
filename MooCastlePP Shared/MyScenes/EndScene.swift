//
//  EndScene.swift
//
//
//  Created by  on 4/9/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : Scene  {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        addChild([homeBtn, backgroundSpr, replayBtn, scoreLbl, bestLbl])
        
        replayBtn.position = CGPoint.withPercent(50, y: 50)
        
        homeBtn.position = CGPoint.withPercent(12, y: 90)
        
        setScore()
        Sounds.sharedInstance().playSound(soundName: "Sounds/sound_over")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            touchDownButtons(atLocation: location)            
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if homeBtn.contains(location){
                changeSceneTo(scene: MenuScene(size: self.size), withTransition: .doorsOpenVertical(withDuration: 0.5))}
            else if replayBtn.contains(location) {
                changeSceneTo(scene: GameScene(size: self.size), withTransition: .push(with: .right, duration: 0.5))
            }
        }
        
        touchUpAllButtons()
    }
}
