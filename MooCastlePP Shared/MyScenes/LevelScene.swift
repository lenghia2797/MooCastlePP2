//
//  LevelScene.swift
//  IQBALL
//
//  Created by Admin on 8/5/20.
//  Copyright © 2020 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

class LevelButton : Button {
    override init() {
        super.init()
        
    }
//    var nameLevel:Int = 0
    var isLock:Bool = true
    
    override init(normalName: String, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(normalName: normalName, size: size, position: position, zPosition: zPosition)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LevelScene : Scene {
    
    var levels = [LevelButton()]
    
    var posLevelArr = Array(repeating: Array(repeating: CGPoint.zero, count: 100), count: 100)
    
    var maxLevel = UserDefaults.standard.integer(forKey: "maxLevel")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backBtn.position = .withPercent(12, y: 90)
        addChild([soundBtn, backBtn, backgroundSpr])
        createLevel()
    }
    
    func createLevel() {
        let nRow = 5
        let nLevelInRow = 4
        for row in 0..<nRow {
            for col in 0..<nLevelInRow {
                
                let levelName = row*nLevelInRow + col + 1
                let level = LevelButton(normalName: "level_back.png", size: CGSize.withPercentScaled(roundByWidth: 10), position: positionOfLevelBtnVertical(_levelNameInt: levelName), zPosition: 2)
                let levelText = Label(text: "\(levelName)", fontSize: 20, fontName: GameConfig.fontText, color: .blue, position: CGPoint.zero, zPosition: 3)
                
                
                if UserDefaults.standard.integer(forKey: "maxLevel") == levelName {
                    levelText.color = .red
                }
                
                let lockSpr = Sprite(imageNamed: "lock.png", size: CGSize.withPercentScaled(roundByWidth: 4), position: level.position, zPosition: 3)
                level.name = String(levelName)
                addChild([level, lockSpr])
                level.addChild(levelText)
                levelText.isHidden = true
                if Int(level.name!) ?? 1 <= maxLevel {
                    lockSpr.isHidden = true
                    level.isLock = false
                    levelText.isHidden = false
                } else {
                    level.color = .gray
                    level.colorBlendFactor = 0.75
                }
                levels.append(level)
            }
        }
    }
    
    func addLevelBack() {
        for i in 1...5 {
            let levelBack = Sprite(imageNamed: "_level_back_bar.png", size: CGSize.withPercentScaledByWith(55, height: 55/2.39), position: CGPoint.zero, zPosition: 1)
            addChild(levelBack)
            switch i {
            case 1:
                levelBack.position = CGPoint.withPercent(35, y: 17.5)
                break
            case 2:
                levelBack.position = CGPoint.withPercent(65, y: 32.5)
                break
            case 3:
                levelBack.position = CGPoint.withPercent(35, y: 47.5)
                break
            case 4:
                levelBack.position = CGPoint.withPercent(65, y: 62.5)
                break
            
            default:
                levelBack.position = CGPoint.withPercent(35, y: 77.5)
            }
        }
        
    }
    
    func positionOfLevelBtnVertical(_levelNameInt : Int) -> CGPoint {
        switch _levelNameInt {
        case 1:
            return CGPoint.withPercent(15, y: 10)
        case 2:
            return CGPoint.withPercent(38.33, y: 10)
        case 3:
            return CGPoint.withPercent(60, y: 10)
        case 4:
            return CGPoint.withPercent(85, y: 10)
        case 5:
            return CGPoint.withPercent(15, y: 27.5)
        case 6:
            return CGPoint.withPercent(38.33, y: 27.5)
        case 7:
            return CGPoint.withPercent(61.67, y: 27.5)
        case 8:
            return CGPoint.withPercent(85, y: 27.5)
        case 9:
            return CGPoint.withPercent(15, y: 45)
        case 10:
            return CGPoint.withPercent(38.33, y: 45)
        case 11:
            return CGPoint.withPercent(61.67, y: 45)
        case 12:
            return CGPoint.withPercent(85, y: 45)
        case 13:
            return CGPoint.withPercent(15, y: 62.5)
        case 14:
            return CGPoint.withPercent(38.33, y: 62.5)
        case 15:
            return CGPoint.withPercent(61.67, y: 62.5)
        case 16:
            return CGPoint.withPercent(85, y: 62.5)
        case 17:
            return CGPoint.withPercent(15, y: 80)
        case 18:
            return CGPoint.withPercent(38.33, y: 80)
        case 19:
            return CGPoint.withPercent(61.67, y: 80)
        case 20:
            return CGPoint.withPercent(85, y: 80)
        default:
            return CGPoint.withPercent(10, y: 10)
        }
    }
    
    func createPosLevelArray(){
        var posX:CGFloat
        var posY:CGFloat
        let dSquare = self.frame.maxX/CGFloat(4)
        
        for i in 0...4 {
            for j in 0...2 {
                posX = CGFloat( ( CGFloat(j+1)) * dSquare)
                posY = CGFloat( ( CGFloat(5) - CGFloat(i) ) * dSquare )
                posLevelArr[i][j] = CGPoint(x: posX, y: posY + self.frame.maxY*0.08)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if soundBtn.contains(location) {
                soundBtn.run(SKAction.scale(to: 0.85, duration: 0.025))
            }
            touchDownButtons(atLocation: location)
            
            location0 = location
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if soundBtn.contains(location) {
                soundBtn.changeSwitchState()
            } else if backBtn.contains(location) || swipe(location: location) == 2 {
                self.changeSceneTo(scene: MenuScene(size: self.size), withTransition: .push(with: .right, duration: 0.5))
            } else {
                for level in levels {
                    if level.contains(location){
                        if !level.isLock {
                            UserDefaults.standard.set(level.name, forKey: "level")
                            self.changeSceneTo(scene: GameScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
                        }
                    }
                }
            }
        }
        homeBtn.run(SKAction.scale(to: 1.0, duration: 0.025))
        soundBtn.run(SKAction.scale(to: 1.0, duration: 0.025))
        touchUpAllButtons()
    }
        
    
}
