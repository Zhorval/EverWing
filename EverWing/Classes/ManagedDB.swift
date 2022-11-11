//
//  ManagedDb.swift
//  EverWing
//
//  Created by Pablo  on 20/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ManagedDB {
    
    private init() {}
    
    static let shared = ManagedDB()
    
    lazy var context = persistentContainer.viewContext
    
    private var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "DataModel")
            container.loadPersistentStores { description, error in
                if let error = error {
                     fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    
    /// Decrement amount wallet
    func lessAmount(typeCoin:Currency.CurrencyType ,amount:Int) throws {
        
        
        do {
            let score = try  context.fetch(PlayerDB.fetchRequest()).first
            
            if typeCoin == .Coin {
                score?.coin -= Int32(amount)
                
            }else if typeCoin == .Gem {
                score?.gem -= Int32(amount)
            }
            try context.save()
        
            
        } catch let error {
            fatalError("Error managed DB \(error.localizedDescription)")
        }
    }
    
    func save () {
        
       if self.context.hasChanges {
           self.context.perform {
               do {
                   try self.context.save()
               } catch {
                   print("Failure to save context: \(error)")
               }
           }
       }
   }
    
    static func addFruitTotal(addFruit:Int)->Bool {
        
        do {
            guard let fetch = try shared.context.fetch(PlayerDB.fetchRequest()).first  else { return false }
            
            fetch.fruit += Int32(addFruit)
            
            try self.shared.context.save()
           
            return true
            
        } catch let error {
            print("Error save new fruit \(error.localizedDescription)")
        }
        return false
    }
    
    static func getFruitTotal()  -> Int32 {
        
        var fruit:Int32 = 0
        
        do {
            
            guard let fetch = try shared.context.fetch(PlayerDB.fetchRequest()).first else {  return 0 }
            fruit = fetch.fruit
            
        } catch  let error{
            print("Error Gem total ManagerDB \(error)")
        }
        return fruit
    }
    
    
    /// - Description: I look for the number of dragons that I have discovered
    /// - Returns: (Int) Total dragons discoveredd
    static func getDragonBuy() -> Int {
        
        do {
            return try shared.context.fetch(DragonsBuyDB.fetchRequest()).count
            
        }catch {
            print("Error query DB")
        }
        return 0
    }
    
    /// - Description: I check if I have the dragon in the DB
    /// - Returns: @handler(Bool)  True if exist dragon
    func isBuyDragon(name:String,completion:@escaping(Bool) -> Void){
        
        do{
            let arr = try ManagedDB.shared.context.fetch(DragonsBuyDB.fetchRequest())
            
            completion(arr.filter({ $0.picture! == name}).first != nil)
        } catch  {
            print("Error query DB")
        }
    }
    
    /// - Description: Remove dragons when sell
    static func removeDragons(dragons:[Dragons]) {
        
        do{
            let fetch = try shared.context.fetch(DragonsBuyDB.fetchRequest())
            for x in fetch {
                guard dragons.filter({$0.name == x.name}).first != nil  else { continue }
                shared.context.delete(x)
                try shared.context.save()
            }
            
        }catch  {
            print("Error query DB")
        }
    }
    
    /// - Description: Save in the DB  the number of coins won at the end of the game and
    /// - Parameters:  @newCoinAmount(Int)   Number coins won
    /// - Returns: True if succes save
    static func saveDbCoin(newCoinAmount:Int) -> Bool {
        
        do {
            guard let score = try shared.context.fetch(PlayerDB.fetchRequest()).first else { return false}
          
            score.coin += Int32(newCoinAmount)
            score.gem += 0
            score.fruit += 0
            try shared.context.save()
            
            return true
            
        }catch {
            return false
        }
    }
}
