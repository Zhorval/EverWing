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
            let score = try  context.fetch(Score.fetchRequest()).first
            
            if typeCoin == .Coin {
                score?.coin -= Int32(amount)
                
            }else if typeCoin == .Gem {
                score?.gem -= Int32(amount)
            }
            try context.save()
            
            print(try context.fetch(Score.fetchRequest()).first?.coin)
        
            
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

}
