//
//  Button.swift
//  
//
//  Created by  on 3/21/19.
//  Copyright © 2019 . All rights reserved.
//

import SpriteKit

class Button: Sprite {
    
    //Object with textures for any states of button
    var normal: SKTexture?
    
    enum State : Int8 {
        case normal = 1
        case press = 2
    }
    
    //MARK: - Initialisation
    override init() {
        super.init(imageNamed: "Images/empty_btn", size: CGSize.zero, position: CGPoint.zero, zPosition: 0)
    }
    
    init(normalName: String, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(imageNamed: normalName, size: size, position: position, zPosition: zPosition)
        
        self.normal = SKTexture(imageNamed: normalName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Button init(coder:) has not been implemented")
    }
    
    /**
     Private function for update texture by current state
     */
    fileprivate func changeTexture(state: State) {
        removeAllActions()
        
        switch state {
        case .normal:
            run(SKAction.scale(to: 1.0, duration: 0.025))
        case .press:
            run(SKAction.scale(to: 0.85, duration: 0.025))
        }
    }

    /**
     Call this function if user press on button
     */
    func touchDown() {
        Sounds.sharedInstance().playSound(soundName: SoundConfig.soundButton)
        
        changeTexture(state: .press)
    }
    
    func touchDown(ifInLocation location: CGPoint){
        if contains(location) {
            touchDown()
        }
    }
    
    /**
     Call this function if user cancel pressed on button
     */
    func touchUp() {
        changeTexture(state: .normal)
    }
    
}
