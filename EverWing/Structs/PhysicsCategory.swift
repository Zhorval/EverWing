//
//  Structs.swift
//  EverWing
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None       : UInt32  = 0
    static let ImuneLegacy: UInt32  = UInt32.max
    /// Physics for the item Player
    static let Player     : UInt32  = 1 << 1
    /// Physics for the all item Enemy
    static let Enemy      : UInt32  = 1 << 2
    /// Physics for the projectile player
    static let Projectile : UInt32  = 1 << 3
    /// Physics for the item coin
    static let Currency   : UInt32  = 1 << 4
    /// Physics for the outline of the screen
    static let Wall       : UInt32  = 1 << 5
    /// Physics for the item imune
    static let Imune      : UInt32  = 1 << 7
    /// Physics for the item sprite
    static let Gif        : UInt32  = 1 << 8
    /// Physics for the effect lateral screen of the Boss
    static let BossFX     : UInt32  = 1 << 9
    /// Physics for the Boss hand ball
    static let BallFX     : UInt32  = 1 << 10
}

struct GravityCategory{
    static let None   : UInt32 = 0
    static let Player : UInt32 = 1 << 0
    static let Ball   : UInt32 = 1 << 2
}
