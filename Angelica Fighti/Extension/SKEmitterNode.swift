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
    
    func contactEnemy(node:SKSpriteNode)->SKEmitterNode {
        
        let emiter =  SKEmitterNode(fileNamed: "Death")!
            emiter.position = node.position
       
        return emiter
    }
    
    func addBallMosterKing(node:SKSpriteNode) ->SKEmitterNode {
        
        let ball = SKEmitterNode(fileNamed: "Mouth")!
            ball.position = node.position
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
    
    
    
    // MARK: EMITTER BALL HAND ICE_QUEEN
    static var getBallHandIceQueen:SKEmitterNode  = {
        
        let emitter = SKEmitterNode(fileNamed: "ballColorFX")!
        emitter.name = "Emitter_\(UUID().uuidString)"
        emitter.alpha = 1
        emitter.zPosition = 100
        
        
        
        return emitter
    }()
}
