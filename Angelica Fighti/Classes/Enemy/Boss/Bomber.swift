//
//  Bomber.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit
import GameplayKit

class Bomber<T:BossTypeProtocol>:Enemy{
    
    private var currency:Currency = Currency(type: .Coin)
    private var typeBoss:T?
    
    private var actionsStandBy:[SKTexture] {
        
        return  typeBoss!.getTextures(type: typeBoss!.getType(),prefix: "Idle_")

    }
   
    private var gameToon = GameInfo()
    
    convenience init(hp:CGFloat,typeBoss:T){
        self.init()
        
        
        self.typeBoss = typeBoss
        name = "Enemy_Boss"
        texture =  actionsStandBy.first // global.getMainTexture(main: .Boss_1)
        size = CGSize(width: 180, height: 130)
        position = CGPoint(x: screenSize.size.width/2, y: screenSize.size.height - size.height/2)
        alpha = 0
        userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        
        currency  = Currency(type: .Coin)

        
        // Set initial alpha
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.Imune
        self.physicsBody!.friction = 0
        self.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Wall
        self.physicsBody!.restitution = 1
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.linearDamping = 1
        self.physicsBody!.fieldBitMask = GravityCategory.None
        
       
        // adding healthbar
        self.addHealthBar()
        self.initialSetup()
        self.attack()
        setAnimation()
    }
    
  
    
    private func setAnimation(){
        
        
        // Body Action
       
        func randomPoint() -> CGPoint {
            
            let screenRect = UIScreen.main.bounds

            let xPos = arc4random() % UInt32(screenRect.size.width)
            let yPos = arc4random() % UInt32(screenRect.size.height)

            return CGPoint(x: CGFloat(xPos), y: CGFloat(yPos))
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: screenSize.maxY))
        for _ in 0...20 {
            
            path.addCurve(to: randomPoint(), controlPoint1: randomPoint(), controlPoint2: randomPoint())
        }
        
        self.run(.repeatForever(.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200)))
    }
  
}


