//
//  Projectile.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit

struct Projectile {
    
    private var originX:CGFloat
    private var originY:CGFloat
    private var name = "bullet" // Do not change it.
    private var bulletnode:SKSpriteNode
    private var bulletLevel:Int
    private let bulletMaker = BulletMaker()
    
    
    init (posX:CGFloat, posY:CGFloat, char:Toon.Character, bulletLevel: Int){
        originX = posX
        originY = posY + 35
        self.bulletLevel = bulletLevel
        
        if let blevel = BulletMaker.Level(rawValue: bulletLevel){
            bulletnode = bulletMaker.make(level: blevel, char: char)
        }
        else{
            fatalError("Invalid bullet level. Returning 1")
            bulletnode = bulletMaker.make(level: .Level_1, char: char)

        }
        addPhysics()
       
    }
    
    init(posX:CGFloat, posY:CGFloat, char:Toon.Character, bulletLevel: Int,texture: SKTexture) {
        
        originX = posX
        originY = posY + 35
        self.bulletLevel = bulletLevel
       
        self.bulletnode = BulletMaker().addBullet(sprite: (texture, CGSize(width: texture.size().width*4, height: texture.size().height*4)), dx: originX, dy: originY, zPos: 10)
        
        addPhysics()
    }
    
    /// Constructor by Dragon
    
    init(posX:CGFloat, posY:CGFloat,texture: SKTexture) {
        
        originX = posX
        originY = posY + 35
        bulletLevel = 0        
        
        self.bulletnode = SKSpriteNode(texture: texture,size:  CGSize(width: 30, height: 30))
        self.bulletnode.blendMode = .add
        addPhysics()
    }
    
    func addPhysics() {
        
        bulletnode.userData = NSMutableDictionary()
        bulletnode.name = name
      //  bulletnode.setScale(0.25)
        bulletnode.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        bulletnode.physicsBody!.affectedByGravity = false
        bulletnode.physicsBody!.collisionBitMask = 0
        bulletnode.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        bulletnode.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by Magnetic Force
        bulletnode.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Imune
        bulletnode.physicsBody!.allowsRotation = false
        bulletnode.physicsBody!.velocity = CGVector(dx: 0, dy: 2000)
    }
    
    func shoot() -> SKSpriteNode{
        
        let bullet = bulletnode.copy() as! SKSpriteNode
        bullet.power = getPowerValue()
        bullet.position = CGPoint(x: originX, y: originY)
        bullet.run(SKAction.scale(to: 1.0, duration: 0.2))
              bullet.run(SKAction.sequence([SKAction.wait(forDuration: 0.38), SKAction.removeFromParent()]))
        return bullet
    }
    
    
    /// Change texture projectle
    mutating func changeTextureProjectile(texture:SKTexture) {
        self.bulletnode.texture = texture
    }
    
    func generateTouchedEnemyEmmiterNode(x posX:CGFloat, y posY:CGFloat) -> SKEmitterNode{
        
        let effect = SKEmitterNode(fileNamed: "bulling.sks")
        effect!.position = CGPoint(x: posX, y: posY)
        effect?.name = "emisorBulling"
        
        effect!.run(SKAction.sequence([SKAction.wait(forDuration: Double(effect!.particleLifetime)), SKAction.removeFromParent()]))
        return effect!
    }
    
    
    mutating func setPosX(x:CGFloat){
        originX = x
    }
    
    mutating func setPosY(y:CGFloat){
        originY = y + 35
    }
    
    mutating func setPos(x:CGFloat, y:CGFloat){
        originX = x
        originY = y + 35
    }
    
    func printPosition(){
        print ("This: ", originX, originY)
    }
    
    func getPowerValue() -> CGFloat{
        return 25 + 5.0*CGFloat(bulletLevel)
    }
    func getBulletLevel() -> Int{
        return bulletLevel
    }
    
    mutating func setBulletLevel(level: Int){
        self.bulletLevel = level
        print("Level Bullet \(bulletLevel)")
    }
    
    mutating func upgrade() -> Bool{
        print("Level bullet \(bulletLevel)")
        if bulletLevel >= 50 {
            return false
        }
        self.bulletLevel += 1
        return true
    }
    
}
