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
    
    @nonobjc public class func _addEgg(egg:String) -> Bool {
        
        guard let managedObj = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return false}
        
        do{
            let newItem = EggsDB(context: managedObj)
            newItem. =
            
        } catch  {
            return false
        }
        
        
    }

    @NSManaged public var bronze: Int16
    @NSManaged public var common: Int16
    @NSManaged public var golden: Int16
    @NSManaged public var magical: Int16
    @NSManaged public var silver: Int16

}
