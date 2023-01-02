//
//  Toon.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import SpriteKit


protocol ProtocolPartsToon{
    
    var wing:CGImage        { get }
    var body:CGImage        { get }
    var subwing:CGImage?    { get }
    var head:CGImage        { get }
    var mane:CGImage?       { get }
    var hair:CGImage?       { get }
    var sword:CGImage       { get }
    var skirt:CGImage       { get }
    var hand:CGImage        { get }
    var handAttack:CGImage  { get }
    var legL:CGImage        { get }
    var legR:CGImage        { get }
    var arm:CGImage         { get }
    var forearm:CGImage             { get }
    var swordBackImages:[CGImage]   { get }
    var backgroundEffect1:CGImage { get }
    var backgroundEffect2:CGImage { get }

}

class Toon{
    
    enum Ability:String,CaseIterable,ProtocolIcons,ProtocolCurrency {
        
        var name: String {
            self.rawValue
        }
        
       case Leader          = "Leader's Luck"
       case Prisma          = "Prisma Cannons"
       case Dragon_Training = "Dragon Training"
       case Golden_Touch    = "Golden Touch"
       case Magnetism       = "Magnetism"
       case Ghostform       = "Ghostform"
       case Shadowform      = "Shadowform"
       case Dragonspell     = "Dragonspell"
       case Candy_Rush      = "Candy Rush"
       case Freezing_Blast  = "Freezing Blast"
       case Runic_Fang      = "Runic Fang"
       case Egg_Hunter      = "Egg Hunter"
   }
    
    enum Character:String,CaseIterable,Codable{
        
        case Lenore
        case Lucia
        case Sophia
        case Lily
        case Fiona
        case Jade
        case Arcana
        case Alice
        case Aurora
        case Trixie
        case Lyra
        case Neve
        
        var pathTexture:String {
            
            return "fairy_\(self.rawValue.lowercased())1"
        
        }
        
        var pathBackgroundEffect:String {
            
            return "base1"
        }
        
        var pathAuraFire:String {
            return "auras1"
        }
        
        var auraFire:[CGImage] { [
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 0, y: 220, width: 92, height: 177))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 0, y: 0, width: 110, height: 224))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 109, y: 0, width: 110, height: 221))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 219, y: 0, width: 111, height: 221))! ]
        }
        var auraCirclePurple:[CGImage] {[
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 109, y: 221, width: 123, height: 120))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 115, y: 364, width: 123, height: 120))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 0, y: 539, width: 117, height: 120))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 116, y: 542, width: 117, height: 117))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 229, y: 476, width: 118, height: 118))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 346, y: 476, width: 117, height: 117))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 450, y: 117, width: 117, height: 120))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 569, y: 0,   width: 112, height: 114))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 566, y: 111, width: 112, height: 115))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 565, y: 225, width: 112, height: 115))!]
        }
        
        var auraCircleBlue:[CGImage] { [
            
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 333, y: 0, width: 112, height: 118))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 451, y: 0, width: 112, height: 115))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 236, y: 244, width: 112, height: 115))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 353, y: 243, width: 112, height: 116))!,
            UIImage(named: pathAuraFire)!.cgImage!.cropping(to: CGRect(x: 355, y: 359, width: 112, height: 116))!
        ]}
        
        var swordBackImages:[CGImage] {
            
            switch self {
            case .Lenore: return [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 5, y: 277, width: 79, height: 51))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 5, y: 350, width: 79, height: 51))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 5, y: 431, width: 79, height: 51))! ]
            case .Jade: return [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 305, y: 6, width: 41, height: 39))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 273, y: 306, width: 41, height: 39))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 227, y: 309, width: 40, height: 39))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 230, y: 261, width: 45, height: 44))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 176, y: 261, width: 45, height: 44))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 214, y: 207, width: 45, height: 44))!]
            case .Arcana: return [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 1, y: 218, width: 74, height: 66))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 165, y: 164, width: 69, height: 60))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 195, y: 88, width: 68, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 268, y: 80, width: 68, height: 68))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 233, y: 155, width: 69, height: 68))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 341, y: 0, width: 68, height: 67))!]
                
            case .Sophia:  return  [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 291, y: 10, width: 42, height: 51))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 346, y: 3, width: 48, height: 56))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 406, y: 9, width: 43, height: 53))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 403, y: 75, width: 44, height: 52))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 355, y: 75, width: 42, height: 53))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 300, y: 76, width: 43, height: 53))! ]
            case .Fiona: return [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 138, y: 130, width: 51, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 202, y: 130, width: 51, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 225, y: 6, width: 51, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 288, y: 5, width: 52, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 360, y: 4, width: 52, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 269, y: 82, width: 51, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 356, y: 82, width: 51, height: 58))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 269, y: 161, width: 51, height: 58))! ]
            case .Aurora: return [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 277, y: 7, width: 26, height: 37))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 314, y: 7, width: 26, height: 38))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 276, y: 58, width: 27, height: 37))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 313, y: 57, width: 26, height: 37))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 313, y: 107, width: 26, height: 37))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 274, y: 155, width: 26, height: 37))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 312, y: 157, width: 26, height: 37))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 274, y: 206, width: 26, height: 37))! ]
            case .Alice: return  [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 240, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 281, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 324, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 367, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 410, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 454, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 496, y: 719, width: 33, height: 61))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 538, y: 719, width: 33, height: 61))! ]
            case .Trixie: return [
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 6, y: 757, width: 76, height: 84))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 91, y: 757, width: 77, height: 85))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 178, y: 756, width: 76, height: 84))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 264, y: 757, width: 77, height: 84))!,
                UIImage(named: pathTexture)!.cgImage!.cropping(to: CGRect(x: 351, y: 756, width: 76, height: 84))! ]
            default: return []
            }
        }
        var backgroundEffect2: CGImage {
            return (UIImage(named: pathBackgroundEffect)?.cgImage?.cropping(to: CGRect(x: 51, y: 49, width: 105, height: 157)))!
        }
        
        var backgroundEffect1: CGImage {
            return (UIImage(named: pathBackgroundEffect)?.cgImage?.cropping(to: CGRect(x: 222, y: 1, width: 116, height: 166)))!
        }
        
        var updateBulletCoin:Int {
            switch self {
                case .Lenore: return 300
                case .Lucia:  return 200
                case .Sophia: return 200
                case .Lily:   return 200
                case .Fiona:  return 200
                case .Jade:   return 200
                case .Arcana: return 400
                case .Alice:  return 200
                case .Aurora: return 300
                case .Trixie: return 200
                case .Lyra:   return 200
                case .Neve:   return 200
            }
        }
        
        var type:String {
            switch self {
                case .Lenore: return "RARE"
                case .Lucia:  return "RARE"
                case .Sophia: return "COMMON"
                case .Lily:   return "COMMON"
                case .Fiona:  return "COMMON"
                case .Jade:   return "EPIC"
                case .Arcana: return "EPIC"
                case .Alice:  return "COMMON"
                case .Aurora: return "RARE"
                case .Trixie: return "RARE"
                case .Lyra:   return "EPIC"
                case .Neve:   return "RARE"
            }
        }
        
        var rank:Int {
            switch self {
                case .Lenore: return 10
                case .Lucia:  return 4
                case .Sophia: return 2
                case .Lily:   return 2
                case .Fiona:  return 2
                case .Jade:   return 4
                case .Arcana: return 2
                case .Alice:  return 2
                case .Aurora: return 10
                case .Trixie: return 10
                case .Lyra:   return 2
                case .Neve:   return 10
            }
        }
        
        struct Table:ProtocolTableViewGenericCell {
           
            var picture: ProtocolIcons
            
            var name: String
            
            var title: String
            
            var amount: Int
            
            var gemAmount: CGFloat?
            
            var icon: ProtocolCurrency
            
            static var items: [Toon.Character.Table] =  [
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "1 STAR", amount: 10,gemAmount: 20, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "2 STAR", amount: 20,gemAmount: 30, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "3 STAR", amount: 40,gemAmount: 40, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "4 STAR", amount: 80,gemAmount: 50, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "5 STAR", amount: 100,gemAmount: 60, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "6 STAR", amount: 120,gemAmount: 70, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "7 STAR", amount: 150,gemAmount: 80, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "8 STAR", amount: 175,gemAmount: 90, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "9 STAR", amount: 200,gemAmount: 100, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "10 STAR", amount: 225,gemAmount: 125, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "11 STAR", amount: 250,gemAmount: 150, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "12 STAR", amount: 275,gemAmount: 175, icon: Ability.Leader),
                Table(picture: Ability.Leader, name: Toon.Character.Alice.rawValue, title: "13 STAR", amount: 300,gemAmount: 200, icon: Ability.Leader),
                      
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "1 STAR", amount: 10,gemAmount: 100, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "2 STAR", amount: 20,gemAmount: 110, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "3 STAR", amount: 40,gemAmount: 120, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "4 STAR", amount: 80,gemAmount: 130, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "5 STAR", amount: 100,gemAmount: 140, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "6 STAR", amount: 120,gemAmount: 150, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "7 STAR", amount: 150,gemAmount: 160, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "8 STAR", amount: 175,gemAmount: 170, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "9 STAR", amount: 200,gemAmount: 180, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "10 STAR", amount: 225,gemAmount: 190, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "11 STAR", amount: 250,gemAmount: 200, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "12 STAR", amount: 275,gemAmount: 225, icon: Ability.Dragon_Training),
               Table(picture: Ability.Dragon_Training, name: Toon.Character.Fiona.rawValue, title: "13 STAR", amount: 300,gemAmount: 250, icon: Ability.Dragon_Training),
                
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "1 STAR", amount: 10,gemAmount: 1, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "2 STAR", amount: 20,gemAmount: 2, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "3 STAR", amount: 40,gemAmount: 3, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "4 STAR", amount: 80,gemAmount: 4, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "5 STAR", amount: 100,gemAmount: 5, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "6 STAR", amount: 120,gemAmount: 6, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "7 STAR", amount: 150,gemAmount: 7, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "8 STAR", amount: 175,gemAmount: 8, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "9 STAR", amount: 200,gemAmount: 9, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "10 STAR", amount: 225,gemAmount: 10, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "11 STAR", amount: 250,gemAmount: 11, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "12 STAR", amount: 275,gemAmount: 12, icon: Ability.Egg_Hunter),
                Table(picture: Ability.Egg_Hunter, name: Toon.Character.Sophia.rawValue, title: "13 STAR", amount: 300,gemAmount: 13, icon: Ability.Egg_Hunter),
                
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "1 STAR", amount: 10,gemAmount: 100, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "2 STAR", amount: 20,gemAmount: 110, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "3 STAR", amount: 40,gemAmount: 120, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "4 STAR", amount: 80,gemAmount: 130, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "5 STAR", amount: 100,gemAmount: 140, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "6 STAR", amount: 120,gemAmount: 150, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "7 STAR", amount: 150,gemAmount: 160, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "8 STAR", amount: 175,gemAmount: 170, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "9 STAR", amount: 200,gemAmount: 180, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "10 STAR", amount: 225,gemAmount: 190, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "11 STAR", amount: 250,gemAmount: 200, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "12 STAR", amount: 275,gemAmount: 225, icon: Ability.Golden_Touch),
                Table(picture: Ability.Golden_Touch, name: Toon.Character.Lily.rawValue, title: "13 STAR", amount: 300,gemAmount: 250, icon: Ability.Golden_Touch),
                
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "1 STAR", amount: 10,gemAmount: 55, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "2 STAR", amount: 20,gemAmount: 60, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "3 STAR", amount: 40,gemAmount: 65, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "4 STAR", amount: 80,gemAmount: 75, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "5 STAR", amount: 100,gemAmount: 80, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "6 STAR", amount: 120,gemAmount: 85, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "7 STAR", amount: 150,gemAmount: 95, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "8 STAR", amount: 175,gemAmount: 100, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "9 STAR", amount: 200,gemAmount: 105, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "10 STAR", amount: 225,gemAmount: 115, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "11 STAR", amount: 250,gemAmount: 125, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "12 STAR", amount: 275,gemAmount: 135, icon: Ability.Magnetism),
                Table(picture: Ability.Magnetism, name: Toon.Character.Aurora.rawValue, title: "12 STAR", amount: 300,gemAmount: 150, icon: Ability.Magnetism),

                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "1 STAR", amount: 10,gemAmount: 50, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "2 STAR", amount: 20,gemAmount: 52, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "3 STAR", amount: 40,gemAmount: 54, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "4 STAR", amount: 80,gemAmount: 60, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "5 STAR", amount: 100,gemAmount: 62, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "6 STAR", amount: 120,gemAmount: 64, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "7 STAR", amount: 150,gemAmount: 70, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "8 STAR", amount: 175,gemAmount: 72, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "9 STAR", amount: 200,gemAmount: 74, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "10 STAR", amount: 225,gemAmount: 80, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "11 STAR", amount: 250,gemAmount: 85, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "12 STAR", amount: 275,gemAmount: 90, icon: Ability.Ghostform),
                Table(picture: Ability.Ghostform, name: Toon.Character.Lenore.rawValue, title: "13 STAR", amount: 300,gemAmount: 100, icon: Ability.Ghostform),
                
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "1 STAR", amount: 10,gemAmount: 5, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "2 STAR", amount: 20,gemAmount: 5.1, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "3 STAR", amount: 40,gemAmount: 5.2, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "4 STAR", amount: 80,gemAmount: 5.5, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "5 STAR", amount: 100,gemAmount: 5.6, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "6 STAR", amount: 120,gemAmount: 5.7, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "7 STAR", amount: 150,gemAmount: 6, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "8 STAR", amount: 175,gemAmount: 6.1, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "9 STAR", amount: 200,gemAmount: 6.2, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "10 STAR", amount: 225,gemAmount: 6.5, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "11 STAR", amount: 250,gemAmount: 7, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "12 STAR", amount: 275,gemAmount: 7.5, icon: Ability.Shadowform),
                Table(picture: Ability.Shadowform, name: Toon.Character.Jade.rawValue, title: "13 STAR", amount: 300,gemAmount: 8, icon: Ability.Shadowform),

                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "1 STAR", amount: 10,gemAmount: 10, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "2 STAR", amount: 20,gemAmount: 10.3, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "3 STAR", amount: 40,gemAmount: 10.6, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "4 STAR", amount: 80,gemAmount: 11, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "5 STAR", amount: 100,gemAmount: 11.3, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "6 STAR", amount: 120,gemAmount: 11.6, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "7 STAR", amount: 150,gemAmount: 12, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "8 STAR", amount: 175,gemAmount: 12.3, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "9 STAR", amount: 200,gemAmount: 12.6, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "10 STAR", amount: 225,gemAmount: 13, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "11 STAR", amount: 250,gemAmount: 14, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "12 STAR", amount: 275,gemAmount: 15, icon: Ability.Dragonspell),
                Table(picture: Ability.Dragonspell, name: Toon.Character.Arcana.rawValue, title: "13 STAR", amount: 300,gemAmount: 16, icon: Ability.Dragonspell),
                
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "1 STAR", amount: 10,gemAmount: 10, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "2 STAR", amount: 20,gemAmount: 10.3, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "3 STAR", amount: 40,gemAmount: 10.6, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "4 STAR", amount: 80,gemAmount: 11, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "5 STAR", amount: 100,gemAmount: 11.3, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "6 STAR", amount: 120,gemAmount: 11.6, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "7 STAR", amount: 150,gemAmount: 12, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "8 STAR", amount: 175,gemAmount: 12.3, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "9 STAR", amount: 200,gemAmount: 12.6, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "10 STAR", amount: 225,gemAmount: 13, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "11 STAR", amount: 250,gemAmount: 14, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "12 STAR", amount: 275,gemAmount: 15, icon: Ability.Prisma),
                Table(picture: Ability.Prisma, name: Toon.Character.Lyra.rawValue, title: "13 STAR", amount: 300,gemAmount: 16, icon: Ability.Prisma),
                
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "1 STAR", amount: 10,gemAmount: 6, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "2 STAR", amount: 20,gemAmount: 6.2, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "3 STAR", amount: 40,gemAmount: 6.4, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "4 STAR", amount: 80,gemAmount: 6.6, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "5 STAR", amount: 100,gemAmount: 6.8, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "6 STAR", amount: 120,gemAmount: 7, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "7 STAR", amount: 150,gemAmount: 7.2, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "8 STAR", amount: 175,gemAmount: 7.4, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "9 STAR", amount: 200,gemAmount: 7.6, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "10 STAR", amount: 225,gemAmount: 8, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "11 STAR", amount: 250,gemAmount: 8.6, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "12 STAR", amount: 275,gemAmount: 9.2, icon: Ability.Candy_Rush),
                Table(picture: Ability.Candy_Rush, name: Toon.Character.Trixie.rawValue, title: "13 STAR", amount: 300,gemAmount: 10, icon: Ability.Candy_Rush),
                
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "1 STAR", amount: 10,gemAmount: 8, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "2 STAR", amount: 20,gemAmount: 8.4, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "3 STAR", amount: 40,gemAmount: 8.8, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "4 STAR", amount: 80,gemAmount: 9.2, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "5 STAR", amount: 100,gemAmount: 9.6, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "6 STAR", amount: 120,gemAmount: 10, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "7 STAR", amount: 150,gemAmount: 10.4, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "8 STAR", amount: 175,gemAmount: 10.8, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "9 STAR", amount: 200,gemAmount: 11.2, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "10 STAR", amount: 225,gemAmount: 11.6, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "11 STAR", amount: 250,gemAmount: 12, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "12 STAR", amount: 275,gemAmount: 13, icon: Ability.Freezing_Blast),
                Table(picture: Ability.Freezing_Blast, name: Toon.Character.Lucia.rawValue, title: "13 STAR", amount: 300,gemAmount: 14, icon: Ability.Freezing_Blast),
                
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "1 STAR", amount: 10,gemAmount: 15, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "2 STAR", amount: 20,gemAmount: 18, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "3 STAR", amount: 40,gemAmount: 21, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "4 STAR", amount: 80,gemAmount: 24, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "5 STAR", amount: 100,gemAmount: 27, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "6 STAR", amount: 120,gemAmount: 30, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "7 STAR", amount: 150,gemAmount: 33, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "8 STAR", amount: 175,gemAmount: 36, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "9 STAR", amount: 200,gemAmount: 39, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "10 STAR", amount: 225,gemAmount: 42, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "11 STAR", amount: 250,gemAmount: 45, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "12 STAR", amount: 275,gemAmount: 50, icon: Ability.Runic_Fang),
                Table(picture: Ability.Runic_Fang, name: Toon.Character.Neve.rawValue, title: "13 STAR", amount: 300,gemAmount: 60, icon: Ability.Runic_Fang),

            ]
        }
    }
    
    deinit {
        print("Toon deinit")
        
    }
    
    private var size:CGSize
    private var node:SKSpriteNode
    private var bullet:Projectile?
    private var description:String = ""
    private var experience:CGFloat = 0
    private var title:String?
    private var character:CharactersDB?
    private var isActiveShield = false
    var level:Int = 1 // For future use
    
    private var charType:Character
    
    init(char:Toon.Character){
        
        self.charType =  char == .Lily ? .Alice : char
        self.size =   CGSize(width: screenSize.width/3, height: screenSize.width/3)

        node = SKSpriteNode()
        node.name = "toon"
        node.size = self.size
      
        print("LLamada Toon")
   
        do {
            character = try ManagedDB.shared.getCharacterByName(name: charType)
            load(character: character!)
            setupPhysics()
            joinPartToon()

        } catch let error {
            fatalError("Fatalerror  \(error.localizedDescription)")
        }
       
    }
    
    private func setupPhysics() {
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/4)
        node.physicsBody!.isDynamic = false
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.collisionBitMask = PhysicsCategory.Enemy
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody!.fieldBitMask = GravityCategory.Player // Not affect by magnetic
    }
    
    private func joinPartToon() {
        
        
        let body = SKSpriteNode(texture:  SKTexture(cgImage: charType.body))
        node.addChild(body)
    
        let head = SKSpriteNode(texture:  SKTexture(cgImage: charType.head))
        head.position.y = body.size.height
        body.addChild(head)
    
        if let mane = charType.mane {
            let mane = SKSpriteNode(texture:  SKTexture(cgImage: mane))
            mane.position.y = -head.size.height/2
            head.addChild(mane)
        }
    
        if charType.hair != nil {
            let hair = SKSpriteNode(texture:  SKTexture(cgImage: charType.hair!))
            hair.position.y = -5
            head.addChild(hair)
        }
        
        let amrL = SKSpriteNode(texture:  SKTexture(cgImage: charType.arm))
        amrL.name = "armL"
        amrL.anchorPoint = CGPoint(x: 1, y: 0)
        amrL.position = CGPoint(x: -8, y: amrL.frame.width/2)
        amrL.xScale = -1
        amrL.zRotation = .pi/2
        amrL.run(.repeatForever(.sequence([.rotate(byAngle: .pi/12, duration: 0.5),.rotate(byAngle: -.pi/12, duration: 0.5)])))
        body.addChild(amrL)
        
        let foreamrL = SKSpriteNode(texture:  SKTexture(cgImage: charType.forearm))
        foreamrL.anchorPoint = CGPoint(x: 0.5, y: 1)
        foreamrL.position = CGPoint(x: -3, y: foreamrL.frame.height)
        foreamrL.zRotation = .pi
        amrL.addChild(foreamrL)
      
        let handL = SKSpriteNode(texture:  SKTexture(cgImage: charType.hand))
        handL.anchorPoint = CGPoint(x: 0.5, y: 1)
        handL.position = CGPoint(x: 0, y: -8)
        foreamrL.addChild(handL)
        
        let armR = amrL.copy() as! SKSpriteNode
        armR.name = "armR"
        armR.xScale = -1
        armR.zRotation = (200 * .pi/180)
        armR.position.x = body.size.width/2
        body.addChild(armR)
        
        let skirt = SKSpriteNode(texture:  SKTexture(cgImage: charType.skirt))
        skirt.anchorPoint = CGPoint(x: 0.5, y: 1)
        skirt.position.y = -(body.frame.height*0.4)
        skirt.position.x = 1
        body.addChild(skirt)
      
        let legL = SKSpriteNode(texture:  SKTexture(cgImage: charType.legL))
        legL.position.y = -(skirt.size.height/2 + body.size.height)
        legL.position.x = -body.size.width/4
        body.addChild(legL)
        
        let legR = SKSpriteNode(texture:  SKTexture(cgImage: charType.legR))
        legR.position.y = -(skirt.size.height/2.1 + body.size.height)
        legR.position.x = body.size.width/4

        body.addChild(legR)
        
        
      
        let winL = SKSpriteNode(texture:  SKTexture(cgImage: charType.wing))
        winL.anchorPoint = CGPoint(x: 1, y: 0.5)
        winL.run(.repeatForever(.sequence([.resize(toWidth: winL.frame.width*0.1, duration: 0.2),.resize(toWidth: winL.frame.width, duration: 0.5)])))
        winL.position.x = -1
        winL.position.y = 0
        body.addChild(winL)
        
        
        if let subwinL = charType.subwing {
            let subwinL = SKSpriteNode(texture:  SKTexture(cgImage: subwinL))
                subwinL.anchorPoint = CGPoint(x: 1, y: 1)
                subwinL.run(.repeatForever(.sequence([.resize(toWidth: subwinL.frame.width*0.1, duration: 0.2),.resize(toWidth: subwinL.frame.width, duration: 0.5)])))
                
                subwinL.zRotation = 10 * .pi / 180
                subwinL.position.x = -1
                subwinL.position.y = -10
                winL.addChild(subwinL)
        }
        
        let winR = SKSpriteNode(texture:  SKTexture(cgImage: charType.wing))
        winR.anchorPoint = CGPoint(x: 1, y: 0.5)
        winR.run(.repeatForever(.sequence([.resize(toWidth: winR.frame.width*0.1, duration: 0.2),.resize(toWidth: winR.frame.width, duration: 0.5)])))
        winR.position.x = 1
        winR.position.y = 0
        winR.xScale = -1
        body.addChild(winR)
        
        if let subwinR = charType.subwing {
          let subwinR = SKSpriteNode(texture:  SKTexture(cgImage: subwinR))
            subwinR.anchorPoint = CGPoint(x: 1, y: 1)
            subwinR.run(.repeatForever(.sequence([.resize(toWidth: subwinR.frame.width*0.1, duration: 0.2),.resize(toWidth: subwinR.frame.width, duration: 0.5)])))
            subwinR.zRotation = 10 * .pi / 180
            subwinR.position.x = -1
            subwinR.position.y = -10
            winR.addChild(subwinR)
        }
     
    }
    
    func load(character:CharactersDB){
        
       
            self.description = (character.characters.description_!)
            self.title = character.characters.title
        
             // REVISAR EL BULLETEVEL  EN EL CONSTRUCTOR PROJECTILE
            bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: Int(character.level))
            
            // Apply Magnetic Field
        let mfield =  SKFieldNode.electricField()// radialGravityField()
            mfield.smoothness = 1
            mfield.region = SKRegion(radius: Float(node.size.width))
            mfield.strength =  120.0
            mfield.categoryBitMask = GravityCategory.Player
            node.addChild(mfield)
             if bullet == nil {
                 fatalError("Error bullet")
             }

    }
    
     func getNode() -> SKSpriteNode{
        return node
    }

     func updateProjectile(node:SKSpriteNode){
         bullet?.setPos(x: node.position.x,y:node.position.y)
     }
   
    // MARK: ANIMATE TEXTURE ATTACK
    func attack()  {
        
        let sword = SKSpriteNode(texture: SKTexture(cgImage: charType.sword))
        sword.position = CGPoint(x: 0, y: sword.frame.height)
        node.addChild(sword)
        
        let backSword = SKSpriteNode(texture: SKTexture(cgImage: charType.swordBackImages.first!))
        backSword.position = CGPoint(x: 0, y: sword.frame.height/2 - backSword.frame.height/2)
        backSword.run(.repeatForever(.animate(with: charType.swordBackImages.map { SKTexture(cgImage: $0)}, timePerFrame: 0.1,resize: true,restore: true)))
        backSword.zPosition = sword.zPosition-1
        sword.addChild(backSword)
        
        let aura = SKSpriteNode(texture: SKTexture(cgImage: charType.auraFire.first!))
        aura.name = "aura"
        aura.zPosition = -1
        aura.position.y = -node.frame.height/2
        aura.run(.repeatForever(.animate(with: charType.auraFire.compactMap { SKTexture(cgImage: $0)}, timePerFrame: 0.2, resize: true, restore: true)))
        node.addChild(aura)
        
        let background1 = SKSpriteNode(texture: SKTexture(cgImage: charType.backgroundEffect1))
        background1.size = CGSize(width: aura.frame.width*0.8, height: aura.frame.height*0.8)
        background1.alpha = 0.4
        background1.position.y = -aura.frame.height*0.1
        background1.name = "background"
        aura.addChild(background1)
        
        let background2 = SKSpriteNode(texture: SKTexture(cgImage: charType.backgroundEffect2))
        background2.alpha = 0.5
        background1.addChild(background2)
       
       
        let actionL = SKAction.sequence([.rotate(byAngle: -.pi, duration: 0.5),.wait(forDuration: 8),.rotate(byAngle: .pi, duration: 0.5),
                                                                        .run {
                                                                            backSword.removeFromParent()
                                                                            aura.removeFromParent()
                                                                        }
                                                                          ])
        let actionR = SKAction.sequence([.rotate(byAngle: .pi, duration: 0.5),.wait(forDuration: 8),.rotate(byAngle: -.pi, duration: 0.5)])
       
        node.children.forEach { a in
            a.enumerateChildNodes(withName: "arm*") { node, obc in
                node.run( node.name == "armL" ? actionL : actionR)
            }
        }
    }
    
    // MARK: SHOW AURA SHIELD PLAYER
    func showAuraShield() {
        
        if !isActiveShield {
            let nodeAura = SKNode()
            
            nodeAura.addChild(auraPurple())
            nodeAura.addChild(auraBlue())
            nodeAura.run(.sequence([.wait(forDuration: 5),.removeFromParent(),.run { [weak self] in
                self?.isActiveShield = false
            }]))
            node.addChild(nodeAura)
        }
    }
    
    // MARK: SHOW AURA CIRCLE PURPLE SHIELD PLAYER
    private func auraPurple() -> SKSpriteNode {
        
        isActiveShield = true
        let atlas = charType.auraCirclePurple.compactMap { SKTexture(cgImage: $0)}

        let spriteAura = SKSpriteNode(texture:  atlas.first!)
        spriteAura.name = "shield"
        spriteAura.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteAura.size =  node.size.applying(CGAffineTransformMakeScale(1.2, 1.2))
        
        spriteAura.physicsBody = SKPhysicsBody(circleOfRadius: spriteAura.size.width/2)
        spriteAura.physicsBody?.categoryBitMask = PhysicsCategory.Imune
        spriteAura.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy

        spriteAura.physicsBody?.affectedByGravity = false
        spriteAura.physicsBody?.allowsRotation = false
        spriteAura.physicsBody?.isDynamic = false
        
        let action = SKAction.repeatForever(.animate(with: atlas, timePerFrame: 0.05, resize: true, restore: true))
        
        spriteAura.run(action)
        
        return spriteAura
    }
    
    // MARK: SHOW AURA CIRCLE BLUE SHIELD PLAYER
    private func auraBlue() -> SKSpriteNode {
        
        self.isActiveShield = true
        
        let atlas = charType.auraCircleBlue.compactMap { SKTexture(cgImage: $0)}

        let spriteAura = SKSpriteNode(texture:  atlas.first!)
        spriteAura.name = "shieldBlue"
        spriteAura.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteAura.size =  node.size.applying(CGAffineTransformMakeScale(1.2, 1.2))
        
        spriteAura.physicsBody = SKPhysicsBody(circleOfRadius: spriteAura.size.width/2)
        spriteAura.physicsBody?.categoryBitMask = PhysicsCategory.Imune
        spriteAura.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy

        spriteAura.physicsBody?.affectedByGravity = false
        spriteAura.physicsBody?.allowsRotation = false
        spriteAura.physicsBody?.isDynamic = false
        
        let action = SKAction.repeatForever(.animate(with: atlas, timePerFrame: 0.05, resize: true, restore: true))
        
        spriteAura.run(action)
        
        return spriteAura
    }
    
    //MARK: GENERATES THE COUNTER FOR THE TIME OF THE PLAYER'S SHIELD OR FOR THE BULLET ICON
    /* Params:
     @duration:Int   Duration time for shield o bullet
     @size:Float     radius by circle 
    */
    func liveShield(duration:Int? = 15,size:CGFloat?) -> SKShapeNode {

        let size = size != nil ? size : self.node.size.width/2

        let circle = SKShapeNode(circleOfRadius: size!)
        circle.fillColor = SKColor.green.withAlphaComponent(0.3)
        circle.glowWidth = 1
        circle.strokeColor = .white.withAlphaComponent(0.5)
        circle.zRotation = CGFloat.pi / 2
        circle.zPosition = -1

        countdown(circle: circle, steps: 15, duration: TimeInterval(duration!)) {
             self.node.childNode(withName: "spriteAura")?.removeFromParent()
             self.node.childNode(withName: "Shield")?.removeFromParent()
             self.node.childNode(withName: "AuraPlayer")?.removeFromParent()
        }
        
        return circle
    }
    
    // Creates an animated countdown timer
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, completion:@escaping ()->Void) {
       
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width/2
        let timeInterval = duration/TimeInterval(steps)
        let incr = 1 / CGFloat(steps)
        var percent = 1.0

        let animate = SKAction.run {
            percent -= incr
           
            if percent < 0.50 {
                circle.fillColor = .systemOrange.withAlphaComponent(0.5)
            } else  if  percent < 0.25 {
                circle.fillColor = .systemRed.withAlphaComponent(0.5)
            }
            
            circle.path = self.circle(radius: radius, percent:percent)
        }
        let wait = SKAction.wait(forDuration:timeInterval)
        let action = SKAction.sequence([wait, animate])

        circle.run(SKAction.repeat(action,count:steps-1)) {
            circle.run(SKAction.wait(forDuration:timeInterval)) {
                circle.path = nil
                completion()
            }
        }
    }
    
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
      
       let start:CGFloat = 0
       let end = CGFloat(Double.pi*2) * percent
       let center = CGPointZero
       let bezierPath = UIBezierPath()
            bezierPath.move(to: center)
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            bezierPath.miterLimit = 10
            bezierPath.addLine(to: center)
        
        return bezierPath.cgPath
       }
    
    
    func changeTextureProjectile(level:Int) {
        
        self.level = level
        bullet?.bulletLevel = level
        bullet = Projectile(posX: 0, posY: 0, char: getCharacter(), bulletLevel: getBulletLevel())
     
    }
 
     func getBullet() -> Projectile?{
         
        return bullet ?? nil
    }

     func getToonDescription() -> String{
         return character?.characters.description_ ?? ""
    }
    
    func getToonShortDescription() -> String{
        return character?.characters.shortDescription ?? ""
   }
    
    func getToonAbility() -> String{
        return (character?.characters.ability!.rawValue) ?? ""
   }
    
     func getToonName() -> String{
        return charType.rawValue
    }
    
     func getToonTitle() -> String{
         return character?.characters.title ?? ""
    }
    
     func getBulletLevel() -> Int{
        1
        // return bullet!.getBulletLevel()
    }
    
      func lessLevel()  {
          
          if level > 1 {
              level -= 1
          } else {
              level = 1
          }
    }
    
     func getLevel() -> Int{
        level
    }
    
    func addLevel() {
        level += 1
        
    }
    
     func advanceBulletLevel() -> Bool{
         guard bullet != nil else { return false}

         return self.bullet!.upgrade()
    }
    // Remove below function later on. Combine it with getToonName
     func getCharacter() -> Character{
        return charType
    }
    
    
    func getTextureCurrentToon() -> Global.Main? {
        
        let name = "Character_\(getToonName().capitalized)"
        print("Name \(name)")
        
        return   Global.Main.Character_Alpha
    }
}


extension Toon.Character:ProtocolPartsToon {
    
    var wing: CGImage {
        switch self {
        case .Lenore: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 327, y: 400, width: 70, height: 34)))!
        case .Lucia:  return  (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 347, y: 2, width: 77, height: 43)))!
        case .Sophia: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 320, y: 210, width: 66, height: 58)))!
        case .Fiona:  return  (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 185, y: 362, width: 66, height: 40)))!
        case .Jade:   return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 119, y: 322, width: 42, height: 32)))!
        case .Arcana: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 339, y: 69, width: 59, height: 36)))!
        case .Aurora: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 192, y: 196, width: 65, height: 52)))!
        case .Trixie: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 432, y: 815, width: 65, height: 49)))!
        case .Lyra:   return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 586, y: 504, width: 83, height: 52)))!
        case .Alice:  return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 345, y: 522, width: 64, height: 23)))!



        default:      return  (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 327, y: 400, width: 70, height: 34)))!
        }
    }
    
    var subwing: CGImage? {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 342, y: 115, width: 39, height: 29)))!
        case .Lucia : return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 230, y: 348, width: 67, height: 38)))!
        case .Sophia,.Fiona: return nil
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 312, y: 50, width: 26, height: 28)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 180, y: 329, width: 30, height: 25)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 2, y: 270, width: 56, height: 43)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 847, y: 435, width: 45, height: 24)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 422, y: 213, width: 43, height: 22)))!

        default: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 342, y: 115, width: 38, height: 28)))!
        }
    }
    
    var head: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 327, y: 438, width: 32, height: 26)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 230, y: 388, width: 45, height: 31)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 410, y: 329, width: 40, height: 27)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 361, y: 155, width: 48, height: 36)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 267, y: 220, width: 42, height: 31)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 232, y: 298, width: 46, height: 41)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 60, y: 268, width: 56, height: 39)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 899, y: 94, width: 35, height: 33)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 706, y: 139, width: 38, height: 28)))!



        default: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 327, y: 439, width: 32, height: 26)))!
        }
    }
    var mane: CGImage? {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 84, y: 325, width: 36, height: 20)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 427, y: 203, width: 36, height: 25)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 410, y: 360, width: 28, height: 32)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 185, y: 404, width: 19, height: 8)))!
        case .Jade,.Arcana:   return nil
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 348, y: 3, width: 38, height: 19)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 795, y: 308, width: 50, height: 35)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 685, y: 463, width: 26, height: 33)))!



        default: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 327, y: 439, width: 32, height: 26)))!
        }
    }
    
    var hair: CGImage? {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 326, y: 470, width: 30, height: 26)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 458, y: 159, width: 28, height: 29)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 386, y: 273, width: 20, height: 41)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 233, y: 82, width: 21, height: 24)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 172, y: 313, width: 16, height: 40)))!
        case .Arcana: return nil
        case .Aurora: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 348, y: 26, width: 25, height: 34)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 683, y: 570, width: 26, height: 41)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 316, y: 669, width: 20, height: 43)))!



        default: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 327, y: 439, width: 32, height: 26)))!
        }
    }
        
    var sword: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 168, y: 142, width: 49, height: 83)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 332, y: 98, width: 26, height: 68)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 355, y: 271, width: 28, height: 51)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 116, y: 158, width: 16, height: 82)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 163, y: 208, width: 11, height: 46)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 3, y: 287, width: 32, height: 72)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 163, y: 150, width: 28, height: 75)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 262, y: 402, width: 54, height: 121)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 570, y: 246, width: 24, height: 59)))!



        default: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 168, y: 142, width: 49, height: 83)))!
        }
    }
    
    var skirt: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 342, y: 83, width: 49, height: 28)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 427, y: 52, width: 61, height: 56)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 259, y: 228, width: 33, height: 22)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 134, y: 206, width: 26, height: 31)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 312, y: 81, width: 18, height: 23)))!
        case .Arcana: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 180, y: 298, width: 30, height: 29)))!
        case .Aurora: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 193, y: 150, width: 71, height: 44)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 900, y: 53, width: 44, height: 17)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 706, y: 171, width: 33, height: 21)))!



        default:  return(UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 342, y: 83, width: 49, height: 28)))!
        }
    }
    
    var hand: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 492, y: 110, width: 10, height: 7)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 457, y: 191, width: 9, height: 9)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 309, y: 240, width: 9, height: 7)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 206, y: 404, width: 10, height: 8)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 203, y: 343, width: 9, height: 8)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 211, y: 342, width: 9, height: 9)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 375, y: 25, width: 11, height: 9)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 414, y: 865, width: 10, height: 8)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 703, y: 499, width: 9, height: 8)))!




        default: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 492, y: 110, width: 10, height: 7)))!
        }
    }
    
    var handAttack:CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 73, y: 244, width: 10, height: 10)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 216, y: 397, width: 11, height: 13)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 309, y: 228, width: 9, height: 10)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 254, y: 362, width: 9, height: 9)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 193, y: 344, width: 8, height: 10)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 89, y: 270, width: 8, height: 10)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 151, y: 350, width: 10, height: 12)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 800, y: 724, width: 10, height: 10)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 630, y: 695, width: 10, height: 8)))!



        default: return(UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 492, y: 110, width: 10, height: 7)))!
        }
    }
    
    var legL: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 489, y: 320, width: 10, height: 47)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 215, y: 350, width: 13, height: 43)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 296, y: 228, width: 11, height: 39)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 220, y: 83, width: 11, height: 37)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 273, y: 108, width: 12, height: 55)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 217, y: 232, width: 11, height: 52)))!
        case .Aurora: return  (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 272, y: 106, width: 11, height: 42)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 449, y: 749, width: 13, height: 45)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 413, y: 493, width: 10, height: 38)))!



        default: return(UIImage(named: pathTexture)?.cgImage?.cropping(to:  CGRect(x: 489, y: 320, width: 10, height: 47)))!
        }
    }
    
    var legR: CGImage {
        switch self {
        case .Lenore: return(UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 489, y: 370, width: 11, height: 44)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 372, y: 47, width: 14, height: 48)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 220, y: 328, width: 9, height: 45)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 330, y: 81, width: 13, height: 44)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 273, y: 167, width: 13, height: 50)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 217, y: 287, width: 12, height: 47)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 269, y: 253, width: 12, height: 46)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 433, y: 750, width: 13, height: 51)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 630, y: 651, width: 11, height: 43)))!



        default: return(UIImage(named: pathTexture)?.cgImage?.cropping(to:   CGRect(x: 489, y: 370, width: 11, height: 44)))!
        }
    }
    
    var arm: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 493, y: 83, width: 6, height: 23)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 480, y: 112, width: 8, height: 22)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 233, y: 329, width: 6, height: 20)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 254, y: 391, width: 6, height: 20)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 303, y: 51, width: 6, height: 20)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 400, y: 70, width: 8, height: 22)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 152, y: 767, width: 7, height: 20)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 163, y: 227, width: 11, height: 22)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 883, y: 248, width: 8, height: 21)))!





        default: return(UIImage(named: pathTexture)?.cgImage?.cropping(to:  CGRect(x: 240, y: 141, width: 6, height: 16)))!
        }
    }
    
    var forearm: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 240, y: 141, width: 6, height: 16)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 299, y: 410, width: 10, height: 16)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 232, y: 351, width: 8, height: 14)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 117, y: 242, width: 8, height: 14)))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 178, y: 240, width: 9, height: 15)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 78, y: 269, width: 7, height: 16)))!
        case .Alice:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 413, y: 534, width: 9, height: 15)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 104, y: 251, width: 11, height: 17)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 693, y: 617, width: 11, height: 15)))!



        default: return(UIImage(named: pathTexture)?.cgImage?.cropping(to:   CGRect(x: 493, y: 83, width: 6, height: 23)))!
        }
    }
    
    var body: CGImage {
        switch self {
        case .Lenore: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 383, y: 164, width: 25, height: 29)))!
        case .Lucia:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 419, y: 231, width: 26, height: 27)))!
        case .Sophia: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 3, y: 424, width: 22, height: 31)))!
        case .Fiona:  return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 163, y: 208, width: 22, height: 27 )))!
        case .Jade:   return (UIImage(named: pathTexture)?.cgImage?.cropping(to:CGRect(x: 178, y: 208, width: 22, height: 28)))!
        case .Arcana: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 152, y: 110, width: 27, height: 33)))!
        case .Aurora: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 348, y: 65, width: 25, height: 32)))!
        case .Trixie: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 119, y: 886, width: 22, height: 25)))!
        case .Alice: return (UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 715, y: 478, width: 20, height: 25)))!


            
        default: return(UIImage(named: pathTexture)?.cgImage?.cropping(to: CGRect(x: 383, y: 164, width: 25, height: 29)))!
        }
    }

}
