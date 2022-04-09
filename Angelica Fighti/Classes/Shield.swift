//
//  File.swift
//  Angelica Fighti
//
//  Created by Pablo  on 24/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class EffectLateral:Enemy {
    
    private var effect:Enemy?
    
    convenience required init(hp:CGFloat) {
        self.init()
        
        self.name = "EffectLeft"
        self.hp = 100
        self.maxHp = 100
        effect = Enemy()
        self.position = CGPoint(x: 100, y: 100)
        self.size = CGSize(width: 100, height: 100)
        self.run(SKAction.repeatForever(SKAction.scale(to: CGSize(width: 100, height: 100), duration: 0.5)))
        self.setScale(10)
        effect?.addHealthBar()
    }
}

class Shield:Enemy {
    
    var atlas:[SKTexture] = SKTextureAtlas().loadAtlas(name: "Shield", prefix: nil)
    var auraAtlas:[SKTexture] = SKTextureAtlas().loadAtlas(name: "Aura", prefix: nil)
    private var shield:Enemy?
    private var player:SKSpriteNode?
    
    convenience init(baseHp:CGFloat,player:Toon,auraEffect:Bool){
         self.init()
         
         self.name = "shield"
       
         self.hp = 100
        
         self.maxHp = 100
        
        shield = Enemy()
        self.player = player.getNode()
       
        
        self.texture = atlas.first!
        self.position = CGPoint(x: 0, y: 0)
        self.size = CGSize(width: 200, height: 200)
        self.addHealthBar(isHidden: false)
        
        let aura = SKSpriteNode(texture: auraAtlas.first, size: self.size)
        aura.run(.repeatForever(.animate(with: auraAtlas, timePerFrame: 0.5)))
    
        self.addChild(aura)
        
        self.run(SKAction.repeatForever(SKAction.animate(with: atlas, timePerFrame: 0.1)))
        
        initialSetup(category: PhysicsCategory.Enemy)
    }
    
    
}

