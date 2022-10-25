//
//  EggsDB+CoreDataClass.swift
//  EverWing
//
//  Created by Pablo  on 5/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit



@objc(EggsDB)
class EggsDB: NSManagedObject {
    
    
     @NSManaged public var type: String
     @NSManaged public var date: Date
     @NSManaged fileprivate var priorityValue:Currency.EggsCurrencyType.RawValue
    
    let managedObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var priority:Currency.EggsCurrencyType {
        get {
            return Currency.EggsCurrencyType.init(rawValue: type) ?? .Common
        }
        set {
            priorityValue = newValue.rawValue
        }
    }
  
}
