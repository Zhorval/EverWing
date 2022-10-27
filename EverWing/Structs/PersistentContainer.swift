//
//  PersistentContainer.swift
//  EverWing
//
//  Created by Pablo  on 30/9/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
