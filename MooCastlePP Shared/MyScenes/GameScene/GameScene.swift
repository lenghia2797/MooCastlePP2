//
//  GameScene.swift
//  SPEEDBOAT
//
//  Created by Mr. Joker on 8/13/19.
//  Copyright © 2019 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit
class Ball: Sprite {
    override init() {
        super.init()
    }
    var xId: Int = 0
    var yId: Int = 0
    
    init(img: String, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(imageNamed: img, size: size, position: position, zPosition: zPosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Tile: Sprite {
    override init() {
        super.init()
    }
    var xId: Int = 0
    var yId: Int = 0
    var canMove: Bool = false
    var haveCake: Bool = false
    var haveLake: Bool = false
    var haveWolf: Bool = false
    var havePlayer: Bool = false
    
    var wolf: Sprite = Sprite(imageNamed: "wolf.png", size: CGSize.zero, position: CGPoint.zero, zPosition: 2.5)
    var lock: Sprite = Sprite(imageNamed: "lock_sqr.png", size: CGSize.zero, position: CGPoint.zero, zPosition: 3.5)
    var isLock: Bool = false
    init(img: String, size: CGSize, position: CGPoint, zPosition: CGFloat) {
        super.init(imageNamed: img, size: size, position: position, zPosition: zPosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameScene : Scene, SKPhysicsContactDelegate {
    
    var backgrounds = [Sprite()]
        
    var gameEnd:Bool = false
    var level:Int = 0
    let toastLbl = Label(text: "Level: ", fontSize: 35, fontName: GameConfig.fontText, color: GameConfig.textColor, position: CGPoint.zero, zPosition: 7)
    let levelLbl = Label(text: "Level: 1", fontSize: 35, fontName: GameConfig.fontText, color: GameConfig.textColor, position: CGPoint.withPercent(50, y: 92), zPosition: 7)
    enum physicDefine:UInt32 {
        case player = 1
        case cake = 2
        case wolf = 4
        case lake = 8
        case home = 16
        
    }
    // File
    var nCol: Int = 0
    var nRow: Int = 0
    var nTypeBall: Int = 0
    var dBall:CGFloat = 0
    var posBallArr = Array(repeating: Array(repeating: CGPoint(x: 0, y: 0), count: 100), count: 100)
    var tileArr = [[Tile()]]
    var targetScore = 0
    
    // GameSetup
    var nCake = 0
    var player: Ball = Ball(img: "ball_1.png", size: CGSize.zero, position: CGPoint.zero, zPosition: 3)
    
    var cakes = [Sprite()]
    var homes = [Sprite()]
    
    var startTouchPos: CGPoint = CGPoint.zero
    var isProcessing: Bool = false
    var timeMovePerTile: CGFloat = 0
    var maxTileCanMove: Int = 0
    
    var progressBar = IMProgressBar(emptyImageName: "spr_progress_bar",filledImageName: "spr_progress_bar_level")
    var progressX: CGFloat = 1
    var progressBarDec: CGFloat = 0
    
    let moretimeBtn = MoretimeBtn(normalName: "_moretime", size: .withPercentScaled(roundByWidth: 8), position: .zero, zPosition: 3)
    
    let monsterType:Int = UserDefaults.standard.integer(forKey: GameConfig.monsterType)
    
    enum objectType: String {
        case wall = "0"
        case empty = "1"
        case player = "2"
        case coin = "3"
        case hole = "4"
        case home = "5"
        case fire = "6"
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        gameSetup()
        
//        ShopSubScene.shared.checkSub()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateProgressBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            startTouchPos = location
            
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
            soundBtn.changeSwitchState(ifInLocation: location)
            if backBtn.contains(location) {
                self.changeSceneTo(scene: LevelScene(size: self.size), withTransition: .push(with: .right, duration: 0.5))
            } 
            touchOnMoretimeBtn(ifLocation: location)
            onSwipe(endTouchPos: location, startTouchPos: startTouchPos)
        }
        soundBtn.run(SKAction.scale(to: 1.0, duration: 0.025))
        touchUpAllButtons()
    }
    
    func didBegin(_ contact : SKPhysicsContact) {
        let contactMark = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if !gameEnd {
            
            switch contactMark {
            case physicDefine.player.rawValue | physicDefine.cake.rawValue:
                for cake in cakes {
                    if cake == secondBody.node {
                        updateScore(value: 1, position: cake.position )
                        cake.physicsBody = nil
                        cake.removeFromParent()
                    }
                }
            case physicDefine.wolf.rawValue | physicDefine.cake.rawValue:
                for cake in cakes {
                    if cake == firstBody.node {
                        cake.physicsBody = nil
                        cake.removeFromParent()
                    }
                }
                gameOver()
            case physicDefine.player.rawValue | physicDefine.lake.rawValue:
                
                addWaterEffect(_pos: secondBody.node?.position ?? CGPoint.zero)
                
                self.player.physicsBody = nil
                self.isProcessing = true
                self.player.removeFromParent()
                
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 1.2),
                    SKAction.run {
                        
                        self.gameOver()
                    }
                ]))
                Sounds.sharedInstance().playSound(soundName: "Sounds/splashing")
            case physicDefine.wolf.rawValue | physicDefine.player.rawValue:
                self.run(SKAction.sequence([
                    SKAction.wait(forDuration: 0.1),
                    SKAction.run {
                        self.player.isHidden = true
                    }
                ]))
                gameOver()
            case physicDefine.wolf.rawValue | physicDefine.lake.rawValue:
                for i in 0...nRow-1 {
                    for j in 0...nCol-1 {
                        if firstBody.node == tileArr[i][j].wolf {
                            addWaterEffect(_pos: secondBody.node?.position ?? CGPoint.zero)
                            self.tileArr[i][j].haveWolf = false
                            self.tileArr[i][j].canMove = false
                            self.tileArr[i][j].wolf.physicsBody = nil
                            self.isProcessing = false
                            self.tileArr[i][j].wolf.removeFromParent()
                            
                            break
                        }
                    }
                }
                Sounds.sharedInstance().playSound(soundName: "Sounds/splashing")
            case physicDefine.wolf.rawValue | physicDefine.home.rawValue:
                gameOver()
            case physicDefine.player.rawValue | physicDefine.home.rawValue:
                if score>=targetScore {
                    gameEnd = true
                    passLevel()
                }
            default:
                return
            }
        }
    }
    
}
