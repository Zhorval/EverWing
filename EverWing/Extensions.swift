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


enum GameState{
    case Spawning  // state which waves are incoming
    case BossEncounter // boss encounter
    case WaitingState // Need an state
    case Attack // state when pick magnet
    case Running
    case NoState
    case Start
}

enum ContactType{
    case HitByEnemy
    case BallEnemyByToon
    case ToonByClover
    case ToonByMagnet
    case ToonByFlower
    case ToonByMushroom
    case EnemyGotHit
    case PlayerGetCoin
    case PlayerGetGem
    case HitByDragon
    case HitByEggs
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

extension CGFloat {
    
    
    
    func isDevice()->Self {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 25
        case .phone,.unspecified,.carPlay,.mac,.tv:
            return 12
        @unknown default:
            return 12
        }
    }
}



extension Bool {
    mutating func toggle() {
        self = !self
    }
}


/*RANDOM FUNCTIONS */

func random() -> CGFloat {
    return CGFloat(CGFloat(Float(arc4random()) / Float(0xFFFFFFFF)))
}

func random( min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt( min: Int, max: Int) -> Int{
    //return randomInt() * (max - min ) + min
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}

