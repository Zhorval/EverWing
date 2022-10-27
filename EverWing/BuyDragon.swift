//
//  BuyDragon.swift
//  EverWing
//
//  Created by Pablo  on 5/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit



class BuyDragon:SKScene,ProtocolEffectBlur {
    
    var blurNode: SKEffectNode = SKEffectNode()
    
    let gameInfo = GameInfo()
    
    
    override func didMove(to view: SKView) {
     
        gameInfo.mainAudio.play(type: .DragonBuy)
       
        self.run(gameInfo.mainAudio.getAction(type: .Egg_Hatch_Start))

        loadBackground()

        loadEggsAnimation { val in
            self.run(.group([
                self.gameInfo.mainAudio.getAction(type: .Egg_Hatch_End_Common),
                .run {
                    self.blurScene(blurNode: self.blurNode)
                    self.loadUI()
                }]))
        }
    }
    
    //MARK: LOAD ANIMATION BEGIN SCREEN
    private func loadEggsAnimation(handle:@escaping(Bool)->Void)  {
        
        let node = SKNode()
            node.name = "rootSceneDragonsBuy"
            node.position = CGPoint(x: screenSize.width/2, y: screenSize.maxY)
      
        node.run(.sequence([
            .move(to: CGPoint(x: screenSize.width/2, y: screenSize.height * 0.35), duration: 0.5),
            .repeat(.sequence([
                .scaleY(to: 0.9, duration: 0.25),
                .scaleY(to: 0.8, duration: 0.25),
            ]),count: 8)
        ]),completion: {
            node.childNode(withName: "coverEgg")?.run(.group([
                .rotate(toAngle: -.pi/4, duration: 0.5, shortestUnitArc: true),
                ]), completion: {
                    handle(true)
            })
        })

        
        let eggsBase = SKSpriteNode(imageNamed: "baseEgg")
            eggsBase.size = CGSize(width: screenSize.width/2, height: screenSize.width/1.5)
            eggsBase.anchorPoint = CGPoint(x: 0.5, y: 0)
            eggsBase.position = .zero
            node.addChild(eggsBase)
        
        let sun = SKSpriteNode(imageNamed: "bgSun")
            sun.size = eggsBase.size
            sun.position.y = eggsBase.frame.maxY - 50
            node.addChild(sun)

        
        let sunRotate = SKSpriteNode(imageNamed: "bgSunRotate")
            sunRotate.position.y = eggsBase.frame.maxY - 50
            
            sunRotate.run(.repeatForever(.group([
            .rotate(byAngle: .pi, duration: 1),
            .scale(by: 1.5, duration: 0.5),
            .scale(by: 1, duration: 0.5),
           ])))
            node.addChild(sunRotate)
        
        let eggCover = SKSpriteNode(imageNamed: "coverEgg")
            eggCover.name = "coverEgg"
            eggCover.anchorPoint = CGPoint(x: 1, y: 0)
            eggCover.size = CGSize(width: screenSize.width/2, height: screenSize.width/1.5)
            eggCover.position = CGPoint(x: eggCover.size.width/2, y: eggsBase.frame.height/3)
        
            node.addChild(eggCover)
        
            addChild(node)
    }
    
    //MARK: LOAD SCREEN WHEN FINISH ANIMATION AND MAKE BLUR SCREEN
    private func loadUI() {
        

        let txtGetDragon = SKLabelNode(fontNamed: "Cartwheel", andText: "COMMON", andSize: screenSize.size.width * 0.15, fontColor: .green, withShadow: .black)!
        txtGetDragon.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.9)
        txtGetDragon.zPosition = 10
        addChild(txtGetDragon)
        
        let txtGet = SKLabelNode(fontNamed: "Cartwheel", andText: "GET", andSize: screenSize.size.width * 0.1, fontColor: .green, withShadow: .black)!
        txtGet.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.8)
        txtGet.zPosition = 10
        addChild(txtGet)
        
        
        let btnBuyOneMore = SKScene().createUIButton(bname: "btnBuyOneMore", offsetPosX: screenSize.midX, offsetPosY: screenSize.height*0.18, typeButtom: .GreenButton)
        btnBuyOneMore.size = CGSize(width: screenSize.width*0.3, height: screenSize.width*0.3/2)
        
        let labelOneMore = SKLabelNode(fontNamed: "HelveticaNeue-Bold", andText: "BUY 1 MORE", andSize: btnBuyOneMore.frame.width * 0.1, fontColor: .white, withShadow: .black)!
        labelOneMore.position = CGPoint(x: 0,y: labelOneMore.fontSize)
        btnBuyOneMore.addChild(labelOneMore)
        
        
        let labelPrice = SKLabelNode(fontNamed: "Cartwheel", andText: "640", andSize: btnBuyOneMore.frame.width * 0.15, fontColor: .yellow, withShadow: .black)!
        labelPrice.position = CGPoint(x:0,y: -labelPrice.fontSize/2)
        labelPrice.zPosition = 10
        btnBuyOneMore.addChild(labelPrice)
        
        let iconCoin = SKSpriteNode(imageNamed: "coin")
        iconCoin.size = CGSize(width: btnBuyOneMore.size.height/3, height: btnBuyOneMore.size.height/3)
        iconCoin.position = CGPoint(x: iconCoin.size.width*1.5,y: -labelPrice.fontSize/2 )
        btnBuyOneMore.addChild(iconCoin)

        addChild(btnBuyOneMore)
        
        let txtNameDragon = SKLabelNode(fontNamed: "Cartwheel", andText: "FLO", andSize: screenSize.size.width * 0.15, fontColor: .green, withShadow: .black)!
        txtNameDragon.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.3)
        addChild(txtNameDragon)
        
        let txtDescriptionDragon = SKLabelNode(fontNamed: "Cartwheel", andText: "Monster Killer", andSize: screenSize.size.width * 0.08, fontColor: .green, withShadow: .black)!
        txtDescriptionDragon.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.4)
        addChild(txtDescriptionDragon)
        
        let iconSkill = SKSpriteNode(imageNamed: "Green_Weakness")
        iconSkill.setScale(1.2)
        iconSkill.position = CGPoint(x:screenSize.width-50,y: screenSize.height*0.33)
        addChild(iconSkill)
        
        let iconHoroscopo = SKSpriteNode(imageNamed: "pisces")
        iconHoroscopo.size = iconSkill.size
        iconHoroscopo.position = CGPoint(x:50,y: screenSize.height*0.33)
        addChild(iconHoroscopo)
        
       addChild(raySunRotating(point: CGPoint(x: screenSize.midX, y: screenSize.midY),
                               size: CGSize(width: screenSize.width, height: screenSize.width)))
        
        let imgDragon = SKSpriteNode(imageNamed: "NC01_T1_icon")
            imgDragon.size = CGSize(width: screenSize.width/2, height: screenSize.width/2)
            imgDragon.position = CGPoint(x:screenSize.width/2,y: screenSize.height*0.6)
        
        addChild(imgDragon)
        
       
        
        let btnOk = SKScene().createUIButton(bname: "btnOkay", offsetPosX: screenSize.midX, offsetPosY: screenSize.height*0.05, typeButtom: .BlueButton)
        btnOk.size = CGSize(width: screenSize.width*0.3, height: screenSize.width*0.3/2)
        
        let labelBtnOkay = SKLabelNode(fontNamed: "Cartwheel", andText: "Okay", andSize: btnOk.frame.width/4 * 0.9, fontColor: .white, withShadow: .black)!
        labelBtnOkay.zPosition = 10
        btnOk.addChild(labelBtnOkay)
        
        addChild(btnOk)
    }
    
    //MARK: LOAD BACKGROUND SCREEN
    private func loadBackground() {
        
        let bg = SKSpriteNode(imageNamed: "gacha_common")
        bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        bg.size = CGSize(width: screenSize.width, height: screenSize.height)
        bg.zPosition = -10
        bg.name = "buyDragonBg"
        addChild(bg)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var pos:CGPoint!
        
        for touch in touches{
            
            pos = touch.location(in: self)
        }
        
        let childs = self.nodes(at: pos)
        for c in childs {
            if c.name == "btnOkay" {
                let scene = MainScene(size: self.size)
                self.view?.presentScene(scene)
            }
            
        }
        
        
    }
}
