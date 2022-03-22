//
//  AccountInfo.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit

class AccountInfo{
    
    deinit{
        print("AccountInfo Deinitiated")
    }
  
    
    private struct Data{
        let fullPath:String
        let plist:NSMutableDictionary
        
        init(){
        
            guard let path = Bundle.main.path(forResource: "userinfo", ofType: "plist") else {
                fatalError("plist is nil - Check AccountInfo.swift")
            }
    
            fullPath = path
            
            guard let plist = NSMutableDictionary(contentsOfFile: fullPath) else {
                fatalError("plist is nil - Check AccountInfo.swift")
            }
            self.plist = plist
        }
    }
    
    private var level:Int
    private var currentToonIndex:Int
    private var characters:[Toon]
    private var gold:Int
    private var experience:CGFloat
    private var highscore:Int
    private let data:Data
    
    init(){
        //inventory = Bag()
        level = 0
        currentToonIndex = 0
        gold = 0
        experience = 0.0
        characters = [Toon(char: .Alpha), Toon(char: .Beta), Toon(char: .Celta), Toon(char: .Delta)]
        highscore = 0
        data = Data()
    }
    
    func load() -> Bool{

        // Update Root
            level = data.plist.value(forKey: "Level") as! Int
            gold = data.plist.value(forKey: "Coin") as! Int
            experience = data.plist.value(forKey: "Experience") as! CGFloat
            highscore = data.plist.value(forKey: "Highscore") as! Int
            currentToonIndex = data.plist.value(forKey: "CurrentToon") as! Int
        
        let toondDict = data.plist.value(forKey: "Toons") as! NSDictionary
        
            characters[0].load(infoDict: toondDict.value(forKey: "Alpha") as! NSDictionary)
            characters[1].load(infoDict: toondDict.value(forKey: "Beta") as! NSDictionary)
            characters[2].load(infoDict: toondDict.value(forKey: "Celta") as! NSDictionary)
            characters[3].load(infoDict: toondDict.value(forKey: "Delta") as! NSDictionary)
        
        return true
    }
    
    internal func getGoldBalance() -> Int{
        return self.gold
    }
    
    internal func getCurrentToon() -> Toon{
        return characters[currentToonIndex]
    }
    
    internal func getCurrentToonIndex() -> Int{
        return currentToonIndex
    }
    
    
    /// Generate
    
    func animatableEscudoToon() {
        
        let atlas = SKTextureAtlas().loadAtlas(name: "Effect1", prefix: nil)
        
        print("total \(atlas.count)")
        
        getCurrentToon().getNode().run(.repeatForever(.sequence([
            .animate(with: atlas, timePerFrame: 0.5),
            
            ])))
    }
    
    internal func selectToonIndex(index: Int){
            currentToonIndex = index
            data.plist.setValue(index, forKey: "CurrentToon")
        if !data.plist.write(toFile: data.fullPath, atomically: false){
            print("Saving Error - AccountInfo.selectToonIndex")
        }
    }
    
    internal func upgradeBullet() -> (Bool, String){
        let level = characters[currentToonIndex].getBulletLevel()
        let cost = (level + 1) * 100
        
        if gold < cost {
            return (false, "Not enough gold")
        }
        
        gold -= cost
        data.plist.setValue(gold, forKey: "Coin")
        
        if !data.plist.write(toFile: data.fullPath, atomically: false){
            return (false, "Saving error: AccountInfo.upgradeBullet[1]")
        }
        
        let toonDict = data.plist.value(forKey: "Toons") as! NSDictionary
        guard let currToonDict = toonDict.value(forKey: characters[currentToonIndex].getCharacter().string) as? NSMutableDictionary else{
            return (false, "Error: AccountInfo.upgradeBullet[2]")
        }
        
        if !characters[currentToonIndex].advanceBulletLevel(){
            return (false, "Max Level Achieved")
        }
        
        currToonDict.setValue(characters[currentToonIndex].getBulletLevel(), forKey: "BulletLevel")
        
        if !data.plist.write(toFile: data.fullPath, atomically: false){
            return (false, "Saving Error")
        }
        
        
        return (true, "Success")
    }
    internal func getToonDescriptionByIndex(index: Int) -> [String]{
        return characters[index].getToonDescription()
    }
    internal func getNameOfToonByIndex(index: Int) -> String{
        return characters[index].getToonName()
    }
    internal func getTitleOfToonByIndex(index: Int) -> String{
        return characters[index].getToonTitle()
    }
    internal func getBulletLevelOfToonByIndex(index: Int) -> Int{
        return characters[index].getBulletLevel()
    }
    internal func prepareToChangeScene(){
        characters.removeAll()
    }
    
}
