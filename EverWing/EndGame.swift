//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit

class EndGame: SKScene {
    deinit{
        print ("ENDGAME CLEANED")
    }
    
    let managed = ManagedDB.shared.context
    
    var collectedCoins:Int = 0
    
    let currentToon = AccountInfo().getCurrentToon()
    
    override func didMove(to view: SKView) {
        
        
        guard let path = Bundle.main.path(forResource: "userinfo", ofType: "plist") else {
            fatalError("plist is nil - Check AccountInfo.swift")
        }

        
        guard let virtualPlist = NSMutableDictionary(contentsOfFile: path) else {
            fatalError("plist is nil - Check AccountInfo.swift")
        }
      
     
        guard let dataCoin:Int = virtualPlist.value(forKey: "Coin") as? Int else{
            print ("ERROR001: EndGame error")
            return
        }
        
        
       
        let newCoinAmount = collectedCoins + dataCoin
        
        virtualPlist.setValue(newCoinAmount, forKey: "Coin")
        
        /****************   SAVE DB DATA ***/
        
        if !saveDbCoin(newCoinAmount: newCoinAmount) { fatalError() }
         
         /* ********************* */
        
        if !virtualPlist.write(toFile: path, atomically: true){
            print("Error002: FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN EndGame")
        }
        let bg = SKSpriteNode()
            bg.texture = global.getMainTexture(main: .Main_Menu_Background_1)
            bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
            bg.size = CGSize(width: screenSize.width, height: screenSize.height)
            bg.zPosition = -10
            bg.name = Global.Main.Main_Menu_Background_1.rawValue
        self.addChild(bg)
        
        
        
        if let textureCurrentToon = currentToon.getTextureCurrentToon()?.rawValue {
            let sequenceAction = SKAction.sequence([
                .moveBy(x: 0, y: -10, duration: 1),
                .moveBy(x: 0, y: 10, duration: 1),
            ])
            
            let sprite = SKSpriteNode(imageNamed: textureCurrentToon)
            sprite.position = CGPoint(x: screenSize.midX, y: screenSize.maxY - sprite.size.height/1.5)
            sprite.run(.repeatForever(sequenceAction))
            addChild(sprite)
        }
           
        
        let sequenceAction = SKAction.sequence([
            .scale(to: 1.5, duration: 1),
            .scale(to: 0.9, duration: 1)
            
        ])
        let newGame = SKLabelNode(fontNamed: "Cartwheel", andText: "Game over", andSize: 50, fontColor: .yellow, withShadow: .black)
            newGame?.name = "gameOver"
            newGame?.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            newGame?.zPosition = 10
            newGame?.run(.repeatForever(sequenceAction  ))
        self.addChild(newGame!)
        
        /* -------------------------- Start label coins ------------------------------------------------------*/

        let coinsLabel = SKLabelNode(fontNamed: "Cartwheel", andText: "Coins", andSize: 30, fontColor: .white, withShadow: .black)
        coinsLabel?.name = "totalCoin"
        coinsLabel?.zPosition = 10
        coinsLabel?.position = CGPoint(x: screenSize.midX-50, y: screenSize.midY-50)
        coinsLabel?.run(AVAudio().getAction(type: .Result_Coin))
        self.addChild(coinsLabel!)
        
        // Label and icons total coin
        let totalCoin = SKLabelNode(fontNamed: "Cartwheel", andText: "\(collectedCoins)", andSize: 30, fontColor: .yellow, withShadow: .black)
            totalCoin?.name = "collectionCoin"
            totalCoin?.zPosition = 10
            totalCoin?.position = CGPoint(x: screenSize.midX+50, y: screenSize.midY-50)
            self.addChild(totalCoin!)
        
        // Label and icons total coin
        let iconCoin = SKSpriteNode(imageNamed: "coin")
            iconCoin.size = CGSize(width: 40, height: 40)
            iconCoin.name = "iconCoin"
            iconCoin.zPosition = 10
        iconCoin.position = CGPoint(x: screenSize.midX+100, y: screenSize.midY  - iconCoin.frame.height)
            self.addChild(iconCoin)
        /* -------------------------- End label coins ------------------------------------------------------*/
        
        /* -------------------------- Start label score ------------------------------------------------------*/
        let scoreLabel = SKLabelNode(fontNamed: "Cartwheel", andText: "Score", andSize: 30, fontColor: .white, withShadow: .black)
        scoreLabel?.name = "totalScore"
        scoreLabel?.zPosition = 10
        scoreLabel?.position = CGPoint(x: screenSize.midX-50, y: screenSize.midY-100)
        scoreLabel?.run(AVAudio().getAction(type: .Result_Coin))
        self.addChild(scoreLabel!)
        
        // Label and icons total coin
        let scoreCoin = SKLabelNode(fontNamed: "Cartwheel", andText: "\(collectedCoins)", andSize: 30, fontColor: .yellow, withShadow: .black)
        scoreCoin?.name = "scoreCoin"
        scoreCoin?.zPosition = 10
        scoreCoin?.position = CGPoint(x: screenSize.midX+50, y: screenSize.midY-100)
        scoreCoin?.fontColor = UIColor.yellow
        self.addChild(scoreCoin!)
        
        // Label and icons total coin
        let iconScore = SKSpriteNode(imageNamed: "star")
        iconScore.size = CGSize(width: 40, height: 40)
        iconScore.name = "iconScore"
        iconScore.zPosition = 10
        iconScore.position = CGPoint(x: screenSize.midX+100, y: screenSize.midY - 85)
        self.addChild(iconScore)
        /* -------------------------- End label score ------------------------------------------------------*/

        
        
        // Label and icons total coin
        let eggLabel = SKLabelNode(fontNamed: "Cartwheel", andText: "COMMON EGG FOUND!", andSize: 30, fontColor: .orange, withShadow: .black)
        eggLabel?.name = "eggLabel"
        eggLabel?.zPosition = 10
        eggLabel?.position = CGPoint(x: screenSize.midX, y: screenSize.midY-150)
        self.addChild(eggLabel!)
        
        // Label and icons total coin
        let eggNode = SKSpriteNode(imageNamed: "Common")
        eggNode.name = "eggNode"
        eggNode.setScale(0.5)
        eggNode.zPosition = 10
        eggNode.position = CGPoint(x: screenSize.midX , y: (eggLabel?.position.y)! - 50)
        self.addChild(eggNode)
        
        
        
        let play = SKSpriteNode(imageNamed: "PlayButton")
        play.name = "playBtn"
        play.size = CGSize(width: 150, height: 75)
        play.position = CGPoint(x: screenSize.midX - play.size.width/2-25, y: screenSize.minY + 100)
        self.addChild(play)
        
        let store = SKSpriteNode(imageNamed: "StoreButton")
        store.name = "storeBtn"
        store.size = CGSize(width: 150, height: 75)
        store.position = CGPoint(x: screenSize.midX + store.frame.width/2+25 , y: screenSize.minY + 100)
        self.addChild(store)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.nodes(at: location)
            if node.first?.name == "playBtn" {
                //    let scene = StartGame(size: self.size)
            
                 let scene = MainScene(size: self.size)
                    self.view?.presentScene(scene)
            }
            else if node.first?.name == "storeBtn" {
                presentReviewRequest()
                
            }
        }
    }
    
    /// Present review App Store
    private func presentReviewRequest() {
        let twoSecondsFromNow = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview()
        }
    }
    
    
    // MARK: SAVE RESULT DB
    private func saveDbCoin(newCoinAmount:Int) -> Bool {
        
        do {
            guard let score = try managed.fetch(Score.fetchRequest()).first else { return false}
          
            score.coin += Int32(newCoinAmount)
            
            try managed.save()
            
            return true
            
        }catch {
            return false
        }
    }
}


