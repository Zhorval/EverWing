//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit

class EndGame: SKScene {
    deinit{
        print ("ENDGAME CLEANED")
    }
    
    var collectedCoins:Int = 0
    
    let currentToon = AccountInfo().getCurrentToon()
    
    
    
    override func didMove(to view: SKView) {
        
        let userPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = userPath.appendingPathComponent("userinfo.plist")
        
        guard let virtualPlist = NSDictionary(contentsOfFile: fullPath) else{
            print ("ERROR000: EndGame failed to load virtualPlist")
            return
        }
        
        guard let dataCoin:Int = virtualPlist.value(forKey: "Coin") as? Int else{
            print ("ERROR001: EndGame error")
            return
        }
        
        let newCoinAmount = collectedCoins + dataCoin
        
        virtualPlist.setValue(newCoinAmount, forKey: "Coin")
        
        if !virtualPlist.write(toFile: fullPath, atomically: false){
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
        let newGame = SKLabelNode(fontNamed: "Cartwheel", andText: "Game over", andSize: 50, withShadow: .black)
            newGame?.name = "gameOver"
            newGame?.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            newGame?.zPosition = 10
            newGame?.fontColor = UIColor.yellow
            newGame?.run(.repeatForever(sequenceAction  ))
        self.addChild(newGame!)
        
        
        let totalCoin = SKLabelNode(fontNamed: "Cartwheel", andText: "Total coin", andSize: 30, withShadow: .white)
            totalCoin?.name = "totalCoin"
            totalCoin?.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            totalCoin?.zPosition = 10
            totalCoin?.position = CGPoint(x: screenSize.midX, y: screenSize.midY-50)
            totalCoin?.fontColor = UIColor.black
        self.addChild(totalCoin!)
        
        
       
        let atlas = SKTextureAtlas().loadAtlas(name: "Items",prefix: "gold_action")
        
        /// Sprite coin

        let coin = SKSpriteNode(imageNamed: "gold_main")
            coin.size = CGSize(width: 50, height: 50)
            coin.position = CGPoint(x: screenSize.midX-80, y: screenSize.midY - 100)
            coin.run(SKAction.repeatForever(.animate(with: atlas, timePerFrame: 0.25)))
        self.addChild(coin)
    
        /// Text total coin
        let label = SKLabelNode(fontNamed: "Cartwheel", andText: "\(newCoinAmount)", andSize: 50, withShadow: .white)
            label?.position = CGPoint(x: screenSize.midX, y: screenSize.midY - 115)
            label?.fontColor = UIColor.red
            label?.text = String(newCoinAmount)
        self.addChild(label!)
        
        
        let play = SKSpriteNode(imageNamed: "PlayButton")
            play.name = "playBtn"
            play.size = CGSize(width: 150, height: 75)
            play.position = CGPoint(x: screenSize.midX, y: screenSize.minY + 100)
        self.addChild(play)
        
       
        
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
        }
    }
    
}


