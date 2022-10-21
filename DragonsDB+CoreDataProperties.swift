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

    @NSManaged public var tier0: String?
    @NSManaged public var tier1: String?
    @NSManaged public var tier2: String?
    @NSManaged public var picture: String?

}
