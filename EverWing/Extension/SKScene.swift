//
//  SKScene.swift
//  EverWing
//
//  Created by Pablo  on 6/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit


protocol ProtocolEffectBlur {
    var blurNode:SKEffectNode { get set }
}

extension SKScene {
   
    
    // MARK: SCENE ADD CIGaussianBlur EFFECT
    // PARAMS:  @blurNode:SKEffectNode variable with contructor from protocol ProtocolEffectBlur

    func blurScene(blurNode:SKEffectNode) {
        
        blurNode.name = "blurNode"
        let blur = CIFilter(name: "CIGaussianBlur",    parameters: ["inputRadius": 50])
        blurNode.filter = blur
        self.shouldEnableEffects = true
        scene?.isPaused = true
        for node in self.children {
            node.removeFromParent()
            blurNode.addChild(node )
        }
        self.addChild(blurNode)
    }
    
    // MARK: SCENE REMOVE CIGaussianBlur EFFECT
    // PARAMS:  @blurNode:SKEffectNode variable with contructor from protocol ProtocolEffectBlur
    
    
    // MARK: CREATE EFFECT RAY SUN ROTATING
    // @params   point: Center point effect
    //           size:  Size effect
    func raySunRotating(point:CGPoint,size:CGSize) -> SKSpriteNode{
        
        let sun = SKSpriteNode(imageNamed: "bgSun")
            sun.blendMode = .add
            sun.name = "bgSun"
            sun.position = point
            sun.size = size
        
        
        let sunRotate = SKSpriteNode(imageNamed: "bgSunRotate")
            sunRotate.blendMode = .add
            sunRotate.name = "bgSunRotating"
            sunRotate.position = .zero
            sunRotate.size = size
            sunRotate.run(.repeatForever(.rotate(byAngle: .pi, duration: 0.1)))
            sun.addChild(sunRotate)
        
        return sun
    }
    
    
    // MARK: CREATE BG BLACK INTO SCENE
    func backgroundBlack(withSpinnerActive spinner:Bool)  {
        
        if childNode(withName: "backgroundBlack") != nil {
             return
        }
        
        let bgBlack = SKSpriteNode(color: .black.withAlphaComponent(0.8), size: CGSize(width: screenSize.width, height: screenSize.height))
        bgBlack.anchorPoint = CGPoint(x: 0, y: 0)
        bgBlack.name = "backgroundBlack"
        
        if spinner {
            let progressCircle = SKSpriteNode(imageNamed: "progressCircle")
            progressCircle.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            
            progressCircle.run(.sequence([.rotate(byAngle: .pi/2, duration: 2),.removeFromParent()]))
            bgBlack.addChild(progressCircle)

        }
        
        self.addChild(bgBlack)
    }
}
