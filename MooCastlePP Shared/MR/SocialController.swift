//
//  RateController.swift
//
//
//  Created by  on 4/27/19.
//  Copyright © 2019 . All rights reserved.
//

import StoreKit

extension GameViewController {
    enum typeRateUsAlert {
        case automatically
        case manually
    }
    
    @objc func rateUsAfterGame() {
        if !UserDefaults.standard.bool(forKey: GameConfig.neverRateAfterGame) {
            callRateUsAlert(withType: .automatically)
        }
    }
    
    @objc func rateUs() {
        callRateUsAlert(withType: .manually)
    }
    
    fileprivate func callRateUsAlert(withType type: typeRateUsAlert) {
        switch type {
        case .automatically:
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: GameConfig.neverRateAfterGame)
            } else {
                let alert = UIAlertController(title: "Rate Us", message: "Thanks for playing", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Rate", style: UIAlertAction.Style.default, handler: { alertAction in
                    let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.openURL(settingsUrl)
                    
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertAction.Style.default, handler: { alertAction in
                    UserDefaults.standard.set(true, forKey: GameConfig.neverRateAfterGame)
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertAction.Style.default, handler: { alertAction in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        case .manually:
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
                let alert = UIAlertController(title: "Rate Us", message: "If you like this game rate it in AppStore", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { alertAction in
                    let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.openURL(settingsUrl)

                    UserDefaults.standard.set(true, forKey: GameConfig.neverRateAfterGame)
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { alertAction in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

class SocialController {
    static func rateUs() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "rateUs"), object: nil)
    }
    
    static func rateUsAfterGame() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "rateUsAfterGame"), object: nil)
    }
}
