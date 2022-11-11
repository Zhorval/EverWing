//
//  SKEmitterNode.swift
//  Angelica Fighti
//
//  Created by Pablo  on 9/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit


extension SKEmitterNode {
    
    func contactEnemy(node:SKSpriteNode)->SKEmitterNode? {
        
        guard let emiter =  SKEmitterNode(fileNamed: "Death") else { return nil}
        emiter.position = emiter.convert(node.position, to: node) 
       
        return emiter
    }
    
    func addBallMosterKing(node:SKSpriteNode) ->SKEmitterNode {
        
        let ball = SKEmitterNode(fileNamed: "Mouth")!
            ball.position =  node.position
            ball.name = "Enemy_" + UUID().uuidString
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.particleSize.width)
            ball.physicsBody!.isDynamic = false
            ball.physicsBody!.affectedByGravity = true
            ball.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
            ball.physicsBody!.contactTestBitMask = PhysicsCategory.Player
            ball.physicsBody!.fieldBitMask = GravityCategory.Player
            ball.physicsBody!.collisionBitMask = 0
        
        return ball
    }
    
    /// Contact ball Enemy Boss with Toon
    func contactBallHandEnemy(sideEffectX:Bool,position:CGPoint) -> SKEmitterNode {
       
      
            
        let emitter =  SKEmitterNode(fileNamed: "SpikeArm")!
            emitter.particleSpeed  = sideEffectX ? -150 : 150
            emitter.name = "Enemy_Ball_\(UUID().uuidString)"
            emitter.particleRotation = .pi
            emitter.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            emitter.physicsBody?.isDynamic = true
            emitter.physicsBody?.affectedByGravity = false
            emitter.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
            emitter.physicsBody?.contactTestBitMask =  0
            emitter.physicsBody?.collisionBitMask =  0
            emitter.physicsBody?.velocity = CGVector(dx: sideEffectX ? -50 : 50, dy: -100)
            emitter.position = position
           
        return emitter
    }
    
    
    
    // MARK: EMITTER BALL HAND ICE_QUEEN
    static var getBallHandIceQueen:SKEmitterNode?  = {
        
        guard let emitter = SKEmitterNode(fileNamed: "ballColorFX") else { return nil}
        emitter.name = "Emitter_\(UUID().uuidString)"
        emitter.alpha = 1
        emitter.zPosition = 100
        
        return emitter
    }()
}
