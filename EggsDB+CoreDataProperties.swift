//
//  EggsDB+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 5/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit



extension EggsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EggsDB> {
        return NSFetchRequest<EggsDB>(entityName: "EggsDB")
    }
    
   
    
    @nonobjc public class func removeAll() -> Bool {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            
           let _ = try managedContext.fetch(fetchRequest()).map { eggs in
                managedContext.delete(eggs)
            }
            return true
            
        }catch {
            fatalError()
        }
    }
    
    @nonobjc class func add<T:ProtocolCollection>(egg:T) throws -> [EggsDB]?{
        
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        if  let obj =  NSEntityDescription.insertNewObject(forEntityName: self.entity().name!, into: managedContext) as? EggsDB {
            
            
            do {
                obj.date = Date()
              
                
                    obj.type = egg.name
                    try managedContext.save()
                    
                    let data = try managedContext.fetch(fetchRequest())
                    
                    return data
              
            } catch {
                throw error
                
            }
        }
        return nil
    }
}
