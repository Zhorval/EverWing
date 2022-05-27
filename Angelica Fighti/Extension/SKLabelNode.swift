//
//  SKLabelNode.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit


extension SKLabelNode {
    
    convenience init?(fontNamed font: String,andText text: String, andSize size: CGFloat,withShadow shadow: UIColor,name:String? = "") {
        self.init(fontNamed: font)
        self.text = text
        self.fontSize = size
        
        
        let shadowNode = SKLabelNode(fontNamed: font)
        shadowNode.name = name
        shadowNode.text =  self.text
        shadowNode.zPosition = self.zPosition - 1
        shadowNode.fontColor = .black

        shadowNode.position = CGPoint(x: 2, y: -1)
        shadowNode.fontSize = self.fontSize
        shadowNode.alpha = 0.5
        
        self.addChild(shadowNode)
    }
}
