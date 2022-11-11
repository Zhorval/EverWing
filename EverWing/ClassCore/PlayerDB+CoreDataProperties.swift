//
//  PlayerDB+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 4/11/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerDB> {
        return NSFetchRequest<PlayerDB>(entityName: "PlayerDB")
    }
    
    public override func awakeFromInsert() {
        coin = 0
        gem = 0
        fruit = 0
    }

    @NSManaged public var coin: Int32
    @NSManaged public var gem: Int32
    @NSManaged public var fruit: Int32

}
