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
    
    private var actions:[SKTexture]
    var audioPlayer:AVAudioPlayer?
    var type:ProtocolCurrency
    
    init<T:ProtocolCurrency>(type: T, avaudio: AVAudio? = nil){
       
        self.type = type
        
        switch self.type {
            case  CurrencyType.Coin:
                actions = global.getTextures(textures: .Gold_Animation)
           
            case CurrencyType.Amethyst,
                 CurrencyType.Ruby,
                 CurrencyType.Diamond,
                 CurrencyType.Clover,CurrencyType.Magnet:
            
                actions = SKTextureAtlas().loadAtlas(name: type.name + "_Animation", prefix: nil)
            // global.getTextures(textures: Global.Animation(rawValue: type.rawValue + "_Animation")!)
           
            case CurrencyType.Eggs:
                let random =  EggsCurrencyType.allCases.randomElement()!.name
                actions = [SKTexture(imageNamed:  random)]
            default:
                actions = [SKTexture(imageNamed:  EggsCurrencyType.allCases.randomElement()!.name)]
        }
        
    }
    
    
    
     func changeTypeCoin<T:ProtocolCurrency>(type:T) {
        
        self.type = type
        
        switch self.type{
            case Currency.CurrencyType.Coin:
                actions = global.getTextures(textures: .Gold_Animation)
            case Currency.CurrencyType.Clover:
                actions = [SKTexture(imageNamed: "Clover")]
            case Currency.CurrencyType.Amethyst:
                actions = global.getTextures(textures: .Amethyst_Animation)
            case Currency.CurrencyType.Diamond:
                actions = global.getTextures(textures: .Diamond_Animation)
            case Currency.CurrencyType.Ruby:
                actions = global.getTextures(textures: .Ruby_Animation)
            case Currency.CurrencyType.Magnet:
                actions = global.getTextures(textures: .Magnet_Animation)
            case Currency.CurrencyType.Mushroom:
                actions = global.getTextures(textures: .Mushroom_Animation)
            case Currency.CurrencyType.Flower:
                 actions = global.getTextures(textures: .Flower_Animation)
            case Currency.CurrencyType.Eggs:
                self.type = Currency.EggsCurrencyType.allCases.randomElement()!
                actions = [SKTexture(imageNamed: self.type.name)]
            case Currency.CurrencyType.None:
                actions = []
            default:
                actions = []
        }
        
    }
    
     func createCoin(posX:CGFloat, posY:CGFloat, width w: CGFloat, height h: CGFloat, createPhysicalBody:Bool, animation: Bool) -> SKSpriteNode{

        let c = SKSpriteNode(texture: actions.first)
        //c.size = CGSize(width: 30, height: 30)
        c.size = CGSize(width: w, height: h)
        c.position = CGPoint(x: posX, y: posY)
        c.name = type.name.lowercased()
        
        if (createPhysicalBody){
            //c.physicsBody =  SKPhysicsBody(texture: c.texture!, size: c.size)
            c.physicsBody = SKPhysicsBody(circleOfRadius: w/2)
            c.physicsBody!.isDynamic = true // allow physic simulation to move it
            c.physicsBody!.categoryBitMask = PhysicsCategory.Currency
            c.physicsBody!.contactTestBitMask = PhysicsCategory.Player
            c.physicsBody!.collisionBitMask = PhysicsCategory.None
            c.physicsBody!.fieldBitMask = GravityCategory.Player // Pullable by player
        }
        
        if (animation && !actions.isEmpty){
            c.run(SKAction.repeatForever(SKAction.animate(with: actions, timePerFrame: 0.1)))
            self.changeTypeCoin(type: CurrencyType.Coin)

        }
        return c
    }
    
    
}
