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
        
            DragonsTransformer.register()
            CharactersTransformer.register()


            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores { description, error in
                if let error = error {
                     fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    
    /// #Description: Find next dragon by name picture
    /// #Parameter:  @name:String Name picture
    /// #Returns:    Dragons object
    static func findNextDragonByNamePicture(dragon:Dragons) throws -> Dragons {
        
        let number = dragon.picture.getNumberStarName() + 1
        
        let newDragonFind =   dragon.picture.replacingOccurrences(of: "_T\(number)", with: "_T\(number+1)")
        
        do{
            let fetch = NSFetchRequest<DragonsDB>(entityName: "DragonsDB")
            guard let result = try  shared.context.fetch(fetch).filter({ $0.dragons?.picture == newDragonFind}).first?.dragons else {
                throw ExampleError.invalid
                
            }
          
            return result
            
        }catch  {
            throw ExampleError.invalid
        }
    }
    
    /// #Description: Create action evolve dragons
    /// #Parameter:  @dragon:Dragons the new dragon
    /// #Returns:    Bool success
    static func createActionFusionEvolve(newDragon:Dragons,oldDragon:Dragons) throws -> Bool {
        
        do {
            let fetch = NSFetchRequest<DragonsBuy>(entityName: "DragonsBuy")
            let data = Array(try shared.context.fetch(fetch).filter({ ($0.dragons?.level == 10) && ($0.dragons?.percent == 100) && ($0.dragons?.picture == oldDragon.picture)})[0..<2])
            
            
            for x in 0..<data.count {
                 shared.context.delete(data[x])
            }
            
            let entityBuy = NSEntityDescription.entity(forEntityName: "DragonsBuy", in: shared.context)
            let newDragonBuy = NSManagedObject(entity: entityBuy!, insertInto: shared.context)
            newDragonBuy.setValue(newDragon, forKey: "dragons")
            
           try shared.context.save()
            return true
            
        } catch  {
            throw ExampleError.invalid
        }
        
    }
    
    /// #Description: Find all dragons for evolve
    ///  #Parameters: @item:Dragons  Objc dragon
    /// #Returns:   Array dragons found
    static func findDragonsEvolve(item:Dragons) throws -> [Dragons] {
       
        do {
            let fetch = NSFetchRequest<DragonsBuy>(entityName: "DragonsBuy")
            
            let total =   try shared.context.fetch(fetch).filter {
                ($0.dragons!.name == item.name) && ($0.dragons?.level == item.level) && ($0.dragons!.percent == item.percent)}
            .map {$0.dragons!}
            
            if total.count > 1 {
                return total
            }
            return []
            
        }catch  {
            throw ExampleError.invalid
        }
    }
    
    /// #Description: Remove parameters purchased when sell dragons
    ///  #Parameters: @item:Dragons  Objc dragon
    static func removeDragonsDB(items:[Dragons]) throws {
       
        do {
            let objc = try shared.context.fetch(DragonsBuy.fetchRequest())
          
            
               let _ = try objc.compactMap { dragonbuy in
               
                   guard let d = dragonbuy.dragons else { throw ExampleError.invalid }
                   
                      if (items.filter({ $0.id == d.id}).first != nil) {
                         
                          print("Borrado",shared.compareDragonsSides(item: dragonbuy))
                          
                        shared.context.delete(dragonbuy)
                        
                        try shared.context.save()
                      }
            }
        } catch {
            throw ExampleError.invalid
        }
    }
    
    private func compareDragonsSides(item:DragonsBuy) -> Bool {
        
        let managed = ManagedDB.shared.context
        
        do {
            guard let playerObj = try managed.fetch(PlayerDB.fetchRequest()).first,
                  let idItem = item.dragons?.id else { return false}
            
            if playerObj.dragonL != nil && playerObj.dragonL!.id == idItem {
                
                print("Borrado L")
                playerObj.dragonL =  nil
           
            } else if playerObj.dragonR != nil && playerObj.dragonR!.id == idItem {
                
                print("Borrado R")
                playerObj.dragonR =  nil
            }
            try managed.save()
            return true
        } catch   {
            print("Error compareDragons")
            return false
        }
    }
    
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
    
    func getDataPlayer() -> PlayerDB? {
        
        do {
            let managed = ManagedDB.shared.context
            
            guard let data = try managed.fetch(PlayerDB.fetchRequest()).first  else { return nil}
            
            return data
            
        }  catch {
            return nil
        }
    }
    
    static func getDragonSide(side:Direction) -> Dragons? {
        
        do {
            guard let dragon = try shared.context.fetch(PlayerDB.fetchRequest()).first else { return nil}
           
            switch side {
                case .Right:
                    return dragon.dragonR
                case .Left:
                    return dragon.dragonL
                }
            
        } catch  {
            return nil
        }
    }
    /// #Description: Save change side dragons or save new dragon
    /// #Parameters: @dragon:Dragons   Object type Dragons
    /// #            @side:Direction:  The side where the dragon is stored
    /// #Returns:    Success Bool
    static func changeDragonsAction(dragon:Dragons,side:Direction) -> Bool{
        
        do{
            let fetch = NSFetchRequest<PlayerDB>(entityName: "PlayerDB")
            fetch.fetchLimit = 1
           
            guard let data =  try shared.context.fetch(fetch).first else { return false}
           
            switch side {
                case .Left:
                    if data.dragonR?.id == dragon.id {
                        data.dragonR = nil
                    }
                    data.setValue(dragon, forKey: "dragonL")
                case .Right:
                    if data.dragonL?.id == dragon.id {
                        data.dragonL = nil
                    }
                    data.setValue(dragon, forKey: "dragonR")
                }
            try shared.context.save()
            return true
            
            
        }catch {
            print("Error modify side dragons")
            return false
        }
    }
    
    static func addFruitTotal(addFruit:Int,arimethic:String)->Bool {
        
        do {
            guard let fetch = try shared.context.fetch(PlayerDB.fetchRequest()).first  else { return false }
            
            if arimethic == "+" {
                fetch.fruit += Int32(addFruit)
            } else {
                fetch.fruit -= Int32(addFruit)
            }
            
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
    /// - Returns: (Int) Total dragons discovered
    static func getNumberDragonBuy() -> Int {
        
        do {
            let fetch = NSFetchRequest<DragonsBuy>(entityName:"DragonsBuy")
            
            return try shared.context.fetch(fetch).count
          
        }catch {
            return 0
        }

    }
    
    /// - Description: I check if I have the dragon in the DB
    /// - Returns: @handler(Bool)  True if exist dragon
    func isBuyDragon(name:String,completion:@escaping(Bool) -> Void){
     
        do{
            let arr = try ManagedDB.shared.context.fetch(DragonsBuy.fetchRequest())
            
            completion(arr.filter({ $0.dragons?.name == name}).first != nil)
        } catch  {
            print("Error query DB")
        }
    }
    
    static func findDragonsByElement(element:Dragons.ElementDragons) throws -> [Dragons]{
        
        do {
            
            let fetch  = NSFetchRequest<DragonsDB>(entityName: "DragonsDB")
            fetch.predicate = NSPredicate(format: "dragons.element == %@", element.rawValue)
            return try shared.context.fetch(fetch).compactMap {$0.dragons}
            
        } catch  {
            throw ExampleError.invalid
        }
    }
    
    /// #Description: RECEIVE ALL PURCHASED DRAGONS
    ///  #Return:  [Dragons]
     func getAllDragonsBuy() throws ->[Dragons]  {
        
         let managed = ManagedDB.shared.context
        do{
             let fetch = NSFetchRequest<DragonsBuy>(entityName: "DragonsBuy")
            
            let dragons = try  managed.fetch(fetch).compactMap { $0.dragons  }
           
            return dragons
        }catch {
            throw ExampleError.invalid
        }
    }
    
    //MARK: GET NAME SELECT PLAYER
    /// #Description: Get name player selected
    /// #Returns: CharactersModel
    func getCharacterPlayer() throws-> CharactersModel {
        
        let managed  = ManagedDB.shared.context
        do{
                
            guard let player = try managed.fetch(PlayerDB.fetchRequest()).first,
                  let name = player.player else { throw ExampleError.invalid}
            
            return name
            
        } catch {
            throw ExampleError.invalid
        }
    }
    
    /// #Description: Find Character by name
    ///  #Parameters: name:String
    ///  #returns: CharacterModel
    func getCharacterByName(name:Toon.Character) throws -> CharactersDB {
        
        let managed  = ManagedDB.shared.context

        do{
            
            guard let character = try managed.fetch(CharactersDB.fetchRequest()).filter({ $0.characters?.name == name}).first else { throw ExampleError.invalid}
            
            return character
            
        }catch  {
            throw ExampleError.invalid
        }
    }
    
    /// #Description: Change player equip when tap button Equip CharacterMenu
    ///  #Parameters: character:CharacterModel
    ///  #returns: Bool
    func changePlayerEquip(character:CharactersModel) throws -> Bool {
        
        let managed = ManagedDB.shared.context
        do {
             let fetch = NSFetchRequest<PlayerDB>(entityName: "PlayerDB")
            
            guard let result = try managed.fetch(fetch).first else { throw ExampleError.invalid}
            
            result.player = character
          
            try managed.save()
            
            print("Guardado en la db ch",character.name)
            return true
        } catch {
            throw ExampleError.invalid
        }
    }
    
    /// #DESCRIPTION: ADD LEVEL CHARACTERMODEL
    /// #PARAMETERS: --
    /// #RETURNS : BOOL SUCCESS
    static func addLevelCharacter(char:CharactersModel) throws -> Bool {
        
        do {
           
            guard let result = try  shared.context.fetch(CharactersDB.fetchRequest()).filter({ $0.characters?.id == char.id}).first  else { fatalError()}
            
            result.level += 1
                       
            try shared.context.save()
            
            return true
        } catch  {
            throw ExampleError.invalid
        }
    }
    
    //MARK: SAVE THE FOUND DRAGON IN THE DB
    func saveFoundDragon(dragon: DragonsDB) throws {
        

         let managed = ManagedDB.shared.context
        do {
          
            let buyDragon = DragonsBuy(context: managed)
            
                buyDragon.dragons = dragon.dragons
                buyDragon.dragons?.id = UUID().uuidString
                buyDragon.purchased = true
            
                try managed.save()
        } catch let error {
            print("Error save DB dragons \(error.localizedDescription)")
            throw ExampleError.invalid
        }
    }

    /// #Description: Get value like parameter
    ///  #Parameters: @item:Dragons  Objc dragon
    ///  #Return:  Value DB like
    static func getValDragonLike(item:Dragons) -> Bool {
        
        do{
         
            guard let data =  try shared.context.fetch(DragonsBuy.fetchRequest()).filter({ $0.dragons!.id == item.id}).first,
                  let dragon = data.dragons else { return false}
            
            return dragon.like
            
        }catch {
                fatalError()
        }
    }
    
    /// #Description: Check like dragon
    ///  #Parameters: @item: Objc type Dragons
    ///  #Return:  Bool with success
     static func createDragonLike(item:Dragons)->Bool {
        do{
         
            guard let data =  try shared.context.fetch(DragonsBuy.fetchRequest()).filter({ $0.dragons!.id == item.id}).first,
                  let dragon = data.dragons else { fatalError()}
            
            dragon.like = !getValDragonLike(item: item)
            try shared.context.save()
            
            return dragon.like
            
        }catch {
                fatalError()
        }
        
    }
    
    /// #Description: Save dragon by name
    ///  #Parameters: @item: Objc type Dragons
    ///  #Return:  Bool with success
     static func SaveDragonByName(item:Dragons)->Bool? {
        
        do{
            guard let data =  try shared.context.fetch(DragonsBuy.fetchRequest()).filter({ ($0.dragons!.name == item.name) && ($0.dragons!.level != 10) && ($0.dragons!.percent != 100)}).first else { fatalError()}
            data.dragons = item
            
            try shared.context.save()
            
            return true
            
        }catch {
                fatalError()
        }
    }
    
    /// - Description: Save in the DB  the number of coins won at the end of the game and
    /// - Parameters:  @newCoinAmount(Int)   Number coins won
    /// - Returns: True if succes save
    static func saveDbCoin(newCoinAmount:Int,isLess:Bool = false) -> Bool {
        
        do {
            guard let score = try shared.context.fetch(PlayerDB.fetchRequest()).first else { return false }
                
            if isLess {
                score.coin -= Int32(newCoinAmount)
            } else {
                score.coin += Int32(newCoinAmount)
            }
                score.gem += 0
                score.fruit += 0
            
            try shared.context.save()
            
            return true
            
        }catch {
            return false
        }
    }
}
