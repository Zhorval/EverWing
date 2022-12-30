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
            
            let _ = try managed.fetch(DragonsBuy.fetchRequest()).compactMap { managed.delete($0)}
            let _ = try managed.fetch(DragonsDB.fetchRequest()).compactMap { managed.delete($0)}
            let _ = try managed.fetch(PlayerDB.fetchRequest()).compactMap { managed.delete($0)}
            let _ = try managed.fetch(CharactersDB.fetchRequest()).compactMap { managed.delete($0)}
            try managed.save()
            
        }catch let error {
            print("Fatal Appdelegate",error)
        }

   
        if defaults.bool(forKey: "isPreloadScore") {
            preloadDataScore()
            
            do{
                try preloadData()
            } catch let error{
                print(error.localizedDescription)
            }
        }
        
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
    
    private func preloadData() throws  {
        
        let directory = Bundle.main.url(forResource: "property", withExtension: "plist")!
        
        guard let data = try? Data(contentsOf: directory) else { fatalError() }
        
        do {
            guard let json = try PropertyListSerialization.propertyList(from: data, options: [],format: nil) as? Dictionary<String,Any>,
                  let character = json["characters"] as? Dictionary<String,Dictionary<String,String>>,
                  let js =  json["sidekicks"] as? Dictionary<String,Any>  else { throw ExampleError.invalid}
                
                  try preloadCharacters(json: character)
       
            let order = js.keys.sorted(by: {$0 < $1})
            for x in order {
               
                guard let val = js[x] as? Dictionary<String,Dictionary<String,Any>> else { continue }
                
                let keysSort = val.keys.sorted(by: {$0 < $1})
                
                let _ = keysSort.enumerated().compactMap{ (i,z) -> Void in
                    
                    let picture = (x + "_T\(i+1)_icon")
                    
                    guard let element = val[z]?["element"] as? String,
                          let name = val[z]?["name"] as? String,
                          let rarity = (val[z]?["rarity"] as? String)?.replaceWhiteSpace(),
                          let type = val[z]?["type"] as? String,
                          let class_ = val[z]?["class"] as? String,
                          let skills = val[z]?["skills"] as? Dictionary<String,String> else { return }
                    
                    let weakness = skills.values.compactMap { Weakness(rawValue: $0)?.rawValue }
                
                    let d = Dragons(id:UUID().uuidString,name: name, rarity: Dragons.RarityDragon(rawValue: rarity)!, type: type, class_: class_, picture: picture, icons: weakness, element: Dragons.ElementDragons(rawValue:  element)!, level: 1,percent: 0,discover: nil,like:false,horoscope: Dragons.HoroscopeDragon.allCases.randomElement()!)
                   
                    do {
                         try SaveDragonsDB(dragon: d)
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        } catch  {
            throw ExampleError.invalid
        }
    }
    
    private func preloadCharacters(json:Dictionary<String,Dictionary<String,String>>) throws  {
      
        for x in json.keys {
            guard let  name = json[x]?["name"] as? String,
                  let  title = json[x]?["title"] as? String,
                  let  description = json[x]?["description"] as? String,
                  let  shortDescription = json[x]?["shortDescription"] as? String,
                  let  ability = json[x]?["ability"] as? String  else { throw ExampleError.invalid }

            let character = Characters(id: UUID().uuidString, name: Toon.Character(rawValue: name)! , title: title, description_: description, shortDescription: shortDescription, ability: Toon.Ability(rawValue: ability) ?? .Leader, purchased: name == "Alice")
           
            do {
                
                try SaveCharactersDB(characters: character)
                
            } catch  {
                throw ExampleError.invalid
            }
        }
    }
    
    private func SaveCharactersDB(characters:Characters) throws  {
        
        let managed = ManagedDB.shared.context
                  
       do {
           let n = CharactersDB(context: managed)
                       
           n.characters = characters
                  
           try managed.save()
           
          
       } catch {
           throw ExampleError.invalid
       }
    }
    
    private func SaveDragonsDB(dragon:Dragons) throws {
            
     let managed = ManagedDB.shared.context
               
        do {
            let n = DragonsDB(context: managed)
                        
            n.dragons = dragon
            
                   
            try managed.save()
            
        } catch {
            throw ExampleError.invalid
        }
    }
}


extension String {
    func replaceWhiteSpace() -> String{
        
        replacingOccurrences(of: " ", with: "_")
    }
}
