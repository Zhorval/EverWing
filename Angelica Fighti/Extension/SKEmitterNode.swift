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
    
    
    // Add coin with contact enemy
    
    func contactEnemy(node:SKSpriteNode)->SKEmitterNode {
        
        let hitparticle = SKEmitterNode()
        hitparticle.particleTexture = global.getMainTexture(main: .Gold)
        hitparticle.position = node.position
        hitparticle.particleLifetime = 1
        hitparticle.particleBirthRate = 10
        hitparticle.numParticlesToEmit  = 30
        hitparticle.emissionAngleRange = 180
        hitparticle.particleScale = 0.2
        hitparticle.particleScaleSpeed = -0.2
        hitparticle.particleSpeed = 100
        return hitparticle
    }
}
