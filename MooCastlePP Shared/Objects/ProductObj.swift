//
//  ProductObj.swift
//  MooCastlePP iOS
//
//  Created by hehehe on 1/23/22.
//

import Foundation
import SpriteKit

class ProductObject : Sprite {
    var rect = SKShapeNode()
    var productImg = Sprite()
    var lock = Sprite()
    var isSelect = false
    var nameLbl = Label(text: "", fontSize: 20, fontName: GameConfig.fontText, color: GameConfig.textColor, position: .zero, zPosition: 3)
    var endLbl = Label(text: "", fontSize: 15, fontName: GameConfig.fontText, color: #colorLiteral(red: 1, green: 0.6776347991, blue: 0.2273559411, alpha: 1), position: .zero, zPosition: 3)
    override init () {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
