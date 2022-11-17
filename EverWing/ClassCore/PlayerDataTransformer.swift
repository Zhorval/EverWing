//
//  PlayerDataTransformer.swift
//  EverWing
//
//  Created by Pablo  on 4/11/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation

struct DragonProperties{
    
    var name:String
    var picture:String
    var level:Int
    var power:Int16
    var discover:Date
   
}

class PlayerDataTransformer:NSSecureUnarchiveFromDataTransformer,NSCoding {
    
    static var supportsSecureCoding: Bool = true
   
    var data:DragonProperties? = nil
    
    init(dragon:DragonProperties) {
        self.data = dragon
    }
    
    required  init?(coder: NSCoder) {
        data = coder.decodeObject(forKey: "data") as? DragonProperties
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(data,forKey: "data")
    }
}


public class SJParentValueTransformer<T: NSCoding & NSObject>: ValueTransformer {
    
    public override class func transformedValueClass() -> AnyClass { T.self }
    
    public override class func allowsReverseTransformation() ->Bool { true }
    
    public override func transformedValue(_ value: Any?) -> Any? {
        
         guard let value = value as? T else { return nil }
        
        return try?
             NSKeyedArchiver.archivedData(withRootObject: value,requiringSecureCoding: true)
     }
    
    public override func reverseTransformedValue(_ value: Any?) ->Any? {
        
         guard let data = value as? NSData else { return nil }
        
             let result = try? NSKeyedUnarchiver.unarchivedObject(
                 ofClass: T.self,
                 from: data as Data
             )
         return result
    }
    
     public static var transformerName: NSValueTransformerName {
        
         let className = "\(T.self.classForCoder())"
         
         return NSValueTransformerName("\(className)Transformer")
      }
          
     public static func registerTransformer() {
         
        let transformer = SJParentValueTransformer<T>()
         
        ValueTransformer.setValueTransformer(transformer, forName:  transformerName)
     }
}
