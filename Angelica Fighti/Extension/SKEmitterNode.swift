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
}
