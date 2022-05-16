//
//  GameLayer.swift
//  GOALKR
//
//  Created by Admin on 7/31/20.
//  Copyright © 2020 ORI GAME. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func onSwipe(endTouchPos: CGPoint, startTouchPos: CGPoint) {
        if startTouchPos != CGPoint.zero && (sqrt(pow(endTouchPos.x - startTouchPos.x,2)+pow(endTouchPos.y - startTouchPos.y,2)) > self.size.width*0.1) {
            Sounds.sharedInstance().playSound(soundName: "Sounds/swipe.mp3")
            let cos1: CGFloat = (endTouchPos.x - startTouchPos.x)/(sqrt(
                pow( endTouchPos.x-startTouchPos.x, 2) + pow(endTouchPos.y-startTouchPos.y,2) )
            )
            let sin1: CGFloat = (endTouchPos.y - startTouchPos.y)/(sqrt(
                pow( endTouchPos.x-startTouchPos.x, 2) + pow(endTouchPos.y-startTouchPos.y,2) )
            )
            if !isProcessing {
                if cos1 > sqrt(2)/2 {
                    moveRight()
                } else if cos1 < -1 * sqrt(2)/2 {
                    moveLeft()
                } else if sin1 > sqrt(2)/2 {
                    moveUp()
                } else if sin1 < -1 * sqrt(2)/2 {
                    moveDown()
                }
            }
        }
    }
    
    func passLevel(){
        if level != 15 {
            UserDefaults.standard.set(level+1 , forKey: "level")
            if level + 1 > UserDefaults.standard.integer(forKey: "maxLevel"){
                UserDefaults.standard.set(level+1 , forKey: "maxLevel")
            }
            Sounds.sharedInstance().playSound(soundName: "Sounds/sound_score.mp3")
            self.changeSceneTo(scene: GameScene(size: self.size), withTransition: .push(with: .left, duration: 0.5))
        }
    }
    
    func makeUserCanSwipe(maxTileCanMove: Int) {
        if maxTileCanMove > 0 {
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: TimeInterval(timeMovePerTile*CGFloat(maxTileCanMove))),
                SKAction.run {
                    self.isProcessing = false
                    self.maxTileCanMove = 0
                }
            ]))
        }
    }
    
    func moveRight() {
        for row in 0...nRow-1 {
            for col in (0...nCol-1).reversed() {
                if tileArr[row][col].canMove && col != nCol-1 {
                    moveRightOn(row: row, col: col)
                }
            }
        }
        makeUserCanSwipe(maxTileCanMove: maxTileCanMove)
    }
    
    func moveRightOn(row: Int, col: Int) {
        var maxColCanMove = col
        while maxColCanMove < nCol-1 {
            if tileArr[row][col].havePlayer && tileArr[row][maxColCanMove+1].haveWolf {
                maxColCanMove += 1
            } else if tileArr[row][col].haveWolf && tileArr[row][maxColCanMove+1].havePlayer {
                maxColCanMove += 1
            } else if tileArr[row][maxColCanMove+1].canMove == false && tileArr[row][maxColCanMove+1].name != objectType.wall.rawValue {
                maxColCanMove += 1
            } else {
                break
            }
        }
        if maxColCanMove != col {
            if maxColCanMove-col > maxTileCanMove {
                maxTileCanMove = maxColCanMove-col
            }
            tileArr[row][col].canMove = false
            tileArr[row][maxColCanMove].canMove = true
            isProcessing = true
            
            if tileArr[row][col].havePlayer {
                tileArr[row][col].havePlayer = false
                tileArr[row][maxColCanMove].havePlayer = true
                player.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[row][maxColCanMove], duration: TimeInterval(timeMovePerTile*CGFloat(maxColCanMove-col))),
                ]))
            } else if tileArr[row][col].haveWolf {
                tileArr[row][col].haveWolf = false
                tileArr[row][maxColCanMove].haveWolf = true
                tileArr[row][col].wolf.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[row][maxColCanMove], duration: TimeInterval(timeMovePerTile*CGFloat(maxColCanMove-col))),
                ]))
                tileArr[row][maxColCanMove].wolf = tileArr[row][col].wolf
            }
        }
    }
    
    func moveLeft() {
        for row in 0...nRow-1 {
            for col in 0...nCol-1 {
                if tileArr[row][col].canMove && col != 0 {
                    moveLeftOn(row: row, col: col)
                }
            }
        }
        
        makeUserCanSwipe(maxTileCanMove: maxTileCanMove)
    }
    
    func moveLeftOn(row: Int, col: Int) {
        var minColCanMove = col
        while minColCanMove > 0 {
            if tileArr[row][col].havePlayer && tileArr[row][minColCanMove-1].haveWolf {
                minColCanMove -= 1
            } else if tileArr[row][col].haveWolf && tileArr[row][minColCanMove-1].havePlayer {
                minColCanMove -= 1
            } else if !tileArr[row][minColCanMove-1].canMove && tileArr[row][minColCanMove-1].name != objectType.wall.rawValue {
                minColCanMove -= 1
            } else {
                break
            }
        }
        if minColCanMove != col {
            if col-minColCanMove > maxTileCanMove {
                maxTileCanMove = col-minColCanMove
            }
            tileArr[row][col].canMove = false
            tileArr[row][minColCanMove].canMove = true
            isProcessing = true
            if tileArr[row][col].havePlayer {
                tileArr[row][col].havePlayer = false
                tileArr[row][minColCanMove].havePlayer = true
                player.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[row][minColCanMove], duration: TimeInterval(timeMovePerTile*CGFloat(col-minColCanMove))),
                ]))
            } else if tileArr[row][col].haveWolf {
                tileArr[row][col].haveWolf = false
                tileArr[row][minColCanMove].haveWolf = true
                tileArr[row][col].wolf.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[row][minColCanMove], duration: TimeInterval(timeMovePerTile*CGFloat(col-minColCanMove))),
                ]))
                tileArr[row][minColCanMove].wolf = tileArr[row][col].wolf
            }
        }
    }
    
    func moveUp() {
        for col in 0...nCol-1 {
            for row in (0...nRow-1).reversed() {
                if tileArr[row][col].canMove && row != nRow-1 {
                    moveUpOn(row: row, col: col)
                }
            }
        }
        makeUserCanSwipe(maxTileCanMove: maxTileCanMove)
    }
    
    func moveUpOn(row: Int, col: Int) {
        var maxRowCanMove = row
        while maxRowCanMove < nRow-1 {
            if tileArr[row][col].havePlayer && tileArr[maxRowCanMove+1][col].haveWolf {
                maxRowCanMove += 1
            } else if tileArr[row][col].haveWolf && tileArr[maxRowCanMove+1][col].havePlayer {
                maxRowCanMove += 1
            } else if !tileArr[maxRowCanMove+1][col].canMove && tileArr[maxRowCanMove+1][col].name != objectType.wall.rawValue {
                maxRowCanMove += 1
            } else {
                break
            }
        }
        if maxRowCanMove != row {
            if maxRowCanMove-row > maxTileCanMove {
                maxTileCanMove = maxRowCanMove-row
            }
            tileArr[row][col].canMove = false
            tileArr[maxRowCanMove][col].canMove = true
            isProcessing = true
            if tileArr[row][col].havePlayer {
                tileArr[row][col].havePlayer = false
                tileArr[maxRowCanMove][col].havePlayer = true
                player.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[maxRowCanMove][col], duration: TimeInterval(timeMovePerTile*CGFloat(maxRowCanMove-row))),
                ]))
            } else if tileArr[row][col].haveWolf {
                tileArr[row][col].haveWolf = false
                tileArr[maxRowCanMove][col].haveWolf = true
                tileArr[row][col].wolf.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[maxRowCanMove][col], duration: TimeInterval(timeMovePerTile*CGFloat(maxRowCanMove-row))),
                ]))
                tileArr[maxRowCanMove][col].wolf = tileArr[row][col].wolf
            }
        }
    }
    
    func moveDown() {
        for col in 0...nCol-1 {
            for row in 0...nRow-1 {
                if tileArr[row][col].canMove && row != 0 {
                    moveDownOn(row: row, col: col)
                }
            }
        }
        makeUserCanSwipe(maxTileCanMove: maxTileCanMove)
    }
    
    func moveDownOn(row: Int, col: Int) {
        var minRowCanMove = row
        while minRowCanMove > 0 {
            if tileArr[row][col].havePlayer && tileArr[minRowCanMove-1][col].haveWolf {
                minRowCanMove -= 1
            } else if tileArr[row][col].haveWolf && tileArr[minRowCanMove-1][col].havePlayer {
                minRowCanMove -= 1
            } else if !tileArr[minRowCanMove-1][col].canMove && tileArr[minRowCanMove-1][col].name != objectType.wall.rawValue {
                minRowCanMove -= 1
            } else {
                break
            }
        }
        if minRowCanMove != row {
            if row-minRowCanMove > maxTileCanMove {
                maxTileCanMove = row-minRowCanMove
            }
            tileArr[row][col].canMove = false
            tileArr[minRowCanMove][col].canMove = true
            isProcessing = true
            if tileArr[row][col].havePlayer {
                tileArr[row][col].havePlayer = false
                tileArr[minRowCanMove][col].havePlayer = true
                player.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[minRowCanMove][col], duration: TimeInterval(timeMovePerTile*CGFloat(row-minRowCanMove))),
                ]))
            } else if tileArr[row][col].haveWolf {
                tileArr[row][col].haveWolf = false
                tileArr[minRowCanMove][col].haveWolf = true
                tileArr[row][col].wolf.run(SKAction.sequence([
                    SKAction.move(to: posBallArr[minRowCanMove][col], duration: TimeInterval(timeMovePerTile*CGFloat(row-minRowCanMove))),
                ]))
                tileArr[minRowCanMove][col].wolf = tileArr[row][col].wolf
            }
        }
    }
    
    func updateScore( value:Int, position:CGPoint) {
        updateProgressX(value: 0.15)
        score += value
        if score == targetScore {
            for h in homes {
                h.texture = SKTexture(imageNamed: "Images/_door_open")
                h.size = .sizeOfNode(_sizeOfTexture: SKTexture(imageNamed: "Images/_door_open").size(), _sizeofNode: CGSize(width: dBall*0.9, height: dBall*0.9))
                h.alpha = 1
                h.run(SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.2),SKAction.scale(to: 1, duration: 0.2)]))
            }
        }
        
        scoreLbl.changeTextWithAnimationScaled(withText: "Score: \(score) / \(targetScore)")
        
        if (score>best) {
            UserDefaults.standard.set(score, forKey: GameConfig.bestScore)
        }
        
        
        UserDefaults.standard.set(score, forKey: GameConfig.currentScore)
        Sounds.sharedInstance().playSound(soundName: "Sounds/sound_score.mp3")
        let add_oneLbl:Label
        let addLblPos:CGPoint = CGPoint(x: position.x+40, y: position.y+40)
        add_oneLbl = Label(text: "+\(value)", fontSize: 35, fontName: GameConfig.fontText, color: UIColor.red, position: addLblPos, zPosition: 5)

        add_oneLbl.run(SKAction.sequence([SKAction.scale(by: 1.4, duration: 0.5),
                                          SKAction.removeFromParent()
        ]))
        addChild(add_oneLbl)
        
        if let ex = SKEmitterNode(fileNamed: "Explode_4.sks") {
            ex.particleColor = .yellow
            ex.position = position
            addChild(ex)
        }
    }
    
    func touchOnMoretimeBtn(ifLocation pos: CGPoint) {
        if moretimeBtn.contains(pos) {
            let time = UserDefaults.standard.integer(forKey: GameConfig.time)
            if  time > 0 {
                updateProgressX(value: 0.2)
                let newTime = time-1
                moretimeBtn.updateNumber(n: newTime)
                UserDefaults.standard.setValue(newTime, forKey: GameConfig.time)
                KeyChain.save(key: GameConfig.timeKey, data: Data(value: newTime))
            }
        }
    }
    
}
