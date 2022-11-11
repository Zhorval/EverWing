//
//  GoblinModel.swift
//  Angelica Fighti
//
//  Created by Pablo  on 31/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class ArmoredEnemy:Enemy {
 
    convenience required init(hp:CGFloat,gameInfo:GameInfoDelegate){
        self.init(hp: hp)
        
        delegate = gameInfo
        name = "Enemy_Armored"
        texture =  SKTexture(imageNamed: "enemy_ Armored")
        size = CGSize(width: 100, height: 80)
        position = CGPoint(x: screenSize.maxX, y: screenSize.height - screenSize.height/3)
        self.hp = hp
        self.maxHp = hp
        
        let action = SKAction.repeatForever(.sequence([
            .moveTo(x: screenSize.minX, duration: 2),
            .moveTo(x: screenSize.maxX, duration: 2),
            .moveTo(y: self.position.y-50, duration: 0.1),
            .run {
                self.attack(node: self, texture: self.texture!) }
            ]))
        
        self.initialSetupArmored()
        self.addHealthBar()
    
        self.run(action)
        
    }
    
  private func initialSetupArmored() {
      
        
      self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.collisionBitMask = PhysicsCategory.Player
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.fieldBitMask = GravityCategory.Player
    }
}

class CofreEnemy:Enemy {
    

    let actionsStandBy = SKTextureAtlas().loadAtlas(name: "Cofre", prefix: nil)
    
    //var velocity = CGVector.zero

    convenience init(hp:CGFloat,speed:CGVector){
        self.init()
        
        name = "Enemy_Cofre"
        texture =  actionsStandBy.first!
        size = CGSize(width: 100, height: 80)
        position = CGPoint(x: random(min: screenSize.minX + size.width, max: screenSize.maxX - size.width) , y: screenSize.height)
        
        velocity = speed
        self.hp = hp
        self.maxHp = hp

        let action = SKAction.repeatForever(.sequence([ .animate(with: actionsStandBy, timePerFrame: 0.1),]))
        
        self.run(action)
        self.addHealthBar()
        self.initialSetupCofre()
    }
    
    private func initialSetupCofre() {        
    
        self.hp = self.maxHp
        self.maxHp = self.maxHp
        self.name = "Enemy_Cofre"
        self.size = CGSize(width: 100, height: 80)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = PhysicsCategory.Player
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.velocity = velocity
        self.physicsBody!.fieldBitMask = GravityCategory.None
    }
}

class Dragon:Enemy {
    
    deinit{
        print("Deinit Dragon")
    }
    
    convenience init(hp:CGFloat,type:DragonType){
        
        self.init()
        self.texture = type.texture.first!
        self.name = type.rawValue
        size = CGSize(width: 50, height: 75)
        self.hp = hp
        self.maxHp = hp
        self.run(.repeatForever(.animate(with: type.texture, timePerFrame: 0.1)))
        
        initialSetupDragon()
        addHealthBar()
    }
    
     func initialSetupDragon() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.Imune
         
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = PhysicsCategory.Enemy
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.allowsRotation = false
    }
    
}

class RegularEnemy:Enemy{
    
    
   // private var velocity:CGVector?
    
   // var actionsDead:[SKTexture] = SKTextureAtlas().loadAtlas(name: "default_regular_dead", prefix: "puff")
    
    
    private let minionSize = CGSize(width: screenSize.width*0.95/5, height: screenSize.width*0.95/5)
    
    convenience init(baseHp:CGFloat, speed:CGVector, type:T){
        self.init()
        
        enemyType = T.Regular
        enemyModel = Enemy()
        name = "Enemy_Regular"
        
       // let g = GKRandomDistribution.init(lowestValue: Int(screenSize.minX-15), highestValue: Int(screenSize.maxX-40)).nextInt()
        
        position = CGPoint(x: 15 , y: 0)
        size =  CGSize(width: screenSize.width, height: screenSize.width*0.95/5)
       
        self.hp = baseHp
        self.maxHp = hp * 0.05
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
        velocity =  speed
        enemyModel?.size = self.size
        enemyModel?.position =  self.position
        addPhysics()
        initialSetupRegular()
        setMinions()
    }
    
    private func addPhysics() {
    
        guard let enemy_regular_node = enemyModel else{   return  }

        enemy_regular_node.hp = self.hp
        enemy_regular_node.maxHp = self.maxHp
        enemy_regular_node.name = "Enemy_Regular"
        enemy_regular_node.size = minionSize
        enemy_regular_node.physicsBody = SKPhysicsBody(rectangleOf: enemy_regular_node.size)
        enemy_regular_node.physicsBody!.isDynamic = true
        enemy_regular_node.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        enemy_regular_node.physicsBody!.affectedByGravity = false
        enemy_regular_node.physicsBody!.collisionBitMask = 0 | PhysicsCategory.Imune
        enemy_regular_node.physicsBody?.allowsRotation = false
        enemy_regular_node.physicsBody!.velocity =  self.velocity
        enemy_regular_node.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by magnetic
        enemy_regular_node.addHealthBar()
        
    }
    
    private func initialSetupRegular(){
       
        guard let enemy_regular_node = enemyModel else{   return  }
        
        let unitX = roundf(Float(screenSize.width  / minionSize.width))

        let margin = (screenSize.width - (minionSize.width *  CGFloat(unitX))) / 2
        
        for i in 0..<Int(unitX) {
            
            let node = enemy_regular_node.copy() as! Enemy
    
            let dx =  margin + (minionSize.width * (CGFloat(i)))
           
            node.position = CGPoint(x: dx,y: screenSize.height)
            
            self.addChild(node)
        }
    }
    
    private func  setMinions(){
        
        func modifyHP(sknode: Enemy, multiplier: CGFloat){
            sknode.hp = self.maxHp * multiplier
            sknode.maxHp = self.maxHp * multiplier
        }
        
        for enemy in self.children {
            
            guard let enemySK = enemy as? Enemy ,
                  let enemyNameRandom = Global.Regular.allCases.randomElement()?.rawValue else { return }
            
            let textures = SKTextureAtlas().loadAtlas(name: enemyNameRandom, prefix: nil)
            
                enemySK.name = "\(enemySK.name! + "_" + enemyNameRandom)"
                enemySK.size = CGSize(width: screenSize.width * 0.1 , height: screenSize.height * 0.1)
                enemySK.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1)))
                modifyHP(sknode: enemySK, multiplier: 2.0)
        }
            self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
    }
    
    func defeated(sknode:SKSpriteNode){
        sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
        sknode.position.y -= 50
        sknode.run(.sequence([.removeFromParent()]))
    }
    

}

class BuitreEnemy:Enemy {
    
    let atlasIdle = SKTextureAtlas().loadAtlas(name: "Buitre_Idle", prefix: nil)
    let buitre_egg:SKSpriteNode  =  {
        
        let eggs = SKSpriteNode(imageNamed: "buitre_egg")
        eggs.name = "halcon_egg"
        eggs.position = .zero
        eggs.physicsBody = SKPhysicsBody(circleOfRadius: eggs.size.width/2)
        eggs.physicsBody?.affectedByGravity = true
        eggs.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        eggs.physicsBody?.collisionBitMask = 0
        return eggs
    }()
    
    
    let direction = Bool.random()
    
       convenience required init(hp:CGFloat,gameInfo:GameInfoDelegate){
           self.init(hp: hp)
           
           delegate = gameInfo
           name = "Enemy_Buitre"
           size = CGSize(width: 100, height: 80)
           position = CGPoint(x: direction ?  screenSize.maxX : screenSize.minX, y: screenSize.height - 150)
           self.hp = hp
           self.maxHp = hp
           
           self.xScale = !direction ? -1 : 1
           self.run(.repeatForever(.animate(with: atlasIdle, timePerFrame: 0.5)))
           
           let action = SKAction.repeatForever(.sequence([
            .move(to: CGPoint(x: screenSize.width/2, y: screenSize.height/2), duration: 3),
            .wait(forDuration: 1),
            .run {
                self.addChild(self.buitre_egg)
            },
            .moveTo(x: direction ?  screenSize.minX-self.size.width : screenSize.maxX + self.size.width, duration: 3),
            .removeFromParent()
               ]))
           
           self.initialSetupArmored()
           self.addHealthBar()
           self.run(action)
           
       }
       
     private func initialSetupArmored() {
         
           
           self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
           self.physicsBody?.isDynamic = true
           self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
           self.physicsBody?.affectedByGravity = false
           self.physicsBody?.collisionBitMask = PhysicsCategory.Player
           self.physicsBody?.fieldBitMask = GravityCategory.Player
       }
    
}


