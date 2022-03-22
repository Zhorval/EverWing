//
//  Extensions.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import AVFoundation
import SpriteKit
import UIKit



protocol ProjectileDelegate{
    
    func add(sknode: SKNode)
}

enum GameState{
    case Spawning  // state which waves are incoming
    case BossEncounter // boss encounter
    case WaitingState // Need an state
    case NoState
    case Start
}

enum ContactType{
    case HitByEnemy
    case EnemyGotHit
    case PlayerGetCoin
    case HitByCofre
    case HitByDragon
    case Immune
    case None
}


extension SKSpriteNode {
    
    func destroy(){
        self.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.removeAllActions()
        self.removeFromParent()
    }
    
    func shadowNode(nodeName:String) -> SKEffectNode{
        
        let myShader = SKShader(fileNamed: "monogradient")
        
        let effectNode = SKEffectNode()
        effectNode.shader = myShader
        effectNode.shouldEnableEffects = true
        effectNode.addChild(self)
        effectNode.name = nodeName
        return effectNode
    }
}

extension SKNode{
    var power:CGFloat!{
        get {
            
            if let v = userData?.value(forKey: "power") as? CGFloat{
                return v
            }
            else{
                print ("Extension SKNode Error for POWER Variable: ",  userData?.value(forKey: "power") ?? -1.0 )
                return -9999.0
            }
            
        }
        set(newValue) {
            userData?.setValue(newValue, forKey: "power")
        }
    }
    
    func run(action: SKAction, optionalCompletion: (() -> Void)?){
        guard let completion = optionalCompletion else {
            run(action)
            return
        }
        
        run(SKAction.sequence([action, SKAction.run(completion)]))
        
    }
    
    
    
}


extension SKScene{
    func removeUIViews(){
            for view in (view?.subviews)! {
                view.removeFromSuperview()
            }
            
    }
    
    func recursiveRemovingSKActions(sknodes:[SKNode]){
        
        for childNode in sknodes{
            childNode.removeAllActions()
            if childNode.children.count > 0 {
                recursiveRemovingSKActions(sknodes: childNode.children)
            }
            
        }
        
    }
}



extension SKLabelNode{
    func shadowNode(nodeName:String) -> SKEffectNode{
        
        let myShader = SKShader(fileNamed: "monogradient")
        
        let effectNode = SKEffectNode()
        effectNode.shader = myShader
        effectNode.shouldEnableEffects = true
        effectNode.addChild(self)
        effectNode.name = nodeName
        return effectNode
    }
}

/*RANDOM FUNCTIONS */

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random( min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt( min: Int, max: Int) -> Int{
    //return randomInt() * (max - min ) + min
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}
