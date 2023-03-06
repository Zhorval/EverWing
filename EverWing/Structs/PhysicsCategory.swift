//
//  Structs.swift
//  EverWing
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation

struct PhysicsCategory :OptionSet {
    
    let rawValue: UInt32
    init(rawValue: UInt32) { self.rawValue = rawValue }
    
    static let None             = PhysicsCategory(rawValue: UInt32.min)
    static let ImuneLegacy      = PhysicsCategory(rawValue: UInt32.max)
    static let Player           = PhysicsCategory(rawValue: 1 << 1)
    static let Enemy            = PhysicsCategory(rawValue: 1 << 2)
    static let Projectile       = PhysicsCategory(rawValue: 1 << 3)
    static let Currency         = PhysicsCategory(rawValue: 1 << 4)
    static let Wall             = PhysicsCategory(rawValue: 1 << 5)
    static let Imune            = PhysicsCategory(rawValue: 1 << 6)
    static let BallFX           = PhysicsCategory(rawValue: 1 << 7)
    static let WallFX           = PhysicsCategory(rawValue: 1 << 8)
  
    
}

struct GravityCategory{
    static let None   : UInt32 = 0
    static let Player : UInt32 = 1 << 0
    static let Ball   : UInt32 = 1 << 2
}
