//
//  BaseScene.swift
//  
//
//  Created by  on 3/21/19.
//  Copyright © 2019 . All rights reserved.
//

import SpriteKit

class Scene : SKScene, ToggleButtonDelegate {
    
    var score: Int = 0
    var best: Int = 0
    
    var buttons = [Button]()
    
    var location0:CGPoint = .zero
    
    let backgroundSpr = Sprite.init(imageNamed: "background1.png", size: CGSize.withPercent(100, height: 100), position: VisibleRect.center(), zPosition: -1)
    
    let soundBtn = ToggleButton(imageOn: "music-on.png", size: CGSize.withPercentScaled(roundByWidth: 12), position: CGPoint.withPercent(88, y: 90), zPosition: GameConfig.zPosition.layer_5)
    
    let rankingBtn = Button(normalName: "ranking.png", size: CGSize.withPercentScaled(roundByWidth: 20), position: CGPoint.withPercent(35, y: 25), zPosition: GameConfig.zPosition.layer_5)
    
    let homeBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 12), position: CGPoint.withPercent(12, y: 90), zPosition: GameConfig.zPosition.layer_5)
    
    let backBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 12), position: CGPoint.withPercent(12, y: 50), zPosition: 3)
    
    let nextBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 12), position: CGPoint.withPercent(88, y: 50), zPosition: 3)
    
    let menuBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 12), position: CGPoint.withPercent(50, y: 15), zPosition: GameConfig.zPosition.layer_5)
    
    let rateBtn = Button(normalName: "rating.png", size: CGSize.withPercentScaled(roundByWidth: 20), position: CGPoint.withPercent(35, y: 25), zPosition: GameConfig.zPosition.layer_5)
    
    let playBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 18), position: CGPoint.withPercent(50, y: 60), zPosition: GameConfig.zPosition.layer_3)
    
    let replayBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 18), position: CGPoint.withPercent(50, y: 50), zPosition: GameConfig.zPosition.layer_3)

    let howToPlayBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 12), position: CGPoint.withPercent(50, y: 35), zPosition: 3)
    
    var scoreLbl = Label(text: "Score: 0", fontSize: 25, fontName: GameConfig.fontNumber, color: GameConfig.textColor, position: CGPoint.withPercent(50, y: 75), zPosition: 7)
    
    var bestLbl = Label(text: "0", fontSize: 25, fontName: GameConfig.fontNumber, color: GameConfig.textColor, position: CGPoint.withPercent(50, y: 68), zPosition: GameConfig.zPosition.layer_2)
    
    let shopBtn = Button(normalName: "empty_btn", size: CGSize.withPercentScaled(roundByWidth: 18), position: CGPoint.withPercent(50, y: 40), zPosition: GameConfig.zPosition.layer_3)
    
    let homeBtnContent = Sprite(imageNamed: "home", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 3)
    
    let shopBtnContent = Sprite(imageNamed: "shop", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 3)
    
    let backBtnContent = Sprite(imageNamed: "back", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 4)
    
    let nextBtnContent = Sprite(imageNamed: "back", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 4)
    
    let menuBtnContent = Sprite(imageNamed: "menu", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 3)
    
    let playBtnContent = Sprite(imageNamed: "play", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 3)
    
    let replayBtnContent = Sprite(imageNamed: "replay", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 3)
    
    let howtoplayBtnContent = Sprite(imageNamed: "howtoplay", size: CGSize.withPercentScaled(roundByWidth: 6), position: CGPoint.zero, zPosition: 3)
    
    let skin = UserDefaults.standard.integer(forKey: GameConfig.skin)
    override func didMove(to view: SKView) {
        soundBtn.setSwitchState(UserDefaults.standard.bool(forKey: SoundConfig.playSounds))
        soundBtn.delegate = self
        
        homeBtn.addChild(homeBtnContent)
        
        shopBtn.addChild(shopBtnContent)
        
        playBtn.addChild(playBtnContent)
        
        replayBtn.addChild(replayBtnContent)
        
        howToPlayBtn.addChild(howtoplayBtnContent)
        
        backBtn.addChild(backBtnContent)
        
        nextBtnContent.xScale = -1
        nextBtn.addChild(nextBtnContent)
        
        menuBtn.addChild(menuBtnContent)
        
        backgroundSpr.texture = SKTexture(imageNamed: "Images/background\(skin)")
    }
    
    func changeToggleButtonState(_ sender: ToggleButton) {
        Sounds.sharedInstance().changeSoundAndMusicState()
    }
    
    func addChild(_ button: Button) {
        buttons.append(button)
        super.addChild(button)
    }
    
    func addChild(_ nodes: [SKNode]) {
        for (_, value) in nodes.enumerated() {
            if value.isKind(of: Button.self) {
                addChild(value as! Button)
            }
            else {
                addChild(value)
            }
        }
    }
    
    func addChildScaleAnimation(_ nodes: [SKNode], duration: TimeInterval) {
        for (_, value) in nodes.enumerated() {
            if value.isKind(of: Button.self) {
                addChild(value as! Button)
            }
            else {
                addChild(value)
            }
            value.setScale(0)
            value.run(.scale(to: 1, duration: duration))
        }
    }
    
    /**
     We can call this func for change all buttons state on scene to simple.
     */
    func touchUpAllButtons() {
        
        for button in buttons { button.touchUp()}
    }
    
    func touchDownButtons(atLocation location: CGPoint) {
        
        for (_ ,button) in buttons.enumerated() {
            button.touchDown(ifInLocation: location)
        }
    }
    
    func changeSceneTo(scene : SKScene) {
        
        Sounds.sharedInstance().sceneForPlayingSounds = scene
        
        //Show new scene
        view?.presentScene(scene)
        
        //Clean old scene after show new
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(cleanOldScene), userInfo: nil, repeats: false)
    }
    
    func changeSceneTo(scene : SKScene, withTransition transition: SKTransition) {
        
        Sounds.sharedInstance().sceneForPlayingSounds = scene
        
        //Show new scene
        view?.presentScene(scene, transition: transition)
        
        //Clean old scene after show new
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(cleanOldScene), userInfo: nil, repeats: false)
    }
    
    func showLeaderboard() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showLeaderboard"), object: nil)
    }
    
    func getLeaderboard() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getLeaderboard"), object: nil)
    }
    
    func submitScore() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "submitScore"), object: nil)
    }
    
    func setSoundBtn(_ size:CGSize, _ position:CGPoint) {
        soundBtn.size = size
        soundBtn.position = position
    }
    
    func setRankingBtn(_ size:CGSize, _ position:CGPoint) {
        rankingBtn.size = size
        rankingBtn.position = position
    }
    
    func setHomeBtn(_ size:CGSize, _ position:CGPoint) {
        homeBtn.size = size
        homeBtn.position = position
    }
    
    func setScoreLbl(_ fontSize:CGFloat, _ color:UIColor, _ position:CGPoint) {
        scoreLbl.fontSize = fontSize
        scoreLbl.color = color
        scoreLbl.position = position
    }
    
    func setBestLbl(_ fontSize:CGFloat, _ color:UIColor, _ position:CGPoint) {
        bestLbl.fontSize = fontSize
        bestLbl.color = color
        bestLbl.position = position
    }
    
    func setScore() {
        score = UserDefaults.standard.integer(forKey: GameConfig.currentScore)
        best = UserDefaults.standard.integer(forKey: GameConfig.bestScore)
        
        scoreLbl.text = "Score: " + String(score)
        bestLbl.text = "Best Score: " + String(best)
    }
    
    
    
    /**
     This function helped to clean old scene from something nodes and actions
     */
    @objc func cleanOldScene() {
        removeAllChildren()
        removeAllActions()
        removeFromParent()
        print("GlobalScene: Old scene is been cleaned")
    }
    
    func swipe(location: CGPoint) -> Int {
        if location0 != CGPoint.zero && (sqrt(pow(location.x - location0.x,2)+pow(location.y - location0.y,2)) > self.size.width*0.1){
            let cos1: CGFloat = (location.x - location0.x)/(sqrt(
                pow( location.x-location0.x, 2) + pow(location.y-location0.y,2) )
            )
            if cos1 > sqrt(2)/2 {
                return 2
            } else if cos1 < -1 * sqrt(2)/2 {
                return 1
            }
        }
        return 0
    }
}
