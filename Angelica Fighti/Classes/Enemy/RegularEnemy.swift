//
//  RegularEnemy.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit
import GameplayKit



class RegularEnemy:Enemy{
    
    
    private var currency:Currency = Currency(type: .Coin)
    private var velocity = CGVector.zero
    
    private var actionsDead:[SKTexture] = []
    private var enemy_regular_node:Enemy?
    var gameinfo = GameInfo()
    var delegate:GameInfoDelegate?

    
    private let minionSize = CGSize(width: screenSize.width*0.95/5, height: screenSize.width*0.95/5)
    
    convenience init(baseHp:CGFloat, speed:CGVector){
        self.init()

        name = "Enemy_Regular_Box"
        
        let g = GKRandomDistribution.init(lowestValue: 40, highestValue: Int(screenSize.maxX-40)).nextInt()
        
        position = CGPoint(x: CGFloat(g) , y: screenSize.maxY - random(min: 0, max: 10))
        size =  CGSize(width: screenSize.width, height: screenSize.width*0.95/5)
       
        userData = NSMutableDictionary()
        self.hp = baseHp
        self.maxHp = baseHp
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
        velocity = speed
        currency  = Currency(type: .Coin)
        
        actionsDead = SKTextureAtlas().loadAtlas(name: "default_regular_dead", prefix: "puff")
        enemy_regular_node = Enemy()
        enemy_regular_node!.size = self.size
      
        initialSetupRegular()
        setMinions()
    }
    
    private func initialSetupRegular(){
        
        guard let enemy_regular_node = enemy_regular_node else{   return  }
    
        enemy_regular_node.userData = NSMutableDictionary()
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
        enemy_regular_node.physicsBody!.velocity = self.velocity
        enemy_regular_node.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by magnetic
        enemy_regular_node.addHealthBar()
            
        for x in 1...4{
            for i in x..<4 {
                
                let node = enemy_regular_node.copy() as! Enemy
                
                node.position = CGPoint(x: Bool.random() ?  -CGFloat(i+1) * minionSize.width : CGFloat(i+1) * minionSize.width,
                                        y: Bool.random() ?  -CGFloat(i+1) * minionSize.width : CGFloat(i+1) * minionSize.width)
                
             /*   node.position = CGPoint(x: screenSize.midX/2 - CGFloat(CGFloat(i) * minionSize.width),
                                        y: screenSize.midY - CGFloat(CGFloat(x) * minionSize.width*2))
                */
                let path = sinePath(in: CGRect(x: 0, y: 0, width: 100 , height: 200), count: Int.random(in: 50...100))
                
                node.run(.follow(path.cgPath,asOffset: true,orientToPath: false, speed: 200))
               
                
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
    
     func addcofre() {
       
            let cofre = SKSpriteNode()
             cofre.name = "cofre"
             cofre.position = CGPoint(x: 200, y: 10)
         
            let emiter = SKEmitterNode(fileNamed: "trail.sks")
            cofre.physicsBody = SKPhysicsBody(circleOfRadius:  (cofre.size.width)/2)
            cofre.physicsBody!.isDynamic = true
            cofre.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
            cofre.physicsBody!.contactTestBitMask = PhysicsCategory.Player
            cofre.physicsBody!.affectedByGravity = false
            cofre.physicsBody!.collisionBitMask = 0
            cofre.physicsBody?.allowsRotation = false
            cofre.physicsBody!.velocity = self.velocity
            emiter?.particlePosition = cofre.position
            emiter?.zPosition = -1
            cofre.addChild(emiter!)
            
            cofre.run(.sequence([.wait(forDuration: 4),.run({
                emiter?.removeFromParent()
                cofre.removeFromParent()
            })]))
        addChild(cofre)
    }
    
    
    private func setMinions(){
        
        func modifyHP(sknode: Enemy, multiplier: CGFloat){
            sknode.hp = self.maxHp * multiplier
            sknode.maxHp = self.maxHp * multiplier
        }
        
        for enemy in self.children {
            
            guard let enemySK = enemy as? Enemy else { return}
            
            
            guard let enemyNameRandom = Global.Regular.allCases.randomElement()?.rawValue else { return }
            let textures = SKTextureAtlas().loadAtlas(name: enemyNameRandom, prefix: "enemy_")
            
            if textures.count > 0 {
            
                enemySK.size = CGSize(width: screenSize.width * 0.1 , height: screenSize.height * 0.1)
                enemy.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.5)))
                modifyHP(sknode: enemySK, multiplier: 2.0)
            }
        }
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
    }
    
     func defeated(sknode:SKSpriteNode){
        sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
        sknode.position.y -= 50
        sknode.run(SKAction.scale(by: 2, duration: 0.1))
        
        sknode.run( SKAction.sequence([SKAction.animate(with: actionsDead, timePerFrame: 0.02),SKAction.run {
            sknode.removeFromParent()
            }]))
    }
}
