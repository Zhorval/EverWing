//
//  Score+CoreDataProperties.swift
//  EverWing
//
//  Created by Pablo  on 5/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var coin: Int16
    @NSManaged public var gem: Int16
    @NSManaged public var highscore: Int16

}
