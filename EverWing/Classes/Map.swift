//
//  Map.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit

class Map: NSObject{
    
    deinit {
        print("Map has been deinitialized")
    }
    private var timer:Timer?
    
    var maptextures:[SKTexture]
    private var bottomTexture:SKTexture
    private var midTexture:SKTexture
    private var topTexture:SKTexture
    private var currIndex:Int
    
    var velocityMap:CGFloat = 0.01
    
    let top:SKSpriteNode
    let mid:SKSpriteNode
    let bottom:SKSpriteNode
    
    init(maps:[SKTexture], scene:SKScene){
        
        if maps.count < 3{
            fatalError("maps should have at least 3 textures.")
        }
        
        currIndex = randomInt(min: 0, max: maps.count - 3)
        maptextures = maps
        bottomTexture = maptextures[currIndex]
        midTexture = maptextures[currIndex + 1]
        topTexture = maptextures[currIndex + 2]
        currIndex = currIndex + 2
        
        let tsize = CGSize(width: screenSize.width, height: screenSize.width)
        
        mid = SKSpriteNode()
        mid.texture = midTexture
        
        mid.size = tsize
        mid.anchorPoint = CGPoint(x: 0.5, y: 0)
        mid.position = CGPoint(x: screenSize.width/2, y: mid.size.height/2)
        mid.zPosition = -5
        
        bottom = SKSpriteNode()
        bottom.texture = bottomTexture
        bottom.size = tsize
        bottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        bottom.position = CGPoint(x: screenSize.width/2, y: mid.position.y - mid.size.height)
        bottom.zPosition = -5
        
        top = SKSpriteNode()
        top.texture = topTexture
        top.size = tsize
        top.anchorPoint = CGPoint(x: 0.5, y: 0)
        top.position = CGPoint(x: screenSize.width/2, y: mid.position.y + mid.size.height)
        top.zPosition = -5
        // create function to start actrion for moving map
        
        (top.alpha, bottom.alpha, mid.alpha) = (1.0, 1.0, 1.0)
        
        scene.addChild(mid)
        scene.addChild(bottom)
        scene.addChild(top)
    }
    
    private func getNextTexture() -> SKTexture{
       
        if currIndex + 1 >= maptextures.count {
            currIndex = 0
            return maptextures[0]
        }
       
        currIndex = currIndex + 1
        return maptextures[currIndex]
    }
    
    /// Update velocity map
    func updateVelocityMap(velocity:CGFloat) {
        
        prepareToChangeScene()
        velocityMap = velocity
        print("Restart update velocity map \(velocityMap)")
        run()
    }
    
    func run(){
     
        // Timer 
        timer = Timer.scheduledTimer(timeInterval: velocityMap, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        // fade in
        let fin = SKAction.fadeAlpha(to: 1, duration: 0.5)
        top.run(fin)
        mid.run(fin)
        bottom.run(fin)
        
        // Action
        let moveDown = SKAction.moveBy(x: 0, y: -2, duration: velocityMap)
        mid.run(SKAction.repeatForever(moveDown))
        bottom.run(SKAction.repeatForever(moveDown))
        top.run(SKAction.repeatForever(moveDown))
    }
    
     @objc func update(){
        if (bottom.position.y <= -bottom.size.height){
            bottom.texture = getNextTexture()
            bottom.position.y = top.position.y + top.size.height
        }
        else if top.position.y <= -top.size.height{
            top.texture = getNextTexture()
            top.position.y = mid.position.y + mid.size.height
        }
        else if mid.position.y <= -mid.size.height{
            mid.texture = getNextTexture()
            mid.position.y = bottom.position.y + bottom.size.height
        }
    }
    
    func defeated() {
   
        top.removeFromParent()
        mid.removeFromParent()
        bottom.removeFromParent()
        timer?.invalidate()
    }
   
    func prepareToChangeScene(){
        guard let timer = timer else {
            return
        }
        print("Restart Timer")
        timer.invalidate()
    }

    
}
