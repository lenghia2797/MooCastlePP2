//
//  GameViewHelper.swift
//  Math Simple
//
//  Created by  on 4/9/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SpriteKit

class GameViewHelper {
    
    static func alignItemsVerticallyWithPadding(padding: CGFloat, items: [SKNode], position: CGPoint) {
        let children:[SKNode] = items
        
        var height:CGFloat = -padding
        
        for child in children {
            height += child.frame.size.height*child.yScale + padding
        }
        
        var y:CGFloat = position.y + height/2
        for child in children {
            child.position = CGPoint(x: position.x, y: y - child.frame.size.height*child.yScale/2)
            y -= child.frame.size.height*child.yScale + padding
        }
    }
    
    static func alignItemsHorizontallyWithPadding(padding: CGFloat, items: [SKNode], position: CGPoint) {
        let children:[SKNode] = items
        
        var width:CGFloat = -padding
        
        for child in children {
            width += child.frame.size.width*child.xScale + padding
        }
        
        var x:CGFloat = position.x - width/2
        for child in children {
            child.position = CGPoint(x: x + child.frame.size.width*child.xScale/2, y: position.y)
            x += child.frame.size.width*child.xScale + padding
        }
    }
    
    static func alignItemsRowsAndCols(paddingX: CGFloat, paddingY: CGFloat, rows : Int, cols : Int, items: [SKNode], position: CGPoint) {
        let children:[SKNode] = items
        let size:CGSize = (children.last?.frame.size)!
        let xScale:CGFloat = 1
        let yScale:CGFloat = 1
        
        let width:CGFloat = size.width*CGFloat(cols)*xScale + paddingX*CGFloat(cols - 1)
        let height:CGFloat = size.height*CGFloat(rows)*yScale + paddingY*CGFloat(rows - 1)
        
        var posX:CGFloat = position.x - width / 2.0
        var posY:CGFloat = position.y + height / 2.0
        
        for i in 0...rows - 1 {
            for j in 0...cols - 1 {
                
                let index = i*cols + j
                let child = children[index]
                
                child.position = CGPoint(x: posX + child.frame.size.width*child.xScale/2, y: posY - child.frame.size.height*child.yScale/2)
                
                posX += child.frame.size.width*child.xScale + paddingX
            }
            
            // break down
            posX = position.x - width / 2.0
            posY -= size.height*yScale + paddingY
        }
        
    }
}
