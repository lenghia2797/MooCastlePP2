//
//  Extentions.swift
//  
//
//  Created by  on 3/21/19.
//  Copyright © 2019 . All rights reserved.
//

import SpriteKit

//MARK: - Object extentions
public extension UIColor {
    /**
     Create UIColor object from hex value.
     
     - property hexString: It string with you color name in hex. It been look like it "#ffffff".
     */
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


//MARK: Animation
public extension SKAction {
    
    /**
     Same function like standart SKAction, but here we can use degrees for setup rotate destination.
     */
    static func rotateByDegree(_ degree: CGFloat, duration: TimeInterval) -> SKAction {
        return SKAction.rotate(byAngle: CGFloat(degreeToRadian: degree), duration: duration)
    }
    
    /**
     Same function like standart SKAction, but here we can use degrees for setup rotate destination.
     */
    static func rotateToDegree(_ degree: CGFloat, duration: TimeInterval) -> SKAction {
        return SKAction.rotate(toAngle: CGFloat(degreeToRadian: degree), duration: duration)
    }
    
    /**
     Same function like standart SKAction, but here we can use degrees for setup rotate destination.
     */
    static func rotateToDegree(_ degree: CGFloat, duration: TimeInterval, shortestUnitArc: Bool) -> SKAction {
        return SKAction.rotate(toAngle: CGFloat(degreeToRadian: degree), duration: duration, shortestUnitArc: shortestUnitArc)
    }
}

//MARK: Sizes and positions

public extension CGSize {
    
    /**
     Init size form percent size of scene.
     */
    static func withPercent(_ width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: CGFloat(VisibleRect.screenSize.width) / 100 * width, height: CGFloat(VisibleRect.screenSize.height) / 100 * height)
    }
    
    /**
     Init size form percent size of scene. In this init height scaled by widht. Use this for make size with an equal aspect ratio on different screen sizes.
     */
    static func withPercentScaledByWith(_ width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: CGFloat(VisibleRect.screenSize.width) / 100 * width, height: CGFloat(VisibleRect.screenSize.width) / 100 * height)
    }
    
    static func withPercentScaledByHeight(_ width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: CGFloat(VisibleRect.screenSize.height) / 100 * width, height: CGFloat(VisibleRect.screenSize.height) / 100 * height)
    }
    
    static func withPercentScaled(roundByWidth width: CGFloat) -> CGSize {
        return CGSize(width: CGFloat(VisibleRect.screenSize.width) / 100 * width, height: CGFloat(VisibleRect.screenSize.width) / 100 * width)
    }
    
    static func withPercentScaled(roundByHeight height: CGFloat) -> CGSize {
        return CGSize(width: CGFloat(VisibleRect.screenSize.height) / 100 * height, height: CGFloat(VisibleRect.screenSize.height) / 100 * height)
    }
    
    static func sizeOfNode(_sizeOfTexture: CGSize, _sizeofNode: CGSize) -> CGSize {
        if _sizeOfTexture.width > _sizeOfTexture.height {
            return CGSize(width: _sizeofNode.width, height: _sizeOfTexture.height * (_sizeofNode.width / _sizeOfTexture.width) )
        } else {
            return CGSize(width: _sizeOfTexture.width * (_sizeofNode.height / _sizeOfTexture.height) , height: _sizeofNode.height )
        }
    }
}

public extension CGPoint {
    
    /**
     Init position from percent of screen size
     */
    static func withPercent(_ x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(VisibleRect.screenSize.width) / 100 * x, y: CGFloat(VisibleRect.screenSize.height) / 100 * y)
    }
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    static func milde() -> CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }
    
    static func top() -> CGPoint {
        return CGPoint(x: 0.5, y: 1)
    }
    
    static func bottom() -> CGPoint {
        return CGPoint(x: 0.5, y: 0)
    }
    
    static func left() -> CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
    
    static func right() -> CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }
    
    static func leftTop() -> CGPoint {
        return CGPoint(x: 0, y: 1)
    }
    
    static func rightTop() -> CGPoint {
        return CGPoint(x: 1, y: 1)
    }
    
    static func leftBottom() -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    static func rightBottom() -> CGPoint {
        return CGPoint(x: 1, y: 0)
    }
}

//MAKR: - SKSpriteNode

public extension SKSpriteNode {
    
    func new(positionByX x: CGFloat) {
        self.position = CGPoint(x: x, y: position.y)
    }
    
    func new(positionByY y: CGFloat) {
        self.position = CGPoint(x: position.x, y: y)
    }
}

//MARK: - Value extentions

//Randoms

public extension Int {
    init(from: Int, to: Int) {
        self = from < to ?
            Int(arc4random_uniform(UInt32(to - from + 1))) + from :
            Int(arc4random_uniform(UInt32(from - to + 1))) + to
    }
    
    init(fromZeroTo value: Int) {
        self = Int(from: 0, to: value)
    }
}

public extension Double {
    
    init(from: Double, to: Double) {
        self = from < to ?
            (Double(arc4random()) / Double(UInt32.max)) * (to - from) + from :
            (Double(arc4random()) / Double(UInt32.max)) * (from - to) + to
    }
    
    init(fromZeroTo value: Double) {
        self = Double(from: 0, to: value)
    }
    
    init(degreeToRadian degree: Double) {
        self = degree * Double.pi / 180.0
    }
}

public extension Float {
    
    init(from: Float, to: Float) {
        self = from < to ?
            (Float(arc4random()) / Float(UInt32.max)) * (to - from) + from :
            (Float(arc4random()) / Float(UInt32.max)) * (from - to) + to
    }
    
    init(fromZeroTo value: Float) {
        self = Float(from: 0, to: value)
    }
    
    init(degreeToRadian degree: Float) {
        self = degree * Float.pi / 180.0
    }
}

public extension CGFloat {
    
    init(from: CGFloat, to: CGFloat) {
        self = from < to ?
            (CGFloat(arc4random()) / CGFloat(UInt32.max)) * (to - from) + from :
            (CGFloat(arc4random()) / CGFloat(UInt32.max)) * (from - to) + to
    }
    
    init(fromZeroTo value: CGFloat) {
        self = CGFloat(from: 0, to: value)
    }
    
    init(degreeToRadian degree: CGFloat) {
        self = degree * CGFloat.pi / 180.0
    }
}

public extension Bool {
    static func random() -> Bool {
        return Int(from: 1, to: 2) == 1 ? true : false
    }
}

//Shuffle array

extension Array where Element: Equatable {
    mutating func shuffle() {
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
    
    @discardableResult
    public mutating func remove(_ item: Element) -> Array {
        if let index = firstIndex(where: { item == $0 }) {
            remove(at: index)
        }
        return self
    }
    
    @discardableResult
    public mutating func removeAll(_ item: Element) -> Array {
        removeAll(where: { item == $0 })
        return self
    }
}
