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
    
    convenience init?(fontNamed font: String,andText text: String, andSize size: CGFloat,
                      fontColor:UIColor,withShadow shadow: UIColor,name:String? = "") {
        self.init(fontNamed: font)
        self.text = text
        self.fontSize = size
        self.numberOfLines = 0
        self.fontColor = fontColor
        verticalAlignmentMode = .center
        horizontalAlignmentMode = .center
        
        
        let shadowNode = SKLabelNode(fontNamed: font)
        shadowNode.name = name
        shadowNode.text =  self.text
        shadowNode.numberOfLines = 0
        shadowNode.zPosition = -1
        shadowNode.fontColor = shadow
        shadowNode.position = CGPoint(x: 1, y:-1)
        shadowNode.fontSize = self.fontSize
        shadowNode.verticalAlignmentMode = .center
        shadowNode.horizontalAlignmentMode = .center
        
        self.addChild(shadowNode)
    }
}
