//
//  DragonsDB+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 14/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


extension DragonsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DragonsDB> {
        return NSFetchRequest<DragonsDB>(entityName: "DragonsDB")
    }

    @NSManaged public var selectedLeft: String?
    @NSManaged public var selectedRight: Date?
   

}
