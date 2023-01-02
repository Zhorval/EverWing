//
//  DragonsTransformer.swift
//  EverWing
//
//  Created by Pablo  on 28/12/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation

@objc(CharactersTransformer)
final class CharactersTransformer: NSSecureUnarchiveFromDataTransformer {

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return Characters.self
    }

    override class var allowedTopLevelClasses: [AnyClass] {
        return [Characters.self]
    }

    override func transformedValue(_ value: Any?) -> Any? {
        
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let reminder = value as? Characters else {
            fatalError("Wrong data type: value must be a Reminder object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(reminder)
    }
}

extension CharactersTransformer {
    static let transformerName = NSValueTransformerName(rawValue: "CharacterTransformer")
    
    public static func register() {
        let transformer = DragonsTransformer()
        ValueTransformer.setValueTransformer(transformer, forName:  transformerName)
    }
}

@objc(DragonsTransformer)
final class DragonsTransformer: NSSecureUnarchiveFromDataTransformer {

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return Dragons.self
    }

    override class var allowedTopLevelClasses: [AnyClass] {
        return [Dragons.self,NSArray.self]
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let reminder = value as? Dragons else {
            fatalError("Wrong data type: value must be a Reminder object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(reminder)
    }
}

extension DragonsTransformer {
    
    static let transformerName = NSValueTransformerName(rawValue: "DragonsTransformer")
    
    public static func register() {
        let transformer = DragonsTransformer()
        ValueTransformer.setValueTransformer(transformer, forName:  transformerName)
    }
}

