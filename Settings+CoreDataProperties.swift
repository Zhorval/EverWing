//
//  Settings+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 1/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension Settings {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }
    
    @nonobjc public class func updateSettings(key: String) -> Bool {
        
        let managerObject = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        do {
            guard let result = try managerObject?.fetch(fetchRequest()).first as? NSManagedObject,
                  let value = result.value(forKey: key) as? Bool else { return false}
            
            result.setValue(!value, forKey: key)
          
            try managerObject?.save()
            
            return true
            
        }catch  {
            return false
        }
    }
    

    @NSManaged public var music: Bool
    @NSManaged public var voice: Bool
    @NSManaged public var sfx: Bool
    @NSManaged public var movement: NSDecimalNumber?

}
