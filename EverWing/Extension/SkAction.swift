//
//  SkAction.swift
//  EverWing
//
//  Created by Pablo  on 27/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit

extension SKAction {
    
    static let blink = SKAction.repeatForever(sequence([.fadeOut(withDuration: 1),
                                                        .fadeIn(withDuration: 1),
                                                        .fadeAlpha(by: 0, duration: 1)]))
    
    static let upDown  = { (value:CGFloat,time:TimeInterval) -> (SKAction) in
        
        let action = SKAction.repeatForever(SKAction.sequence([
        SKAction.move(by: CGVector(dx: 0, dy: value), duration: time),
        SKAction.move(by: CGVector(dx: 0, dy: -value), duration: time)]))
        return action
    }
    
    static let wait = SKAction.wait(forDuration: 2)

    
    static let moveWings = SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: screenSize.width * 0.097, duration: 0.1), SKAction.resize(toWidth: screenSize.height * 0.105, duration: 0.15)]))
    
}
