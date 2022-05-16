//
//  GameCenterController.swift
//
//
//  Created by  on 4/8/19.
//  Copyright © 2019 . All rights reserved.
//

import GameKit

extension GameViewController {
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) { self.present(viewController!, animated: true, completion: nil)}
            else { print("GameCenter: Authenticate compleate")}
        }
    }
    
    @objc func submitScore() {
        let score = GKScore(leaderboardIdentifier: "leaderBoardID")
        score.value = Int64(UserDefaults.standard.integer(forKey: GameConfig.bestScore))
        
        GKScore.report([score], withCompletionHandler: { (error: Error?) -> Void in
            if error != nil { print(error!.localizedDescription)}
            else { print("GameCenter: Score submited")}
        })
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func showLeaderboard() {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        gcVC.leaderboardIdentifier = "leaderBoardID"
        present(gcVC, animated: true, completion: nil)
    }
}

class GameCenterController {
    static func showLeaderboard() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showLeaderboard"), object: nil)
    }
    
    static func getLeaderboard() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getLeaderboard"), object: nil)
    }
    
    static func submitScore() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "submitScore"), object: nil)
    }
}
