//
//  ShopScene.swift
//  SPEEDBOAT
//
//  Created by Mr. Joker on 9/5/19.
//  Copyright © 2019 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class ShopSubScene : Scene  {
//    static let shared = ShopSubScene()
    
    let toastLbl = Label(text: "You do not have enough coins to buy!", fontSize: 20, fontName: GameConfig.fontText, color: GameConfig.textColor, position: CGPoint.zero, zPosition: 6)
    
    var products = [ProductObject()]
    
    let buyBtn = Button(normalName: "long_btn", size: .zero, position: .zero, zPosition: 3)
    var canBuy: Bool = false
    
    let fillColor = #colorLiteral(red: 0.8079557491, green: 0.215183274, blue: 1, alpha: 1)
    let strokeColor = #colorLiteral(red: 0.332150675, green: 1, blue: 0.5482001333, alpha: 1)
    let selectColor = #colorLiteral(red: 1, green: 0.5296649216, blue: 0.1307519647, alpha: 1)
    let restoreBtn = Button(normalName: "long_btn", size: .zero, position: .zero, zPosition: 3)
    
    let monsterSpr = Sprite(imageNamed: "_snowman_1", size: .withPercentScaled(roundByWidth: 10), position: .withPercent(50, y: 90), zPosition: 3)
    
//    let testLbl = Label(text: "empty", fontSize: 12, fontName: GameConfig.fontText, color: GameConfig.textColor, position: .withPercent(50, y: 10), zPosition: 3)
    
    var date = Date()
    
//    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        toastLbl.isHidden = true
        addChild([backBtn, backgroundSpr, toastLbl, monsterSpr])
        products.removeAll()
        addProduct(atLocation: .withPercent(50, y: 35 + 13*3), nameText: "Free", name: "1")
        addProduct(atLocation: .withPercent(50, y: 35 + 13*2), nameText: "$0.99/3days", name: "3")
        addProduct(atLocation: .withPercent(50, y: 35 + 13), nameText: "$9.99/month", name: "5")
        addProduct(atLocation: .withPercent(50, y: 35), nameText: "$19.99/month", name: "7")
        addBuyBtn()
        addRestoreBtn()
        
        let m = UserDefaults.standard.integer(forKey: GameConfig.monsterType) 
        setMonsterSpr(m: m)
        
        checkSub()
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
                self.changeSceneTo(scene: ShopConsumableScene(size: self.size), withTransition: .push(with: .right, duration: 0.5))
            } else {
                touchOnRestoreBtn(ifLocation: location)
                touchOnBuyBtn(ifLocation: location)
                touchOnProduct(ifLocation: location)
                
                checkSub()
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
        
        p.rect = SKShapeNode(rect: CGRect(x: -105, y: -35, width: 210, height: 70), cornerRadius: 12)
        p.rect.zPosition = 2
        
        p.rect.fillColor = fillColor
        p.rect.strokeColor = strokeColor
        p.rect.lineWidth = 5
        
        p.lock = Sprite(imageNamed: "lock", size: .sizeOfNode(_sizeOfTexture: SKTexture(imageNamed: "Images/lock").size(), _sizeofNode: .withPercentScaled(roundByWidth: 5)), position: CGPoint(x: -85, y: 0), zPosition: 3)
        
        p.productImg = Sprite(imageNamed: "_snowman_" + name, size: .withPercentScaled(roundByWidth: 10), position: CGPoint(x: -40, y: 0), zPosition: 3)
        
        p.nameLbl.text = nameText
        p.nameLbl.position.x = 40
        
        p.endLbl.isHidden = true
        p.endLbl.position.x = 40
        p.endLbl.position.y = -20
        
        p.addChild(p.rect)
        p.addChild(p.lock)
        p.addChild(p.productImg)
        p.addChild(p.nameLbl)
        p.addChild(p.endLbl)
        
        addChild(p)
        products.append(p)
        
        if p.name == "1" {  // Free case
            p.rect.fillColor = #colorLiteral(red: 0.3086127767, green: 0.8896942382, blue: 1, alpha: 1)
            p.lock.isHidden = true
        }
    }
    
    func addBuyBtn() {
        buyBtn.size = .sizeOfNode(_sizeOfTexture: SKTexture(imageNamed: "Images/long_btn").size(), _sizeofNode: .withPercentScaled(roundByWidth: 30))
        buyBtn.position = .withPercent(50, y: 24)
        updateBuyState(_canBuy: canBuy)
        let text = Label(text: "Unlock", fontSize: 20, fontName: GameConfig.fontText, color: GameConfig.textColor3, position: .zero, zPosition: 2)
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
            if p.contains(pos) && p.name != "1" && !p.lock.isHidden {
                updateBuyState(_canBuy: true)
                p.rect.strokeColor = selectColor
                p.isSelect = true
                chooseProduct = true
            } else if p.contains(pos) && p.lock.isHidden {
                setMonsterSpr(m: Int(p.name ?? "1") ?? 1)
                p.rect.strokeColor = selectColor
                switch p.name {
                case "1":
                    backgroundSpr.texture = SKTexture(imageNamed: "Images/background1")
                    UserDefaults.standard.setValue(1, forKey: GameConfig.skin)
                case "3":
                    backgroundSpr.texture = SKTexture(imageNamed: "Images/background2")
                    UserDefaults.standard.setValue(2, forKey: GameConfig.skin)
                case "5":
                    backgroundSpr.texture = SKTexture(imageNamed: "Images/background3")
                    UserDefaults.standard.setValue(3, forKey: GameConfig.skin)
                case "7":
                    backgroundSpr.texture = SKTexture(imageNamed: "Images/background4")
                    UserDefaults.standard.setValue(4, forKey: GameConfig.skin)
                default:
                    break
                }
                
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
        case "3":
            IAPManager.shared.purchase(product: .sub1) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateMonster(m: 3)
                }
            }
        case "5":
            IAPManager.shared.purchase(product: .sub2) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateMonster(m: 5)
                }
            }
        case "7":
            IAPManager.shared.purchase(product: .sub3) { [weak self] count in
                DispatchQueue.main.async() {
                    self?.updateMonster(m: 7)
                }
            }
        default:
            break
        }
    }
    
    func setMonsterSpr(m : Int) {
        UserDefaults.standard.setValue(m, forKey: GameConfig.monsterType)
        monsterSpr.texture = SKTexture(imageNamed: "Images/_snowman_\(m)")
    }
    
    func updateMonster(m: Int) {
        setMonsterSpr(m: m)
        let expiryDate1 = getExpiryDate(i: 1)
        let expiryDate2 = getExpiryDate(i: 2)
        let expiryDate3 = getExpiryDate(i: 3)
        var sub = GameConfig.Sub(expiryDate1: Date(timeIntervalSinceNow: 3*3600*24), expiryDate2: expiryDate2, expiryDate3: expiryDate3)
        backgroundSpr.texture = SKTexture(imageNamed: "Images/background2")
        UserDefaults.standard.setValue(2, forKey: GameConfig.skin)
        if m == 5 {
            sub = GameConfig.Sub(expiryDate1: expiryDate1, expiryDate2: Date(timeIntervalSinceNow: 30*3600*24), expiryDate3: expiryDate3)
            backgroundSpr.texture = SKTexture(imageNamed: "Images/background3")
            UserDefaults.standard.setValue(3, forKey: GameConfig.skin)
        } else if m == 7 {
            sub = GameConfig.Sub(expiryDate1: expiryDate1, expiryDate2: expiryDate2, expiryDate3: Date(timeIntervalSinceNow: 30*3600*24))
            backgroundSpr.texture = SKTexture(imageNamed: "Images/background4")
            UserDefaults.standard.setValue(4, forKey: GameConfig.skin)
        }
        UserDefaults.standard.setValue(sub.expiryDate1, forKey: GameConfig.sub1)
        UserDefaults.standard.setValue(sub.expiryDate2, forKey: GameConfig.sub2)
        UserDefaults.standard.setValue(sub.expiryDate3, forKey: GameConfig.sub3)
        KeyChain.save(key: GameConfig.subKey, data: Data(value: sub))
        checkSub()
    }
    
    func checkSub() {
        var haveSub = false
        for p in products {
            if p.name == "3" {
                if getExpiryDate(i: 1) > Date() {
                    p.lock.isHidden = true
                    p.endLbl.text = "End: " + formatterDate(date: getExpiryDate(i: 1))
                    haveSub = true
                } else {
                    p.lock.isHidden = false
                }
                p.endLbl.isHidden = !p.lock.isHidden
                
            }
            if p.name == "5" {
                if getExpiryDate(i: 2) > Date() {
                    p.lock.isHidden = true
                    p.endLbl.text = "End: " + formatterDate(date: getExpiryDate(i: 2))
                    haveSub = true
                } else {
                    p.lock.isHidden = false
                }
                p.endLbl.isHidden = !p.lock.isHidden
            }
            if p.name == "7" {
                if getExpiryDate(i: 3) > Date() {
                    p.lock.isHidden = true
                    p.endLbl.text = "End: " + formatterDate(date: getExpiryDate(i: 3))
                    haveSub = true
                } else {
                    p.lock.isHidden = false
                }
                p.endLbl.isHidden = !p.lock.isHidden
            }
        }
        if !haveSub {
            setMonsterSpr(m: 1)
        }
    }
    
    func getExpiryDate(i:Int) -> Date {
        if i == 1 {
            if (UserDefaults.standard.object(forKey: GameConfig.sub1) != nil) {
                return UserDefaults.standard.object(forKey: GameConfig.sub1) as! Date
            }
        } else if i == 2 {
            if (UserDefaults.standard.object(forKey: GameConfig.sub2) != nil) {
                return UserDefaults.standard.object(forKey: GameConfig.sub2) as! Date
            }
        }
        if (UserDefaults.standard.object(forKey: GameConfig.sub3) != nil) {
            return UserDefaults.standard.object(forKey: GameConfig.sub3) as! Date
        }
        return Date(timeIntervalSince1970: 0)
    }
    
    func formatterDate(date: Date) -> String {
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter.string(from: date)
    }
}
