//  AppDelegate.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "DataModel")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 3)
        
        // Override point for customization after application launch.
        window = UIWindow(frame: screenSize)
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        if defaults.bool(forKey: "isPreloadScore") {
            preloadDataScore()
        }
        
        preloadData()
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    private func preloadDataScore() {
       
        let managed = persistentContainer.viewContext
        
        NSEntityDescription.insertNewObject(forEntityName: "Score", into: managed).awakeFromInsert()
        do {
            try managed.save()
            defaults.set(true, forKey: "isPreloadScore")
        } catch let error {
            print("Error save default Score \(error)")
        }
    
    }
    private func preloadData() {
        
      
        let directory = Bundle.main.url(forResource: "property", withExtension: "plist")!
        var items:[Dragons.A] = []
        
        guard let data = try? Data(contentsOf: directory) else { fatalError() }
        
        
        do {
            guard let json = try PropertyListSerialization.propertyList(from: data, options: [],format: nil) as? Dictionary<String,Any>,
                  let js =  json["sidekicks"] as? Dictionary<String,Any>  else { fatalError()}
            
       
            let order = js.keys.sorted(by: {$0 < $1}).reversed()
            for x in order {
                guard let val = js[x] as? Dictionary<String,Dictionary<String,String>> else { return }
                for (i,d) in val["names"]!.enumerated() {
                 //   items.append(contentsOf: [Dragons(name: x+"_T\(i+1)", picture: Dragons.dragons(name: d.value))])
                    
                }
            }
            Dragons.items = items.sorted{$0.name < $1.name}
        } catch  {
            print(error)
        }
    }
}


