//
//  GameViewController.swift
//  
//
//  Created by  on 3/21/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
         
        if !(UserDefaults.standard.bool(forKey: GameConfig.hasLaunchedOnce)) {
            //First launch
            UserDefaults.standard.set(true, forKey: GameConfig.hasLaunchedOnce)
            
            //Set stats
            UserDefaults.standard.set(true, forKey: SoundConfig.playSounds)
            UserDefaults.standard.set(true, forKey: SoundConfig.playMusic)

            UserDefaults.standard.set(0, forKey: GameConfig.currentScore)
            UserDefaults.standard.set(0, forKey: GameConfig.bestScore)
            UserDefaults.standard.set(1, forKey: GameConfig.time)
            UserDefaults.standard.set(1, forKey: "maxLevel")
            UserDefaults.standard.set(1, forKey: GameConfig.monsterType)
            UserDefaults.standard.set(1, forKey: GameConfig.skin)
            
            UserDefaults.standard.setValue(Date(timeIntervalSince1970: 0), forKey: GameConfig.sub1)
            UserDefaults.standard.setValue(Date(timeIntervalSince1970: 0), forKey: GameConfig.sub2)
            UserDefaults.standard.setValue(Date(timeIntervalSince1970: 0), forKey: GameConfig.sub3)
            
            UserDefaults.standard.set(false, forKey: GameConfig.neverRateAfterGame)
            
        }
        
        // create game view
        if let view = self.view as! SKView? {
            // load scene
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
            view.presentScene(scene)
            
//            view.showsPhysics = true
            
            // load observers
            createObserversToGameSceneController()
            
            authenticateLocalPlayer()
            
            Sounds.sharedInstance().playMusic(musicName: SoundConfig.musicGame)
            Sounds.sharedInstance().sceneForPlayingSounds = scene
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func createObserversToGameSceneController() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(rateUs), name: NSNotification.Name(rawValue: "rateUs"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rateUsAfterGame), name: NSNotification.Name(rawValue: "rateUsAfterGame"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLeaderboard), name: NSNotification.Name(rawValue: "showLeaderboard"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(submitScore), name: NSNotification.Name(rawValue: "submitScore"), object: nil)
        
    }
}
