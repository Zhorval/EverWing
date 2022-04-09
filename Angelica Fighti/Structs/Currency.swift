//
//  Currency.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/3/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit
import AVFoundation

struct Currency{
    
    enum CurrencyType:String,CaseIterable{
        
        case None
        case Coin
        case Clover
        case Amethyst
        case Ruby
        case Diamond
        case Magnet
        case Mushroom
        case Flower
        
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
            case .None,.Magnet,.Mushroom,.Flower:
                return 0
            }
        }
        
    }
    
    private var actions:[SKTexture]
    var audioPlayer:AVAudioPlayer?
    var type:CurrencyType
    
    init(type: CurrencyType, avaudio: AVAudio? = nil){
        
        self.type = type
        
        switch type{
            case .Coin:
                actions = global.getTextures(textures: .Gold_Animation)
           
            case .Amethyst,
                .Ruby,
                .Diamond,
                .Clover,.Magnet:
            
            print("El type \(type) Currency init")
            actions = SKTextureAtlas().loadAtlas(name: type.rawValue + "_Animation", prefix: nil)
           // global.getTextures(textures: Global.Animation(rawValue: type.rawValue + "_Animation")!)
           
            default:
                actions = []
        }
        
    }
    
    
    
    mutating func changeTypeCoin(type:CurrencyType) {
        
        switch type{
            case .Coin:
                actions = global.getTextures(textures: .Gold_Animation)
            case .Clover:
                actions = [SKTexture(imageNamed: "Clover")]
            case .Amethyst:
                actions = global.getTextures(textures: .Amethyst_Animation)
            case .Diamond:
                actions = global.getTextures(textures: .Diamond_Animation)
            case .Ruby:
                actions = global.getTextures(textures: .Ruby_Animation)
            case .Magnet:
                actions = global.getTextures(textures: .Magnet_Animation)
            case .Mushroom:
                actions = global.getTextures(textures: .Mushroom_Animation)
            case .Flower:
                 actions = global.getTextures(textures: .Flower_Animation)
        case .None:
                actions = []
        
        }
        
        self.type = type
    }
    
    mutating func createCoin(posX:CGFloat, posY:CGFloat, width w: CGFloat, height h: CGFloat, createPhysicalBody:Bool, animation: Bool) -> SKSpriteNode{

        let c = SKSpriteNode(texture: actions.first)
        //c.size = CGSize(width: 30, height: 30)
        c.size = CGSize(width: w, height: h)
        c.position = CGPoint(x: posX, y: posY)
        c.name = type.rawValue.lowercased()
        
        if (createPhysicalBody){
            //c.physicsBody =  SKPhysicsBody(texture: c.texture!, size: c.size)
            c.physicsBody = SKPhysicsBody(circleOfRadius: 15)
            c.physicsBody!.isDynamic = true // allow physic simulation to move it
            c.physicsBody!.categoryBitMask = PhysicsCategory.Currency
            c.physicsBody!.contactTestBitMask = PhysicsCategory.Player
            c.physicsBody!.collisionBitMask = PhysicsCategory.Wall
            c.physicsBody!.fieldBitMask = GravityCategory.Player // Pullable by player
        }
        
        if (animation && !actions.isEmpty){
            c.run(SKAction.repeatForever(SKAction.animate(with: actions, timePerFrame: 0.1)))
            self.changeTypeCoin(type: .Coin)

        }
        return c
    }
    
    
}
