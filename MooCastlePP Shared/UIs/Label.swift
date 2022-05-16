//
//  Label.swift
//  
//
//  Created by  on 4/8/19.
//  Copyright © 2019 . All rights reserved.
//

import SpriteKit

class Label: SKLabelNode {
    
    //MARK: - Initialisations
    
    /**
     Initialise label
     
     - property text: String with text for label.
     - property fontSize: CGFloat value with label font size.
     - property fontColorHex: String with code of color for label. It's be look like "#ffffff".
     - property position: CGPoint object with position new label on scene.
     - property zPosition: CGFloat value for set position label by z coordinate on scene.
     */
    init(text: String, fontSize: CGFloat, fontName: String, color: UIColor, position: CGPoint, zPosition: CGFloat) {
        super.init()
        self.text = text
        self.position = position
        self.zPosition = zPosition
        self.fontName = fontName
        self.color = color
        self.colorBlendFactor = 1.0
        
        //If game launch on iPad scale font size by x2
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad { self.fontSize = fontSize * 2}
        else { self.fontSize = fontSize}
        
        verticalAlignmentMode = .center
        horizontalAlignmentMode = .center
        
    }
    
    /**
     If your custom init function not can run compiler call this function
     */
    required init?(coder aDecoder: NSCoder) { fatalError("SimpleLabel init(coder:) has not been implemented")}
    
    //MARK: - Animations
    
    func changeTextWithAnimationScaled(withText text: String) {
        self.text = text
        removeAllActions()
        run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1, duration: 0.1)]))
    }
    
    func changeTextWithAnimationScaled(withText text: Int) { changeTextWithAnimationScaled(withText: String(text))}
    func changeTextWithAnimationScaled(withText text: Double) { changeTextWithAnimationScaled(withText: String(text))}
    func changeTextWithAnimationScaled(withText text: CGFloat) { changeTextWithAnimationScaled(withText: String(Double(text)))}
    
    //MARK: - You features
    
}
