//
//  ControlLayer.swift
//  GOALKR
//
//  Created by Admin on 7/31/20.
//  Copyright © 2020 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    func gameSetup() {
        setInterFace()
        setArr()
        
        readDataFunc()
        createPosBallArray()
        
        addProgressbar()
        let t:CGFloat = 16
        progressBarDec = 0.01929/(t + CGFloat(level)*1.5 )
        
        addMoretimeBtn()
        
        addSquare()
        addPlayer()
        addCake()
        addHome()
        addLake()
        timeMovePerTile = 0.15
    }
    
    func setInterFace(){
        soundBtn.position = CGPoint.withPercent(88, y: 90)
        backBtn.position = CGPoint.withPercent(12, y: 90)
        scoreLbl.position = CGPoint.withPercent(50, y: 88)
        UserDefaults.standard.set(0, forKey: GameConfig.currentScore)
        setScore()
        addChild([soundBtn, backgroundSpr, backBtn, scoreLbl])
    }
    
    func setArr() {
        tileArr = Array(repeating: Array(repeating: Tile(img: "soccer1.png", size: CGSize.zero, position: CGPoint.zero, zPosition: 2), count: 100), count: 100)
    }
    
    func addMoretimeBtn() {
        moretimeBtn.position = .withPercent(75, y: 82)
        addChild(moretimeBtn)
        moretimeBtn.updateNumber(n: UserDefaults.standard.integer(forKey: GameConfig.time))
    }
    
    func addPlayer() {
        for i in 0...nRow-1 {
            for j in 0...nCol-1 {
                if tileArr[i][j].name == objectType.player.rawValue {
                    player = Ball(img: "_snowman_\(Int.random(in: monsterType ... monsterType + 1)).png", size: CGSize(width: dBall*0.7, height: dBall*0.7), position: tileArr[i][j].position, zPosition: 3)
                    player.xId = i
                    player.yId = j
                    tileArr[i][j].canMove = true
                    tileArr[i][j].havePlayer = true
                    addChild(player)
                    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
                    player.physicsBody?.categoryBitMask = physicDefine.player.rawValue
                    player.physicsBody?.isDynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.contactTestBitMask = physicDefine.cake.rawValue | physicDefine.wolf.rawValue | physicDefine.lake.rawValue | physicDefine.home.rawValue
                    player.physicsBody?.collisionBitMask = physicDefine.cake.rawValue | physicDefine.lake.rawValue
                    return
                }
            }
        }
    }
    
    func addHome() {
        for i in 0...nRow-1 {
            for j in 0...nCol-1 {
                if tileArr[i][j].name == objectType.home.rawValue {
                    let home = Sprite(imageNamed: "_door_close.png", size: .sizeOfNode(_sizeOfTexture: SKTexture(imageNamed: "Images/_door_close").size(), _sizeofNode: CGSize(width: dBall*0.9, height: dBall*0.9)), position: tileArr[i][j].position, zPosition: 2.5)
                    home.alpha = 0.7
                    addChild(home)
                    home.physicsBody = SKPhysicsBody(rectangleOf: home.size)
                    home.physicsBody?.categoryBitMask = physicDefine.home.rawValue
                    home.physicsBody?.isDynamic = false
                    home.physicsBody?.affectedByGravity = false
                    home.physicsBody?.contactTestBitMask = physicDefine.player.rawValue | physicDefine.wolf.rawValue
                    home.physicsBody?.collisionBitMask = physicDefine.player.rawValue | physicDefine.wolf.rawValue
                    
                    homes.append(home)
                    
                }
            }
        }
    }
    
    func addCake() {
        for i in 0...nRow-1 {
            for j in 0...nCol-1 {
                if tileArr[i][j].name == objectType.coin.rawValue {
                    let cake = Sprite(imageNamed: "_coin_1_1.png", size: CGSize(width: dBall*0.6, height: dBall*0.6), position: tileArr[i][j].position, zPosition: 2.5)
                    
                    var frames = [SKTexture()]
                    frames.removeAll()
                    for i in 1...10 {
                        frames.append(SKTexture(imageNamed: "Images/_coin_1_\(i)"))
                    }
                    cake.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: false)))
                    
                    addChild(cake)
                    cake.physicsBody = SKPhysicsBody(rectangleOf: cake.size)
                    cake.physicsBody?.categoryBitMask = physicDefine.cake.rawValue
                    cake.physicsBody?.isDynamic = true
                    cake.physicsBody?.affectedByGravity = false
                    cake.physicsBody?.contactTestBitMask = physicDefine.player.rawValue | physicDefine.wolf.rawValue
                    cake.physicsBody?.collisionBitMask = physicDefine.player.rawValue | physicDefine.wolf.rawValue
                    
                    cakes.append(cake)
                    targetScore += 1
                    scoreLbl.text = "Score : \(score) / \(targetScore)"
                }
            }
        }
    }
    
    func addLake() {
        for i in 0...nRow-1 {
            for j in 0...nCol-1 {
                if tileArr[i][j].name == objectType.hole.rawValue {
                    let v = Sprite(imageNamed: "_vortex", size: CGSize(width: dBall*0.6, height: dBall*0.6), position: tileArr[i][j].position, zPosition: 2.4)
                    addChild(v)
                    v.run(.repeatForever(.rotate(byAngle: .pi, duration: 1)))
                    
                    let lake = Sprite(imageNamed: "_vortex_1.png", size: CGSize(width: dBall, height: dBall), position: tileArr[i][j].position, zPosition: 2.5)
                    
                    var frames = [SKTexture()]
                    frames.removeAll()
                    for i in 1...9 {
                        frames.append(SKTexture(imageNamed: "Images/_vortex_\(i)"))
                    }
                    lake.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: false)))
                    
                    addChild(lake)
                    lake.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dBall*0.1, height: dBall*0.1))
                    lake.physicsBody?.categoryBitMask = physicDefine.lake.rawValue
                    lake.physicsBody?.isDynamic = false
                    lake.physicsBody?.affectedByGravity = false
                    lake.physicsBody?.contactTestBitMask = physicDefine.player.rawValue | physicDefine.wolf.rawValue
                    lake.physicsBody?.collisionBitMask = physicDefine.player.rawValue | physicDefine.wolf.rawValue
                    
                }
            }
        }
    }
    
    func addSquare() {
        for i in 0...nRow-1 {
            for j in 0...nCol-1 {
                
                tileArr[i][j].size = CGSize(width: dBall, height: dBall)
                tileArr[i][j].position = posBallArr[i][j]
//                addChild(tileArr[i][j])
                if tileArr[i][j].name == objectType.fire.rawValue {
                    
                    let typeFire = Int.random(in: 0...1)
                    tileArr[i][j].wolf = Sprite(imageNamed: "_fire_\(typeFire)_1.png", size: CGSize(width: dBall, height: dBall), position: tileArr[i][j].position, zPosition: 2.5)
                    
                    var frames = [SKTexture()]
                    frames.removeAll()
                    for i in 1...8 {
                        frames.append(SKTexture(imageNamed: "Images/_fire_\(typeFire)_\(i)"))
                    }
                    tileArr[i][j].wolf.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.1, resize: false, restore: false)))
                    
                    addChild(tileArr[i][j].wolf)
                    tileArr[i][j].canMove = true
                    tileArr[i][j].haveWolf = true
                    tileArr[i][j].wolf.physicsBody = SKPhysicsBody(rectangleOf: tileArr[i][j].wolf.size)
                    tileArr[i][j].wolf.physicsBody?.categoryBitMask = physicDefine.wolf.rawValue
                    tileArr[i][j].wolf.physicsBody?.isDynamic = true
                    tileArr[i][j].wolf.physicsBody?.affectedByGravity = false
                    tileArr[i][j].wolf.physicsBody?.contactTestBitMask = physicDefine.player.rawValue | physicDefine.cake.rawValue | physicDefine.lake.rawValue
                    tileArr[i][j].wolf.physicsBody?.collisionBitMask = physicDefine.player.rawValue | physicDefine.cake.rawValue | physicDefine.lake.rawValue
                    
                } else if tileArr[i][j].name == objectType.wall.rawValue {
                    let tree = Sprite(imageNamed: "_ice_\(Int.random(in: skin ... skin+1)).png", size: CGSize(width: dBall*0.8, height: dBall*0.8), position: tileArr[i][j].position, zPosition: 2.5)
                    addChild(tree)
                }
            }
        }
    }
    
    func addWaterEffect(_pos: CGPoint) {
        let water = Sprite(imageNamed: "_water_1.png", size: CGSize(width: dBall*0.9, height: dBall*0.9), position: _pos , zPosition: 4)
        
        var frames = [SKTexture()]
        frames.removeAll()
        for i in 1...7 {
            frames.append(SKTexture(imageNamed: "Images/_water_\(i).png"))
        }
        water.run(SKAction.sequence([SKAction.animate(with: frames, timePerFrame: 0.15, resize: false, restore: false), SKAction.hide()]))
        
        addChild(water)
    }
    
    func createPosBallArray(){
        dBall = self.size.width/(CGFloat(nCol)) //+0.05)
        var d:CGFloat = CGFloat(self.size.height*0.25)
        if self.size.height < 800 { // 5.5
            d = self.size.height*0.13
        }
        var posX:CGFloat
        var posY:CGFloat
        for i in 0...20 {
            for j in 0...20 {
                posX = (CGFloat(j)+0.5)*dBall
                posY = d +  CGFloat((CGFloat(i)+0.5)*dBall)
                posBallArr[i][j] = CGPoint(x: posX, y: posY)
            }
        }
    }
    
    func showToast(_ pos: CGPoint) {
        toastLbl.position = pos
        toastLbl.removeAllActions()
        toastLbl.run(SKAction.sequence([SKAction.unhide(), SKAction.moveBy(x: 0, y: 100, duration: 1.0), SKAction.hide()]))
    }
    
    func gameOver() {
        gameEnd = true
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.2),
            SKAction.run {
                self.changeSceneTo(scene: EndScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
            },
            
        ]))
        
    }
    
    /* ProgressBar fuction */
    
    func addProgressbar() {
        addChild(progressBar)
        progressBar.setScale(0.22)
        progressBar.position = .withPercent(50, y: 82)
        
        progressBar.setXProgress(xProgress: progressX)
        
    }
    
    func updateProgressBar() {
        if progressX > 0 {
            progressX -= progressBarDec
            progressBar.setXProgress(xProgress: progressX)
        } else {
            changeSceneTo(scene: EndScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
        }
    }
    
    func updateProgressX(value: CGFloat) {
        progressX += value
        if progressX > 1.05 {
            progressX = 1.05
        }
        
        progressBar.setXProgress(xProgress: progressX)
    }
    
    /* End ProgressBar*/
}
