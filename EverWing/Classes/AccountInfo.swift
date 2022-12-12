//
//  AccountInfo.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData


class AccountInfo{
    
    deinit{
        print("AccountInfo Deinitiated")
    }
    
    
    private struct Data{
        var player:PlayerDB? = nil
        var characters:[Toon] = []
        
        init(){
            
            player = ManagedDB.shared.getDataPlayer()
            
            characters =  Toon.Character.allCases.map { Toon(char: $0)}
        }
    }
    
    private var level:Int
    private var currentToonIndex:Int = 0
    private var gold:Int
    private let data:Data
    
    init(){
        level = 0
        gold = 0
        data = Data()
        currentToonIndex = 0 //self.data.characters.firstIndex(where: {$0.getCharacter() ==  self.data.player?.player?.name})!
      
    }
    
    func load() -> Bool{

        level =  0
        
        gold =   Int(data.player?.coin ?? 0)
        
        return true
    }
    
     func getGoldBalance() -> Int{
        return self.gold
    }
    
     func getCurrentToon() -> Toon{
         return data.characters[currentToonIndex]
    }
    
     func getCurrentToonIndex() -> Int{
        return currentToonIndex
    }
    
     func selectToonIndex(index: Int){
            currentToonIndex = index
    }
    func getActualPlayer() -> Toon {
        Toon(char: Toon.Character(rawValue: (data.player?.player?.name?.rawValue)!)!)
    }
    
    
    func getTotalCharacter() -> Int {
        data.characters.count
    }
    
     func upgradeBullet() -> (Bool, String){
         
         let level = data.characters[currentToonIndex].getBulletLevel()
       
         let cost = (level + 1) * 100

        if gold < cost {
            return (false, "Not enough gold balance: \(getGoldBalance())")
        }
        
        gold -= cost
         if !ManagedDB.saveDbCoin(newCoinAmount: gold,isLess: true) {
             return (false, "Error save new account gold")
         }
  
        return (true, "Success")
    }
   
    
 
    
    func upgradeLevel() -> Int {
        level += 1
        return level
    }
    func getLevel() -> Int {
        return level
    }
    
     func getToonDescriptionByIndex(index: Int) -> String{
         return data.characters[index].getToonDescription()
    }
     func getNameOfToonByIndex(index: Int) -> String{
         return data.characters[index].getToonName()
    }
     func getTitleOfToonByIndex(index: Int) -> String{
        
         return data.characters[index].getToonTitle()
    }
     func getBulletLevelOfToonByIndex(index: Int) -> Int{
         return data.characters[index].getBulletLevel()
    }
    
    func getToonByIndex(index:Int)-> Toon {
        
        return data.characters[index]
    }
     func prepareToChangeScene(){
       //  data.characters.removeAll()
    }
    
}
