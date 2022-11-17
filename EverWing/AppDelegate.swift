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
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 3)
        
        // Override point for customization after application launch.
        window = UIWindow(frame: screenSize)
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        do{
            let managed = ManagedDB.shared.context
            
            let d = try managed.fetch(DragonsBuyDB.fetchRequest())
            for x in d {
                managed.delete(x)
            }
            try managed.save()
        }catch {}
    
        if !defaults.bool(forKey: "isPreloadScore") {
              preloadDataScore()
        }
        
        preloadData() { d in
            
        }
        
        SJParentValueTransformer<PlayerDataTransformer>.registerTransformer()
        
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
    
   
    
    private func preloadDataScore() {
       
        let managed = ManagedDB.shared.context
        
        NSEntityDescription.insertNewObject(forEntityName: "PlayerDB", into: managed).awakeFromInsert()
        NSEntityDescription.insertNewObject(forEntityName: "Settings", into: managed).awakeFromInsert()
        do {
            try managed.save()
            defaults.set(true, forKey: "isPreloadScore")
        } catch let error {
            print("Error save default Score \(error)")
        }
    
    }
    func preloadData(completion:@escaping(_ T:[Dragons])->Void) {
        
      
        let directory = Bundle.main.url(forResource: "property", withExtension: "plist")!
        
        var items:[Dragons] = []
        
        guard let data = try? Data(contentsOf: directory) else { fatalError() }
        
        do {
            guard let json = try PropertyListSerialization.propertyList(from: data, options: [],format: nil) as? Dictionary<String,Any>,
                  let js =  json["sidekicks"] as? Dictionary<String,Any>  else { fatalError()}
            
       
            let order = js.keys.sorted(by: {$0 < $1})
            for x in order {
               
                guard let val = js[x] as? Dictionary<String,Dictionary<String,Any>> else { continue }
                
                let keysSort = val.keys.sorted(by: {$0 < $1})
                
                let _ = keysSort.enumerated().compactMap{ (i,z) -> Void in
                    
                    let picture = (x + "_T\(i+1)_icon")
                   
                    guard let element = val[z]?["element"] as? String,
                          let name = val[z]?["name"] as? String,
                          let rarity = val[z]?["rarity"] as? String,
                          let type = val[z]?["type"] as? String,
                          let class_ = val[z]?["class"] as? String,
                          let skills = val[z]?["skills"] as? Dictionary<String,String> else { return }
                     
                    let weakness = skills.values.compactMap { Weakness(rawValue: $0) }
                    
                    items.append(Dragons(name: name, rarity: Dragons.RarityDragon(rawValue: rarity)!, type: type, class_: class_, picture: Dragons.dragons(name: picture), icons: weakness, element: element))
                }
            }
            
            Dragons.items = items
            completion(Dragons.items)
        } catch  {
            fatalError(error.localizedDescription)
        }
    }
}


