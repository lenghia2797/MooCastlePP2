//
//  VisibleRect.swift
//  
//
//  Created by  on 3/21/19.
//  Copyright © 2019 . All rights reserved.
//

import SpriteKit

class VisibleRect {
    static let screenSize = UIScreen.main.bounds.size
    
    static func center() -> CGPoint {
        return CGPoint(x: screenSize.width*0.5, y: screenSize.height*0.5)
    }
    
    static func left() -> CGPoint {
        return CGPoint(x: 0, y: screenSize.height*0.5)
    }
    
    static func right() -> CGPoint {
        return CGPoint(x: screenSize.width, y: screenSize.height*0.5)
    }
    
    static func top() -> CGPoint {
        return CGPoint(x: screenSize.width*0.5, y: screenSize.height)
    }
    
    static func bottom() -> CGPoint {
        return CGPoint(x: screenSize.width*0.5, y: 0)
    }
    
    static func leftTop() -> CGPoint {
        return CGPoint(x: 0, y: screenSize.height)
    }
    
    static func rightTop() -> CGPoint {
        return CGPoint(x: screenSize.width, y: screenSize.height)
    }
    
    static func leftBottom() -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    static func rightBottom() -> CGPoint {
        return CGPoint(x: screenSize.width, y: 0)
    }
    
    static func centerOfNode(node: SKSpriteNode) -> CGFont {
        return CGPoint(x: node.size.width*0.5, y: node.size.height*0.5) as! CGFont
    }
}
