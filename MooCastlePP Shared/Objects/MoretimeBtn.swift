//
//  MoretimeBtn.swift
//  MooCastlePP iOS
//
//  Created by hehehe on 1/22/22.
//

import Foundation
import SpriteKit

class MoretimeBtn : Button {
    let shape = SKShapeNode(circleOfRadius: 9)
    let numberLbl = Label(text: "0", fontSize: 15, fontName: GameConfig.fontText, color: .white, position: .zero, zPosition: 2)
    override init() {
        super.init()
    }
    
    override init(normalName: String, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(normalName: normalName, size: size, position: position, zPosition: zPosition)
        shape.position = CGPoint(x: size.width/2, y: size.height/2)
        shape.zPosition = 1
        shape.fillColor = .red
        shape.strokeColor = .red
        numberLbl.position = shape.position
        addChild(shape)
        addChild(numberLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Button init(coder:) has not been implemented")
    }

    func updateNumber(n: Int) {
        numberLbl.changeTextWithAnimationScaled(withText: "\(n)")
    }
}
