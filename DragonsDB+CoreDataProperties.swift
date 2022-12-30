//
//  DragonsDB+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 30/12/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


extension DragonsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DragonsDB> {
        return NSFetchRequest<DragonsDB>(entityName: "DragonsDB")
    }

    @NSManaged public var dragons: Dragons?

}

extension DragonsDB : Identifiable {

}
