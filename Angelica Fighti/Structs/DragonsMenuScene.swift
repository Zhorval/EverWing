//
//  DragonsScene.swift
//  Angelica Fighti
//
//  Created by Pablo  on 28/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit

class DragonsMenuScene:SKScene,ProtocolTaskScenes {
    
    
    enum MenuSceneDragons {
        case Main
        case Eggs
        case Sell
        case Index
    }
    
    fileprivate var gameinfo = GameInfo()
    
    private var Eggs:UITableView?
    
    private var eggsPage:UIView?
    
    private var mainPage:UIView?
    
    private var selectMenu:MenuSceneDragons = .Main

    override func didMove(to view: SKView) {
        self.size = CGSize(width: screenSize.width, height: screenSize.height)
        loadBackground()
        load()
    }
    
    private func loadBackground() {
            let bg = SKSpriteNode(texture: SKTexture(imageNamed: "Dragons_Background"))
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.size = CGSize(width: screenSize.width, height: screenSize.height)
            bg.zPosition = -10
            self.addChild(bg)
    }
    
    private func load(){
        
        //GameInfo Load
        let check = gameinfo.load(scene: self)
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }else{
            // Fix Inforbar Position
            let infobar = self.childNode(withName: "infobar")!
            infobar.position.y = screenSize.height-100
            infobar.position.x -= screenSize.midX - infobar.frame.midX
        }
       

        // Title
        let title = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_TitleMenu))
            title.position = CGPoint(x:screenSize.midX,y:screenSize.height-150)
            title.size = CGSize(width: screenSize.width*0.6, height: screenSize.height*0.1)
        
        let titleLabel = SKLabelNode(fontNamed: "Family Guy")
            titleLabel.text = "DRAGON ROOST"
            titleLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
            titleLabel.fontSize = screenSize.width/28
            title.addChild(titleLabel.shadowNode(nodeName: "titleEffectNodeLabel"))
            self.addChild(title)

        // Icon Cancel
        let iconCancel = SKSpriteNode(texture: SKTexture(imageNamed: "CancelButton"))
            iconCancel.name = "CancelButton"
            iconCancel.position = CGPoint(x: screenSize.maxX - titleLabel.frame.maxX,y: screenSize.height-125)
            iconCancel.size = CGSize(width: 35, height: 35)
            self.addChild(iconCancel)
        
        // BackArrow
        let backarrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_BackArrow))
            backarrow.name = Global.Main.Character_Menu_BackArrow.rawValue
            backarrow.position = CGPoint(x: title.frame.minX - 50, y: title.position.y + 3)
            backarrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.06)
            self.addChild(backarrow)
        
        if selectMenu == .Main {
            showMainPage()
        }
    /*
        // Circles dragon
        let circleL = SKSpriteNode(texture: SKTexture(imageNamed: Global.GUIButtons.bgDragonsCircle.rawValue), size: CGSize(width: screenSize.width/4, height: screenSize.width/4))
            circleL.position = CGPoint(x: title.frame.minX, y: title.position.y-100)
            self.addChild(circleL)
        
        let circleR = circleL.copy() as? SKSpriteNode
        circleL.position = CGPoint(x: title.frame.maxX, y: title.position.y-100)
        self.addChild(circleR!)
        */
        
        let bgIcons = SKSpriteNode(texture: SKTexture(imageNamed: "bgSandDragonScene"), size: CGSize(width: screenSize.width+50, height: 75))
            bgIcons.position = CGPoint(x: screenSize.midX, y: screenSize.minY+25)
            addChild(bgIcons)
        
        let Btneggs = self.createUIButton(bname: "getEggs", offsetPosX: screenSize.width/3, offsetPosY: screenSize.minY+25, typeButtom: .GreenButton)
            Btneggs.size  = CGSize(width: screenSize.width/4, height: 50)
            addChild(Btneggs)
        
        let labelEggs = SKLabelNode(fontNamed: "Cartwheel", andText: "GET EGGS", andSize: 15, withShadow: .black,name: "labelEggsShadow")
            labelEggs?.position.y = -Btneggs.frame.height / 1.5
            Btneggs.addChild(labelEggs!)
        
        let iconShieldEgg = SKSpriteNode(texture: SKTexture(imageNamed: Global.GUIButtons.ShieldEggs.rawValue), size: CGSize(width: 50, height: 75))
            iconShieldEgg.position = CGPoint(x:Btneggs.frame.width/2,y:-Btneggs.frame.height/2)
        let action = SKAction.repeatForever(.sequence([.rotate(byAngle: -0.2, duration: 0.1),
                                                       .rotate(byAngle: 0.2, duration: 0.1),
        ]))
            iconShieldEgg.run(action)
            Btneggs.addChild(iconShieldEgg)
        
        let Btnsell = self.createUIButton(bname: "sell", offsetPosX: 0, offsetPosY: -screenSize.height/2+75, typeButtom: .GreenButton)
            Btnsell.size  = CGSize(width: screenSize.width/4, height: 50)
            addChild(Btnsell)
        
        let labelSell = SKLabelNode(fontNamed: "Cartwheel", andText: "SELL", andSize: 15, withShadow: .black)
            labelSell?.position.y = -Btneggs.frame.height / 1.5
            Btnsell.addChild(labelSell!)
    
        let BtnIndex = self.createUIButton(bname: "index", offsetPosX: screenSize.width/3, offsetPosY: -screenSize.height/2+75, typeButtom: .GreenButton)
            BtnIndex.size  = CGSize(width: screenSize.width/4, height: 50)
            addChild(BtnIndex)
        
        let labelIndex = SKLabelNode(fontNamed: "Cartwheel", andText: "INDEX", andSize: 15, withShadow: .black)
            labelIndex?.position.y = -Btneggs.frame.height / 1.5
            BtnIndex.addChild(labelIndex!)
        
        let BtnBook = SKSpriteNode(texture: SKTexture(imageNamed: Global.GUIButtons.BookButton.rawValue), size: CGSize(width: 50, height: 75))
            BtnBook.position = CGPoint(x:Btneggs.frame.width/2,y:-Btneggs.frame.height/2)
            BtnIndex.addChild(BtnBook)
        
    }
    
    
    // MARK: SHOW MAIN PAGE SCREEN
    private func showMainPage() {
        
        let posX = 50.0
        let posY = 150.0
        let width = screenSize.width-posX*2
        let height = screenSize.height - (posY + 75)
        
        mainPage = UIView(frame: CGRect(x:  posX,y: posY, width: width,height: height))
        mainPage?.backgroundColor = .red
        let circleL = UIImageView(frame: CGRect(x: 0, y: 100, width: screenSize.width/4, height: screenSize.width/4))
        circleL.image = UIImage(named: Global.GUIButtons.bgDragonsCircle.rawValue)
        
        let circleR = UIImageView(frame: CGRect(x: width-circleL.frame.width, y: 100, width: screenSize.width/4, height: screenSize.width/4))
        circleR.image = UIImage(named: Global.GUIButtons.bgDragonsCircle.rawValue)
        
        mainPage?.addSubview(circleL)
        mainPage?.addSubview(circleR)
        
        self.view?.addSubview(mainPage!)
        

        
        
    }
    // MARK: SHOW EGGS PAGE SCREEN
    private func showEggsPage() {
        
        let posX = 50.0
        let posY = 150.0
        let width = screenSize.width-posX*2
        let height = screenSize.height - screenSize.height/3
        
        eggsPage = UIView(frame: CGRect(x:  posX,y: posY, width: width,height: height))
                            
        eggsPage?.backgroundColor = UIColor(patternImage: (UIImage(named:  "bgSettings")?.resized(to: CGSize(width: width, height: height)))!)
        
        
        Eggs = CustomCollectionView(frame: CGRect(x: 0 ,
                                                        y: 50,
                                                        width: width,
                                                        height: height-100))
        guard let Eggs = Eggs else {
            return
        }
        
      /*  UIView.animate(withDuration: 0.05) { [self] in
            eggsPage?.transform = CGAffineTransform(translationX: selectMenu == .Main ? -screenSize.width : screenSize.width, y: 0)
        }*/
        eggsPage?.addSubview(Eggs)
    
        self.view?.addSubview(eggsPage!)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            guard let pos  = nodes(at: touch.location(in: self)).first else { return }
            
            if pos.name == Global.Main.Character_Menu_BackArrow.rawValue{
                doTask(gb: .Character_Menu_BackArrow)
             } else if pos.name == "getEggs" {
                 selectMenu = .Eggs
                 showEggsPage()
             } else if pos.name == "CancelButton" {
                 print("cancel")
                 if selectMenu != .Main {
                     eggsPage?.removeFromSuperview()
                 }
             }
            
        }
    }
    
    internal func doTask(gb: Global.Main) {
        switch gb {
        case .Character_Menu_BackArrow:
            
            self.gameinfo.prepareToChangeScene()
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            let newScene = MainScene(size: self.size)
            self.view?.presentScene(newScene)
        default:
            print("Should not reach Here - doTask from CharacterMenuScene")
        }
    }
}
