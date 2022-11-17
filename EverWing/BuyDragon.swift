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
    
    let gameInfo = GameInfo.shared
    
    var dragons:BuyEggs? = nil
    
    var dragonFind:(key:String,value:String)? = nil
    
    
    init(size: CGSize,dragons:BuyEggs) {
        
        self.dragons = dragons

        super.init(size: size)
        
        self.dragonFind = findRandomDragon()!

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        let _ = self.view?.subviews.filter{$0.restorationIdentifier == "infobar"}.map { $0.removeFromSuperview()}
        
        gameInfo.mainAudio.play(type: .DragonBuy)
        
        self.run(gameInfo.mainAudio.getAction(type: .Egg_Hatch_Start))
        
        loadBackground()
        
        loadEggsAnimation { val in
            self.run(.group([
                self.gameInfo.mainAudio.getAction(type: .Egg_Hatch_End_Common),
                .run { [self] in
                    saveFoundDragon(keyDragon: dragonFind!.key)

                    blurScene(blurNode: self.blurNode)
                    loadUI()
                }]))
        }
    }
    
    //MARK: LOAD ANIMATION BEGIN SCREEN
    private func loadEggsAnimation(handle:@escaping(Bool)->Void)  {
        
        let node = SKNode()
            node.name = "rootSceneDragonsBuy"
            node.position = CGPoint(x: screenSize.width/2, y: screenSize.maxY)
      
        let typeEggs =  prepareEggsCover()
        node.run(.sequence([
            .move(to: CGPoint(x: screenSize.width/2, y: screenSize.height * 0.35), duration: 0.5),
            .repeat(.sequence([
                .scaleY(to: 0.9, duration: 0.25),
                .scaleY(to: 0.8, duration: 0.25),
            ]),count: 8)
        ]),completion: {
            node.childNode(withName: typeEggs+"coverEgg")?.run(.group([
                .rotate(toAngle: -.pi/4, duration: 0.5, shortestUnitArc: true),
                ]), completion: {
                    handle(true)
            })
        })

        
        let eggsBase = SKSpriteNode(imageNamed: typeEggs + "baseEgg")
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
        
        let eggCover = SKSpriteNode(imageNamed: typeEggs + "CoverEgg")
            eggCover.name = typeEggs + "coverEgg"
            eggCover.anchorPoint = CGPoint(x: 1, y: 0)
            eggCover.size = CGSize(width: screenSize.width/2, height: screenSize.width/1.5)
            eggCover.position = CGPoint(x: eggCover.size.width/2, y: eggsBase.frame.height/3)
        
            node.addChild(eggCover)
        
            addChild(node)
    }
    
    private func prepareEggsCover() ->String {
        
        let array = [Icons.Common,Icons.Bronze,Icons.Silver,Icons.Golden,Icons.Magical,Icons.Ancient]
        
        guard let cover = array.randomElement()?.coverEgg else  { return "Nature"}
        
        return cover
      
    }
    
    //MARK: LOAD SCREEN WHEN FINISH ANIMATION AND MAKE BLUR SCREEN
    private func loadUI() {
        

        let txtGetDragon = SKLabelNode(fontNamed: "Cartwheel", andText: "COMMON", andSize: screenSize.size.width * 0.15, fontColor: .green, withShadow: .black)!
        txtGetDragon.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.9)
        addChild(txtGetDragon)
        
        let txtGet = SKLabelNode(fontNamed: "Cartwheel", andText: "GET", andSize: screenSize.size.width * 0.1, fontColor: .green, withShadow: .black)!
        txtGet.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.85)
        addChild(txtGet)
        
        
        let btnBuyOneMore = SKScene().createUIButton(bname: "btnBuyOneMore", offsetPosX: screenSize.midX, offsetPosY: screenSize.height*0.18, typeButtom: .GreenButton)
        btnBuyOneMore.size = CGSize(width: screenSize.width*0.3, height: screenSize.width*0.3/2)
        
        let labelOneMore = SKLabelNode(fontNamed: "HelveticaNeue-Bold", andText: "BUY 1 MORE", andSize: btnBuyOneMore.frame.width * 0.1, fontColor: .white, withShadow: .black)!
        
        labelOneMore.position = CGPoint(x: 0,y: labelOneMore.fontSize)
        btnBuyOneMore.addChild(labelOneMore)
        
        let labelPrice = SKLabelNode(fontNamed: "Cartwheel", andText: String(dragons?.amount ?? 0).convertDecimal(), andSize: btnBuyOneMore.frame.width * 0.15, fontColor: .yellow, withShadow: .black)!
        labelPrice.position = CGPoint(x:0,y: -labelPrice.fontSize/2)
        btnBuyOneMore.addChild(labelPrice)
        
        let iconCoin = SKSpriteNode(imageNamed: "coin")
        iconCoin.size = CGSize(width: btnBuyOneMore.size.height/3, height: btnBuyOneMore.size.height/3)
        iconCoin.position = CGPoint(x: iconCoin.size.width*1.5,y: -labelPrice.fontSize/2 )
        btnBuyOneMore.addChild(iconCoin)

        addChild(btnBuyOneMore)
        
        let txtNameDragon = SKLabelNode(fontNamed: "Cartwheel", andText: dragonFind!.1, andSize: screenSize.size.width * 0.15, fontColor: .green, withShadow: .black)!
        txtNameDragon.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.3)
        addChild(txtNameDragon)
        
        let txtDescriptionDragon = SKLabelNode(fontNamed: "Cartwheel", andText: "Monster Killer", andSize: screenSize.size.width * 0.08, fontColor: .green, withShadow: .black)!
        txtDescriptionDragon.position = CGPoint(x:screenSize.midX,y: screenSize.height*0.4)
        addChild(txtDescriptionDragon)
        
        let iconSkill = SKSpriteNode(imageNamed: "Nature_Weakness")
        iconSkill.size = CGSize(width: screenSize.width*0.1, height: screenSize.width*0.1)
        iconSkill.position = CGPoint(x:screenSize.width-50,y: screenSize.height*0.33)
        addChild(iconSkill)
        
        let iconHoroscopo = SKSpriteNode(imageNamed: "pisces")
        iconHoroscopo.size = CGSize(width: screenSize.width*0.1, height: screenSize.width*0.1)
        iconHoroscopo.position = CGPoint(x:50,y: screenSize.height*0.33)
        addChild(iconHoroscopo)
        
        addChild(self.raySunRotating(point: CGPoint(x: screenSize.midX, y: screenSize.midY),size: CGSize(width: screenSize.width, height: screenSize.width)))
        
        
        let imgDragon = SKSpriteNode(imageNamed: dragonFind!.0 + "_T1_icon")
            imgDragon.size = CGSize(width: screenSize.width/2, height: screenSize.width/2)
            imgDragon.position = CGPoint(x:screenSize.width/2,y: screenSize.height*0.6)
        
        addChild(imgDragon)
        
       
        
        let btnOk = SKScene().createUIButton(bname: "btnOkay", offsetPosX: screenSize.midX, offsetPosY: screenSize.height*0.05, typeButtom: .BlueButton)
        btnOk.size = CGSize(width: screenSize.width*0.3, height: screenSize.width*0.3/2)
        
        let labelBtnOkay = SKLabelNode(fontNamed: "Cartwheel", andText: "Okay", andSize: btnOk.frame.width/4 * 0.9, fontColor: .white, withShadow: .black)!
        btnOk.addChild(labelBtnOkay)
        
        addChild(btnOk)
    }
    
    //MARK: LOAD BACKGROUND SCREEN
    private func loadBackground() {
        
        let bg = SKSpriteNode(imageNamed: "gacha_common")
        bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        bg.size = CGSize(width: screenSize.width, height: screenSize.height)
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
                
            } else if c.name == "btnBuyOneMore" {
                
                guard let buyAgain =  BuyEggs.items.filter({ $0.self == dragons.self}).first else { return }
                gameInfo.mainScene = self
                
                view?.addSubview(self.showViewBuyAditionalItem(gameInfo: gameInfo, scene: self, items: buyAgain))
            }
        }
    }
    
    //MARK: FIND RANDOM DRAGON
    private func findRandomDragon() ->(String,String)? {
        
            let directory = Bundle.main.url(forResource: "property", withExtension: "plist")!
            
            guard let data = try? Data(contentsOf: directory) else { return nil }
            
        do {
            guard let json = try PropertyListSerialization.propertyList(from: data, options: [],format: nil) as? Dictionary<String,Any>,
                  let js =  json["sidekicks"] as? Dictionary<String,Any>  else { return nil }
            
            guard let key = js.keys.randomElement(),
                  let dict = js[key] as? Dictionary<String,Dictionary<String,String>> ,
                  let name = dict["names"]?.first?.value else { return nil}
            
                return (key,name)
            
        }catch let error{
            print("Error not found dragon in PLIST - \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK: FIND THE DRAGON BY KEY DICTIONARY PLIST
    private func findDragonByKey(key:String) -> Dictionary<String,Dictionary<String,String>>? {
        
        let directory = Bundle.main.url(forResource: "property", withExtension: "plist")!
        
        guard let data = try? Data(contentsOf: directory) else { return nil }
            
        do {
            guard let json = try PropertyListSerialization.propertyList(from: data, options: [],format: nil) as? Dictionary<String,Any>,
                  let js =  json["sidekicks"] as? Dictionary<String,Any> ,
                  let dragon = js[key] as? Dictionary<String,Dictionary<String,String>>  else { fatalError()}
            
                return dragon
            
        }catch let error{
            print("Error not found dragon in PLIST - \(error.localizedDescription)")
            return nil
        }
    }
    
    //MARK: SAVE THE FOUND DRAGON IN THE DB
    private func saveFoundDragon(keyDragon key:String)  {
        
        guard let dragon = findDragonByKey(key: key),
              let name =  dragon["names"]?.first else { fatalError() }
        
         let managed = ManagedDB.shared.context
        do {
            
            
            let newDragon = DragonsBuyDB(context: managed)
            newDragon.name = name.value
            newDragon.picture = key + "_T1_icon"
            newDragon.power = 0
            newDragon.level = 1
            newDragon.discover = Date()
            
            try managed.save()
            
            print("Save db buydragon.swift",name.value)
        } catch let error {
            print("Error save DB dragons \(error)")
        }
    }
}
