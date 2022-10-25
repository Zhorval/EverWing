//
//  Score+CoreDataClass.swift
//  EverWing
//
//  Created by Pablo  on 5/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
//

import Foundation
import CoreData


public class Score: NSManagedObject {
    
    override public func awakeFromInsert() {
     
    super.awakeFromInsert()
       
        coin = Int32(0)
        gem = Int32(0)
        totalscore = Int32(0)
        print("Cargado")
   }
}
