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


class GoblinEnemy:Enemy {
    
    private var currency:Currency = Currency(type: .Coin)

    let actionsStandBy = SKTexture(imageNamed: "enemy_ Armored")
 
    convenience required init(hp:CGFloat){
        self.init()
        
        name = "Enemy_Goblin"
        texture =  actionsStandBy
        size = CGSize(width: 100, height: 80)
        position = CGPoint(x: screenSize.maxX, y: screenSize.height - screenSize.height/3)
        userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        

        let action = SKAction.repeatForever(.sequence([
            .moveTo(x: screenSize.minX, duration: 2),
            .moveTo(x: screenSize.maxX, duration: 2),
            .moveTo(y: self.position.y-50, duration: 0.1),
            .run { self.attack(node: self, texture: nil) }
            ]))
        
        self.run(action)
        self.addHealthBar()
        self.initialSetupGoblin()
        
    }
    
    private func initialSetupGoblin() {
        
    
        self.hp = self.maxHp
        self.maxHp = self.maxHp
        self.name = "Enemy_Goblin"
        self.size = CGSize(width: 100, height: 80)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = PhysicsCategory.Player
        self.physicsBody?.allowsRotation = false
        self.physicsBody!.fieldBitMask = GravityCategory.Player
    }
}

class CofreEnemy:Enemy {
    
    private var currency:Currency = Currency(type: .Clover)

    let actionsStandBy = SKTextureAtlas().loadAtlas(name: "Cofre", prefix: nil)
    
    private var velocity = CGVector.zero

    convenience init(hp:CGFloat,speed:CGVector){
        self.init()
        
        name = "Enemy_Cofre"
        texture =  actionsStandBy.first!
        size = CGSize(width: 100, height: 80)
        position = CGPoint(x: random(min: screenSize.minX + size.width, max: screenSize.maxX - size.width) , y: screenSize.height)
        velocity = speed
        self.hp = hp
        self.maxHp = hp

        let action = SKAction.repeatForever(.sequence([
            .animate(with: actionsStandBy, timePerFrame: 0.1),
            
        ]))
        
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
    
    private var currency:Currency?
    
    private var velocity = CGVector.zero
    
    private var actionsDead:[SKTexture] = []
    
    private var enemy_regular_node:Enemy?
    
    private let minionSize = CGSize(width: screenSize.width*0.95/5, height: screenSize.width*0.95/5)
    
    convenience init(baseHp:CGFloat, speed:CGVector){
        self.init()

       // name = "Enemy_Regular_Box"
        name = "Enemy_Regular"
        
        let g = GKRandomDistribution.init(lowestValue: Int(screenSize.minX), highestValue: Int(screenSize.maxX-40)).nextInt()
        
        position = CGPoint(x: CGFloat(g) , y: screenSize.maxY - random(min: 0, max: 10))
        size =  CGSize(width: screenSize.width, height: screenSize.width*0.95/5)
       
        self.hp = baseHp
        self.maxHp = baseHp
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
        velocity =   speed
        currency  = Currency(type: Currency.CurrencyType.allCases.randomElement()!)
        actionsDead = SKTextureAtlas().loadAtlas(name: "default_regular_dead", prefix: "puff")
        enemy_regular_node = Enemy()
        enemy_regular_node?.size = self.size
        addPhysics()
        initialSetupRegular()
        
        setMinions()
    }
    
    private func addPhysics() {
    
    guard let enemy_regular_node = enemy_regular_node else{   return  }

    enemy_regular_node.hp = self.maxHp
    enemy_regular_node.maxHp = self.maxHp
    enemy_regular_node.name = "Enemy_Regular"
    enemy_regular_node.size = minionSize
    enemy_regular_node.physicsBody = SKPhysicsBody(rectangleOf: enemy_regular_node.size)
    enemy_regular_node.physicsBody!.isDynamic = true
    enemy_regular_node.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
    enemy_regular_node.physicsBody!.affectedByGravity = false
    enemy_regular_node.physicsBody!.collisionBitMask = 0
    enemy_regular_node.physicsBody?.allowsRotation = false
    enemy_regular_node.physicsBody!.velocity =  self.velocity
    enemy_regular_node.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by magnetic
    enemy_regular_node.addHealthBar()
    
}
    
    private func initialSetupRegular(){
       
        guard let enemy_regular_node = enemy_regular_node else{   return  }
        
        let unitX = roundf(Float(screenSize.width  / minionSize.width ))

        
        for x in 1...3{
            for i in x..<Int(unitX) {
                
                let node = enemy_regular_node.copy() as! Enemy
                
          /*      node.position = CGPoint(x: Bool.random() ?  -CGFloat(i+1) * minionSize.width : CGFloat(i+1) * minionSize.width,
                                        y: Bool.random() ?  -CGFloat(i+1) * minionSize.width : CGFloat(i+1) * minionSize.width)
                */
                node.position = CGPoint(x: screenSize.midX - CGFloat(CGFloat(i) * minionSize.width),
                                        y: screenSize.midY - CGFloat(CGFloat(x) * minionSize.width*2))
                
             /*   node.position = CGPoint(x: screenSize.midX/2 - CGFloat(CGFloat(i) * minionSize.width),
                                        y: screenSize.midY - CGFloat(CGFloat(x) * minionSize.width*2))*/
                
            //    let path = sinePath(in: CGRect(x: 0, y: 0, width: 100 , height: 200), count: Int.random(in: 50...100))
                
                
              //  node.run(.follow(path.cgPath,asOffset: true,orientToPath: false, speed: 200))
               
                
                self.addChild(node)
            }
        }
        
       /* for i in 0..<5{
            
            if i == 0 {
                
                let node = enemy_regular_node.copy() as! Enemy
                self.addChild(node)
                
                continue
            }
            else{
                let lnode = enemy_regular_node.copy() as! Enemy
                lnode.position.x = CGFloat(-i)*minionSize.width
                lnode.position.y = CGFloat(-i)+(minionSize.width*2)
               
                let rnode = enemy_regular_node.copy() as! Enemy
                rnode.position.x = CGFloat(i)*minionSize.width
                rnode.position.y = CGFloat(i)+minionSize.width
                self.addChild(lnode)
                self.addChild(rnode)
                
                SKAction.repeatForever(.sequence([
                    .wait(forDuration: 0.005),
                    .run {
                        lnode.move(dir: .Random, node: lnode)
                        rnode.move(dir: .Random, node: rnode)
                    },
                    .wait(forDuration: 0.005),
                    .run {
                        lnode.move(dir: .Random, node: lnode)
                        rnode.move(dir: .Random, node: rnode)
                    }
                ]))
                
            }
            
        }*/
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
        sknode.run(.sequence([SKAction.scale(by: 2, duration: 0.1),.removeFromParent()]))
    }
}

