//
//  Structs.swift
//  EverWing
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//


import SpriteKit
import AVFoundation


protocol ProtocolCurrency {
    
    var name:String { get }
}



class Currency{
    
    
    var pathImages:String {
        "base1.png"
    }
    
    enum EggsCurrencyType:String,CaseIterable,Hashable,ProtocolCurrency,ProtocolCollection {
        
      
        typealias A = Self
        
        static var items:[A] = [.Common ,.Bronze,.Golden,.Magical,.Silver]
        
        case Common
        case Bronze
        case Golden
        case Magical
        case Silver
        
        var name: String {
            switch self {
            case .Golden:
                return "Golden"
            case .Common:
                return "Common"
            case .Bronze:
                return "Bronze"
            case .Magical:
                return "Magical"
            case .Silver:
                return "Silver"
            }
        }
    }
    
    enum CurrencyType:String,CaseIterable,ProtocolCurrency{
        
        var name: String {
            get { rawValue.lowercased()}
            
        }
        case None
        case Coin
        case Clover
        case Amethyst
        case Ruby
        case Diamond
        case Magnet
        case Mushroom
        case Flower
        case Eggs
        case Gem  /// Revisar si sale el icono de la gema en pantalla
        case Fruit
        
        var pathImages:String {
            "base1.png"
        }
        
        var pictureIcon:[CGImage]? {
        
        
            switch self {
            case .None:     return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 129, y: 573, width: 34, height: 44))]
            case .Coin:     return [
                            UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 129, y: 573, width: 34, height: 44)),
                            UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 36, y: 523, width: 18, height: 38)),
                            UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 63, y: 523, width: 18, height: 28)),
                            ]
            case .Clover:   return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 169, y: 50, width: 42, height: 38))]
            case .Amethyst: return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 288, y: 567, width: 36, height: 45))]
            case .Ruby:     return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 362, y: 567, width: 36, height: 45))]
            case .Diamond:  return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 362, y: 567, width: 36, height: 45))]
            case .Magnet:   return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 477, y: 365, width: 41, height: 41))]
            case .Mushroom: return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 263, y: 406, width: 46, height: 35))]
            case .Flower:   return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 283, y: 335, width: 51, height: 48))]
            case .Eggs:     return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 362, y: 567, width: 36, height: 45))] // revisar el icono de los tres no es el correcto
            case .Gem:      return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 362, y: 567, width: 36, height: 45))] //
            case .Fruit:    return [UIImage(named: pathImages)!.cgImage!.cropImage(to: CGRect(x: 362, y: 567, width: 36, height: 45))] //
            }
        }
        
        var currency:Int {
            switch self {
            case .Coin:
                return 1
            case .Clover:
                return 10
            case .Amethyst:
                return 20
            case .Ruby:
                return 30
            case .Diamond:
                return 40
            case .None,.Magnet,.Mushroom,.Flower,.Eggs,.Gem,.Fruit:
                return 0
            }
        }
        
    }
    
    var type:CurrencyType
    
    init(type: CurrencyType, avaudio: AVAudio? = nil){
       
        self.type = type
      
    }
    
     func createCoin(posX:CGFloat, posY:CGFloat, width w: CGFloat, height h: CGFloat, createPhysicalBody:Bool, animation: Bool) -> SKSpriteNode{

        let c = SKSpriteNode(texture: SKTexture(cgImage: type.pictureIcon!.first!))
         
        c.size = CGSize(width: w, height: h)
        c.position = CGPoint(x: posX, y: posY)
        c.name = type.name.lowercased()
        
        if (createPhysicalBody){
            //c.physicsBody =  SKPhysicsBody(texture: c.texture!, size: c.size)
            c.physicsBody = SKPhysicsBody(circleOfRadius: w/2)
            c.physicsBody!.isDynamic = true // allow physic simulation to move it
            c.physicsBody!.category = [.Currency]
     //     c.physicsBody!.contactTestBitMask = PhysicsCategory.Player
    //      c.physicsBody!.collisionBitMask = PhysicsCategory.None
            c.physicsBody!.fieldBitMask = GravityCategory.Player // Pullable by player
        }
        
         if (animation && !type.pictureIcon!.isEmpty){
             c.run(SKAction.repeatForever(SKAction.animate(with:  type.pictureIcon!.compactMap {SKTexture(cgImage: $0)}, timePerFrame: 0.01)))
             type = .Coin
        }
        return c
    }
    
    
}
