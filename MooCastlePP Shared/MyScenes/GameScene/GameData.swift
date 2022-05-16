//
//  GameData.swift
//  IceFireFF iOS
//
//  Created by hehehe on 12/30/21.
//

import Foundation
import SpriteKit

extension GameScene {
    func readDataFunc() {
        level = UserDefaults.standard.integer(forKey: "level")
        var data = readDataFromCSV(fileName: "Data/level_\(level)", fileType: "csv")
        data = cleanRows(file: data!)
        readData(data: data!)
        toastLbl.text = "Level : \(level)"
        showToast(CGPoint.withPercent(50, y: 40))
        levelLbl.changeTextWithAnimationScaled(withText: "Level : \(level)")
        scoreLbl.changeTextWithAnimationScaled(withText: "Score : \(score) / \(targetScore)")
        
        addChild([ levelLbl, toastLbl])
        Sounds.sharedInstance().playSound(soundName: "Sounds/level_up.mp3")
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }

    func readData(data: String)  {
        let rows = data.components(separatedBy: "\n")
        var result: [[String]] = []
        result.removeAll()
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        nRow = result.count - 1
        nCol = result[0].count
        
        for i in 0...nRow-1 {
            for j in 0...nCol-1 {
                
                tileArr[nRow-1-i][j] = Tile(img: "_ice_square.png", size: CGSize.zero, position: CGPoint.zero, zPosition: 2)
                tileArr[nRow-1-i][j].name = result[i][j]
                 
                tileArr[nRow-1-i][j].alpha = 0.5
            }
        }

    }
}
