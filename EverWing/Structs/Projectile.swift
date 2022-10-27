//
//  Projectile.swift
//  EverWing
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit



class Projectile {
   
    
    private var originX:CGFloat
    private var originY:CGFloat
    private var name = "bullet"
    private var bulletnode:SKSpriteNode
    var bulletLevel:Int = 1
    private var char:Toon.Character?
    private let bulletMaker = BulletMaker()
    
    
    init (posX:CGFloat, posY:CGFloat, char:Toon.Character, bulletLevel: Int){
        originX = posX
        originY = posY 
        self.bulletLevel = bulletLevel
        self.char = char
        
        if let blevel = BulletMaker.Level(rawValue: bulletLevel){
            bulletnode = bulletMaker.make(level: blevel, char: char)
        }
        else{
            bulletnode = bulletMaker.make(level: .Level_1, char: char)
        }
        addPhysics()
       
    }
    
 /*   init(posX:CGFloat, posY:CGFloat, char:Toon.Character, bulletLevel: Int,texture: SKTexture) {
        
        originX = posX
        originY = posY + 35
        self.bulletLevel = bulletLevel
        self.bulletnode = BulletMaker().addBullet(sprite: (texture, CGSize(width: texture.size().width*4, height: texture.size().height*4)), dx: originX, dy: originY, zPos: 10)
        
        addPhysics()
    }*/
    
    /// Constructor by Dragon
    
    init(posX:CGFloat, posY:CGFloat,texture: SKTexture) {
        
        originX = posX
        originY = posY + 35
        bulletLevel = 1
        
        self.bulletnode = SKSpriteNode(texture: texture,size:  CGSize(width: 30, height: 30))
        self.bulletnode.blendMode = .add
        addPhysics()
    }
    
    func addPhysics() {
        
        bulletnode.userData = NSMutableDictionary()
        bulletnode.name = name
        bulletnode.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        bulletnode.physicsBody!.affectedByGravity = false
        bulletnode.physicsBody!.collisionBitMask = 0
        bulletnode.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        bulletnode.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by Magnetic Force
        bulletnode.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        bulletnode.physicsBody!.allowsRotation = false
        bulletnode.physicsBody!.velocity = CGVector(dx: 0, dy: screenSize.height)
    }
    
    func shoot() -> SKSpriteNode{
        
        let bullet = bulletnode.copy() as! SKSpriteNode
        bullet.power = getPowerValue()
        bullet.position = CGPoint(x: originX, y: originY)
        bullet.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
       
        return bullet
    }
    
    
    
    func generateTouchedEnemyEmmiterNode(x posX:CGFloat, y posY:CGFloat) -> SKEmitterNode?{
        
        guard let effect = SKEmitterNode(fileNamed: "bulling.sks") else { return nil}
        effect.position = CGPoint(x: posX, y: posY)
        effect.name = "emisorBulling"
        
        effect.run(SKAction.sequence([SKAction.wait(forDuration: Double(effect.particleLifetime)), SKAction.removeFromParent()]))
        return effect
    }
    
     func setPosX(x:CGFloat){
        originX = x
    }
    
     func setPosY(y:CGFloat){
        originY = y + 35
    }
    
     func setPos(x:CGFloat, y:CGFloat){
        originX = x
        originY = y + 35
    }
   
    
    func getPowerValue() -> CGFloat{
        return 25 + 5.0*CGFloat(bulletLevel)
    }
    func getBulletLevel() -> Int{
        return bulletLevel
    }
    
    func setBulletLevel(level: Int){
        bulletLevel = level
    }
   
    
     func upgrade() -> Bool{
        if bulletLevel >= 50 {
            return false
        }
        self.bulletLevel += 1
        return true
    }
    
  
    
}
