//
//  Toon.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import SpriteKit

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
    
    enum Character:String,CaseIterable{
        
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
    private var character:CharactersDB
    var level:Int = 1 // For future use
    
    private var charType:Character
    
    
    init(char:Toon.Character){
        
        self.charType = char
        self.size =   CGSize(width: screenSize.width/3, height: screenSize.width/3)

        node = SKSpriteNode()
        node.name = "toon"
        node.size = self.size
       
        let texture = SKTextureAtlas().loadAtlas(name: charType.rawValue + "_Idle", prefix: nil)
       
        if texture.count >  0 {
            node.run(.repeatForever(.animate(with: texture, timePerFrame: 0.1)))
        }
        
        do {
            character = try ManagedDB.shared.getCharacterByName(name: char)
            load(character: character)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func load(character:CharactersDB){
        
         self.description = (character.characters?.description_)!
         self.title = character.characters?.title!
        
         // REVISAR EL BULLETEVEL  EN EL CONSTRUCTOR PROJECTILE 
         bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: Int(character.level))
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false
        node.physicsBody!.collisionBitMask =  0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask =  PhysicsCategory.Enemy

        // Apply Magnetic Field
         let mfield =  SKFieldNode.radialGravityField()
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
    func attack(scene:SKScene?,gameState:GameState) ->SKAction? {
       
        
        let textures = SKTextureAtlas().loadAtlas(name: "\(charType.rawValue)_Attack", prefix: nil)
        
        guard let emitterFlame = SKEmitterNode(fileNamed: "flameSword") else { return nil}
        emitterFlame.name = "flameWord"
        
        let emitterAura = SKEmitterNode(fileNamed: "AuraFire")!
        emitterAura.name = "AuraFire"
        
        let action = SKAction.sequence([
            SKAction.animate(with: textures, timePerFrame: 0.05, resize: true, restore: true),
            .run {
               
                emitterFlame.targetNode = self.node
                emitterFlame.position.y = 80
                emitterFlame.particleAlpha = 0.3
                emitterFlame.run(.sequence([.wait,.removeFromParent()]))
                emitterAura.targetNode = self.node
                emitterAura.position.y = -80
                emitterAura.run(.sequence([.wait,.removeFromParent()]))
                self.node.addChild(self.showAuraShield(atlas: "AuraPlayer",gameState: gameState))
                self.node.addChild(emitterFlame)
                self.node.addChild(emitterAura)
                self.node.run(.move(to: CGPoint(x: screenSize.width/2, y: screenSize.height/2-150), duration: 0.3))
                
            },
            .wait(forDuration: 2),
            .setTexture(textures.first!, resize: false),
            .run {
                self.node.childNode(withName: "AuraPlayer")?.removeFromParent()
                self.node.run(.move(to: CGPoint(x: screenSize.width/2, y: 100), duration: 0.3))
                emitterAura.removeFromParent()
                emitterFlame.removeFromParent()
            }
        ])
        
        return action
    }
    
    // MARK: SHOW AURA SHIELD PLAYER
    func showAuraShield(atlas:String = "Shield",gameState:GameState) -> SKSpriteNode{
    
        
        let spriteAura = SKSpriteNode()
        spriteAura.name = atlas
        spriteAura.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteAura.size =  CGSize(width: node.size.width*3, height: node.size.width*3)
        
        spriteAura.physicsBody = SKPhysicsBody(circleOfRadius: spriteAura.size.width/2)
        spriteAura.physicsBody?.categoryBitMask = PhysicsCategory.Imune
        spriteAura.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy

        spriteAura.physicsBody?.affectedByGravity = false
        spriteAura.physicsBody?.allowsRotation = false
        spriteAura.physicsBody?.isDynamic = false
        if gameState == .Running {
            spriteAura.addChild(liveShield(size:nil))
        }
        
        let atlas = SKTextureAtlas().loadAtlas(name: atlas, prefix: nil)
        let action = SKAction.repeatForever(.animate(with: atlas, timePerFrame: 0.05, resize: false, restore: false))
        
        spriteAura.run(.sequence([action,.wait(forDuration: 15),.removeFromParent()]))
        
       
        return spriteAura
    }
    
    //MARK: GENERATES THE COUNTER FOR THE TIME OF THE PLAYER'S SHIELD OR FOR THE BULLET ICON
    /* Params:
     @duration:Int   Duration time for shield o bullet
     @size:Float     radius by circle 
    */
                    
    
    func liveShield(duration:Int? = 15,size:CGFloat?) -> SKShapeNode {

        let size = size != nil ? size : self.node.size.width * 1.2

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
         return character.characters?.description_ ?? ""
    }
    
    func getToonShortDescription() -> String{
        return character.characters?.shortDescription ?? ""
   }
    
    func getToonAbility() -> String{
        return (character.characters?.ability?.rawValue)!
   }
    
     func getToonName() -> String{
        return charType.rawValue
    }
    
     func getToonTitle() -> String{
         return character.characters?.title ?? ""
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
