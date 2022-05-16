//
//  GameConfig.swift
//  
//
//  Created by  on 4/8/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SpriteKit

struct GameConfig {
    static let currentScore = "CurrentScore"
    static let bestScore = "BestScore"
    static let level = "levelGame"
    static let mode = "modeGame"
    static let time = "time"
    static let monsterType = "monster"
    static let sub1 = "sub1"
    static let sub2 = "sub2"
    static let sub3 = "sub3"
    static let skin = "skin"
    
    static let hasLaunchedOnce = "HasLaunchedOnce"
    static let neverRateAfterGame =  "NeverRateAfterGame"
    
    static let fontText:String = "ICIELCADENA"
    static let fontNumber:String = "ICIELCADENA"
    
    static let textColor: UIColor = #colorLiteral(red: 1, green: 0.7477522605, blue: 0.2495796895, alpha: 1)
    static let textColor2: UIColor = #colorLiteral(red: 1, green: 0.5893152609, blue: 0.05658101376, alpha: 1)
    static let textColor3: UIColor = #colorLiteral(red: 0.534205229, green: 0.1725887673, blue: 1, alpha: 1)
    
    struct zPosition {
        static let layer_1:CGFloat = 0
        static let layer_2:CGFloat = 1
        static let layer_3:CGFloat = 2
        static let layer_4:CGFloat = 3
        static let layer_5:CGFloat = 4
    }
    
    static let timeKey = "timeKey"
    static let subKey = "subkey"
    
    static func restore() -> Bool {
        let timeData = KeyChain.load(key: GameConfig.timeKey)
        let subData = KeyChain.load(key: GameConfig.subKey)
        var flag = false
        if let time = timeData?.to(type: Int.self) {
            UserDefaults.standard.setValue(time, forKey: GameConfig.time)
            flag =  true
        } else {
            UserDefaults.standard.setValue(1, forKey: GameConfig.time)
        }
        
        if let sub = subData?.to(type: Sub.self) {
            print("sub = ", sub)
            UserDefaults.standard.setValue(sub.expiryDate1, forKey: GameConfig.sub1)
            UserDefaults.standard.setValue(sub.expiryDate2, forKey: GameConfig.sub2)
            UserDefaults.standard.setValue(sub.expiryDate3, forKey: GameConfig.sub3)
            flag = true
        } else {
            print("Wrong --- ")
            let sub0 = Sub(expiryDate1: Date(timeIntervalSinceNow: 0), expiryDate2: Date(timeIntervalSinceNow: 0), expiryDate3: Date(timeIntervalSinceNow: 0))
            UserDefaults.standard.setValue(sub0.expiryDate1, forKey: GameConfig.sub1)
            UserDefaults.standard.setValue(sub0.expiryDate2, forKey: GameConfig.sub2)
            UserDefaults.standard.setValue(sub0.expiryDate3, forKey: GameConfig.sub3)
        }
        
        return flag
    }
    
    struct Sub {
        var expiryDate1:Date
        var expiryDate2:Date
        var expiryDate3:Date
    }
    
}

class KeyChain {
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
        
        let swiftString: String = cfStr as String
        return swiftString
    }
}

extension Data {
    init<T>(value: T) {
        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
