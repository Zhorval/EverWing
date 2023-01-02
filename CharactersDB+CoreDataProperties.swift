//
//  CharactersDB+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 30/12/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


extension CharactersDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharactersDB> {
        return NSFetchRequest<CharactersDB>(entityName: "CharactersDB")
    }

    @NSManaged public var characters: Characters
    @NSManaged public var level: Int32

}

