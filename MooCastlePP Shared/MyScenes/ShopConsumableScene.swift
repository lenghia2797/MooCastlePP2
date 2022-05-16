//
//  ShopScene.swift
//  SPEEDBOAT
//
//  Created by Mr. Joker on 9/5/19.
//  Copyright © 2019 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class ShopConsumableScene : Scene  {
    
    let toastLbl = Label(text: "You do not have enough coins to buy!", fontSize: 20, fontName: GameConfig.fontText, color: GameConfig.textColor, position: CGPoint.zero, zPosition: 6)
    
    var products = [ProductObject()]
    
    let buyBtn = Button(normalName: "long_btn", size: .zero, position: .zero, zPosition: 3)
    var canBuy: Bool = false
    
    let fillColor = #colorLiteral(red: 0.8079557491, green: 0.215183274, blue: 1, alpha: 1)
    let strokeColor = #colorLiteral(red: 0.332150675, green: 1, blue: 0.5482001333, alpha: 1)
    let selectColor = #colorLiteral(red: 1, green: 0.5296649216, blue: 0.1307519647, alpha: 1)
    let timeLbl = Label(text: "Time: 0", fontSize: 25, fontName: GameConfig.fontText, color: GameConfig.textColor, position: .withPercent(57, y: 90), zPosition: 3)
    let restoreBtn = Button(normalName: "long_btn", size: .zero, position: .zero, zPosition: 3)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        toastLbl.isHidden = true
        addChild([backgroundSpr, backBtn, nextBtn, toastLbl])
        products.removeAll()
        addProduct(atLocation: .withPercent(50, y: 75), nameText: "x1 = $0.99", name: "1")
        addProduct(atLocation: .withPercent(50, y: 65), nameText: "x3 = $2.99", name: "3")
        addProduct(atLocation: .withPercent(50, y: 55), nameText: "x5 = $4.99", name: "5")
        addProduct(atLocation: .withPercent(50, y: 45), nameText: "x12 = $9.99", name: "12")
        addProduct(atLocation: .withPercent(50, y: 35), nameText: "x25 = $19.99", name: "25")
        addBuyBtn()
        addRestoreBtn()
        let moretime = Sprite(imageNamed: "_moretime", size: .withPercentScaled(roundByWidth: 10), position: .withPercent(43, y: 90), zPosition: 3)
        addChild(moretime)
        
        let timeCount = UserDefaults.standard.integer(forKey: GameConfig.time)
        timeLbl.changeTextWithAnimationScaled(withText: " x \(timeCount)")
        addChild(timeLbl)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            touchDownButtons(atLocation: location)
            location0 = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if backBtn.contains(location) || swipe(location: location) == 2 {
                self.changeSceneTo(scene: MenuScene(size: self.size), withTransition: .push(with: .right, duration: 0.5))
            } else if nextBtn.contains(location) || swipe(location: location) == 1 {
                self.changeSceneTo(scene: ShopSubScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
            } else {
                touchOnRestoreBtn(ifLocation: location)
                touchOnBuyBtn(ifLocation: location)
                touchOnProduct(ifLocation: location)
            }
        }
        
        touchUpAllButtons()
    }
    
    func touchOnRestoreBtn(ifLocation pos: CGPoint) {
        if restoreBtn.contains(pos) {
            if GameConfig.restore() {
                showToast(text: "Restore successful", textColor: #colorLiteral(red: 0.719012085, green: 1, blue: 0.4277088886, alpha: 1), pos: .withPercent(50, y: 40))
            } else {
                showToast(text: "Restore failed", textColor: #colorLiteral(red: 1, green: 0.1533700632, blue: 0.05941105784, alpha: 1), pos: .withPercent(50, y: 40))
            }
            let time = UserDefaults.standard.integer(forKey: GameConfig.time)
            timeLbl.changeTextWithAnimationScaled(withText: " x \(time)")
            
        }
    }
    
    func showToast(text: String, textColor: UIColor, pos: CGPoint) {
        toastLbl.text = text
        toastLbl.color = textColor
        toastLbl.position = pos
        toastLbl.removeAllActions()
        toastLbl.run(SKAction.sequence([SKAction.unhide(), SKAction.moveBy(x: 0, y: 100, duration: 1.0), SKAction.hide()]))
    }
    
    func addProduct(atLocation pos: CGPoint, nameText: String, name: String) {
        let p = ProductObject()
        p.position = pos
        p.name = name
        
        p.rect = SKShapeNode(rect: CGRect(x: -100, y: -35, width: 200, height: 70), cornerRadius: 12)
        p.rect.zPosition = 2
        p.rect.fillColor = fillColor
        p.rect.strokeColor = strokeColor
        p.rect.lineWidth = 5
        p.productImg = Sprite(imageNamed: "_moretime", size: .withPercentScaled(roundByWidth: 10), position: CGPoint(x: -37, y: 0), zPosition: 3)
        
        p.nameLbl.text = nameText
        p.nameLbl.position.x = 37
        
        p.addChild(p.rect)
        p.addChild(p.productImg)
        p.addChild(p.nameLbl)
        
        addChild(p)
        products.append(p)
    }
    
    func addBuyBtn() {
        buyBtn.size = .sizeOfNode(_sizeOfTexture: SKTexture(imageNamed: "Images/long_btn").size(), _sizeofNode: .withPercentScaled(roundByWidth: 30))
        buyBtn.position = .withPercent(50, y: 24)
        updateBuyState(_canBuy: canBuy)
        let text = Label(text: "Buy Now", fontSize: 20, fontName: GameConfig.fontText, color: GameConfig.textColor3, position: .zero, zPosition: 2)
        buyBtn.addChild(text)
        addChild(buyBtn)
    }
    
    func addRestoreBtn() {
        restoreBtn.size = .sizeOfNode(_sizeOfTexture: SKTexture(imageNamed: "Images/long_btn").size(), _sizeofNode: .withPercentScaled(roundByWidth: 30))
        restoreBtn.position = .withPercent(50, y: 15)
        let text = Label(text: "Restore", fontSize: 20, fontName: GameConfig.fontText, color: GameConfig.textColor3, position: .zero, zPosition: 2)
        restoreBtn.addChild(text)
        addChild(restoreBtn)
    }
    
    func updateBuyState(_canBuy: Bool) {
        canBuy = _canBuy
        if canBuy {
            buyBtn.alpha = 1
        } else {
            buyBtn.alpha = 0.5
        }
    }
    
    func touchOnProduct(ifLocation pos: CGPoint) {
        var chooseProduct = false
        for p in products {
            if p.contains(pos) {
                updateBuyState(_canBuy: true)
                p.rect.strokeColor = selectColor
                p.isSelect = true
                chooseProduct = true
            } else {
                p.isSelect = false
                p.rect.strokeColor = strokeColor
            }
        }
        if !chooseProduct {
            updateBuyState(_canBuy: false)
        }
    }
    
    func touchOnBuyBtn(ifLocation pos: CGPoint) {
        if canBuy && buyBtn.contains(pos) {
            for p in products {
                if p.isSelect {
                    buy(p: p)
                }
            }
        }
    }
    
    func buy(p:ProductObject) {
        switch p.name {
        case "1":
            IAPManager.shared.purchase(product: .time1) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateTime(count: count)
                }
            }
        case "3":
            IAPManager.shared.purchase(product: .time3) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateTime(count: count)
                }
            }
        case "5":
            IAPManager.shared.purchase(product: .time5) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateTime(count: count)
                }
            }
        case "12":
            IAPManager.shared.purchase(product: .time10) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateTime(count: count)
                }
            }
        case "25":
            IAPManager.shared.purchase(product: .time20) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateTime(count: count)
                }
            }
        default:
            break
        }
    }
    
    func updateTime(count: Int) {
        let time = UserDefaults.standard.integer(forKey: GameConfig.time)
        let newTime = time + count
        UserDefaults.standard.setValue(newTime, forKey: GameConfig.time)
        timeLbl.changeTextWithAnimationScaled(withText: " x \(newTime)")
        KeyChain.save(key: GameConfig.timeKey, data: Data(value: newTime))
    }
}
