//
//  DragonsBuy+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 30/12/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


extension DragonsBuy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DragonsBuy> {
        return NSFetchRequest<DragonsBuy>(entityName: "DragonsBuy")
    }

    @NSManaged public var dragons: Dragons?
    @NSManaged public var like: Bool
    @NSManaged public var purchased: Bool

}

extension DragonsBuy : Identifiable {

}
