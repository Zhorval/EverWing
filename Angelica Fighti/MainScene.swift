//
//  MainScene.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit


class MainScene:SKScene, SKPhysicsContactDelegate{
    
    deinit{
        print("MainScene is being deInitialized.");
    }
    
    enum Scene{
        case MainScene
        case EndScene
        case Character_Menu
    }
    
    var gameinfo = GameInfo()
    var isPlayerMoved:Bool = false
    
    override func didMove(to view: SKView) {
        
        removeUIViews()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        
        self.view?.addGestureRecognizer(gestureRecognizer)
        
        // For Debug Use only
        view.showsPhysics = true
        
        // Setting up delegate for Physics World & Set up gravity
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        loadBackground()
        loadgameinfo()
        
    }
    
    func loadBackground(){
        print ("Pantalla",screenSize)
        
        let bg = SKSpriteNode()
            bg.texture = global.getMainTexture(main: .Main_Menu_Background_1)
            bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
            bg.size = CGSize(width: screenSize.width, height: screenSize.height)
            bg.zPosition = -10
            bg.name = Global.Main.Main_Menu_Background_1.rawValue
        self.addChild(bg)
        
        let cloud = SKSpriteNode()
            cloud.texture = global.getMainTexture(main: .Main_Menu_Background_2)
            cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.40)
            cloud.size = CGSize(width: screenSize.width, height: screenSize.height*3/4)
            cloud.zPosition = -9
            cloud.name = Global.Main.Main_Menu_Background_2.rawValue
        self.addChild(cloud)
        
        let cloud2 = SKSpriteNode()
            cloud2.texture = global.getMainTexture(main: .Main_Menu_Background_3)
            cloud2.position = CGPoint(x: -20 + screenSize.width/2, y: 0)
            cloud2.size = CGSize(width: screenSize.width + 100, height: screenSize.height/2)
            cloud2.zPosition = -8
            cloud2.name = Global.Main.Main_Menu_Background_3.rawValue
        self.addChild(cloud2)
        
        let root = SKSpriteNode()
            root.color = .clear
            root.name = "main_menu_middle_root"
            root.size = CGSize(width: screenSize.width, height: screenSize.height*0.7)
            root.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.55)
            root.zPosition = -7
        self.addChild(root)
        // note... anchor of root is 0.5, 0.5
        
        let bd_one = SKSpriteNode()
            bd_one.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_one.texture = global.getMainTexture(main: .Main_Menu_Building_1)
            bd_one.position = CGPoint(x: 0, y: root.size.height/2)
            bd_one.size = CGSize(width: screenSize.width/2, height: screenSize.height/2)
            bd_one.name = "main_menu_building_1"
        root.addChild(bd_one)
        
        let bd_one_shade = SKSpriteNode()
            bd_one_shade.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_one_shade.texture = global.getMainTexture(main: .Main_Menu_Building_1_Additional)
            bd_one_shade.position = CGPoint(x: 0, y: -25)
            bd_one_shade.size = CGSize(width: screenSize.width/2, height: screenSize.height/2)
            bd_one_shade.name = "main_menu_building_1_Additional"
        bd_one.addChild(bd_one_shade)
        
        let bd_two = SKSpriteNode()
            bd_two.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_two.texture = global.getMainTexture(main: .Main_Menu_Building_2)
            bd_two.position = CGPoint(x: bd_one.size.width/3, y: bd_one.position.y - bd_one.size.height/2)
            bd_two.size = CGSize(width: screenSize.width/3, height: screenSize.height/3)
            bd_two.name = "main_menu_building_2"
        root.addChild(bd_two)
        
        let bd_three = SKSpriteNode()
            bd_three.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_three.texture = global.getMainTexture(main: .Main_Menu_Building_3)
            bd_three.position = CGPoint(x: -bd_one.size.width/3, y: bd_one.position.y - bd_one.size.height/2)
            bd_three.size = CGSize(width: screenSize.width/3, height: screenSize.height/3.5)
            bd_three.name = "main_menu_building_3"
        root.addChild(bd_three)
        
        let bd_one_button = createUIButton(bname: "character_building_button", offsetPosX: bd_one.position.x, offsetPosY: bd_one.position.y - bd_one.size.height/2 + 10)
            root.addChild(bd_one_button)
        let bd_two_button = createUIButton(bname: "building_2_button", offsetPosX: bd_two.position.x, offsetPosY: bd_two.position.y - bd_two.size.height/2 - 15)
            root.addChild(bd_two_button)
        let bd_three_button = createUIButton(bname: "building_3_button", offsetPosX: bd_three.position.x, offsetPosY: bd_three.position.y - bd_three.size.height/2 - 50)
            root.addChild(bd_three_button)
        
        
        let LONGESTSTRCOUNT:CGFloat = 11
        // Button Labels
        let bd_one_label = SKLabelNode()
            bd_one_label.text = "CHARACTERS"
            bd_one_label.fontName = "GillSans-Bold"
            bd_one_label.fontSize = bd_one_button.size.width/LONGESTSTRCOUNT
            bd_one_label.position = CGPoint(x: 0, y: -5 - bd_one_button.size.height/2)
            bd_one_button.addChild(bd_one_label)
        
        
        // SIDEKICK
        let bd_two_label = SKLabelNode()
            bd_two_label.text = "SIDEKICKS"
            bd_two_label.fontName = "GillSans-Bold"
            bd_two_label.fontSize =  bd_two_button.size.width/LONGESTSTRCOUNT
            bd_two_label.position = CGPoint(x: 0, y: -5 - bd_two_button.size.height/2)
            bd_two_button.addChild(bd_two_label)
     
        // LEADERBOARD
        let bd_three_label = SKLabelNode()
            bd_three_label.text = "LEADERBOARD"
            bd_three_label.fontName = "GillSans-Bold"
            bd_three_label.fontSize = bd_three_button.size.width/LONGESTSTRCOUNT
            bd_three_label.position = CGPoint(x: 0, y: -5 - bd_three_button.size.height/2)
            bd_three_button.addChild(bd_three_label)
        
        //DRAG TO MOVE
        let dragtomove = SKSpriteNode()
            dragtomove.size = CGSize(width: screenSize.width/2, height: screenSize.height/32)
            dragtomove.position = CGPoint(x: 0, y: -screenSize.height/4)
            dragtomove.texture = global.getMainTexture(main: .Main_Menu_Drag_To_Start)
            dragtomove.name = "drag_to_move"
            root.addChild(dragtomove)
        
        // Drag arrow Left
        let arrowLeft = SKSpriteNode()
            arrowLeft.size = CGSize(width: dragtomove.size.height, height: dragtomove.size.height*1.2)
            arrowLeft.position = CGPoint(x: dragtomove.position.x - dragtomove.size.width/2 - 20, y: dragtomove.position.y)
            arrowLeft.texture = global.getMainTexture(main: .Main_Menu_Arrow)
            arrowLeft.name = "main_menu_arrow_left"
            arrowLeft.zRotation = CGFloat(Double.pi)
            root.addChild(arrowLeft)
        
        // Drag arrow Right
        let arrowRight = SKSpriteNode()
            arrowRight.size = CGSize(width: dragtomove.size.height, height: dragtomove.size.height*1.2)
            arrowRight.position = CGPoint(x: dragtomove.position.x + dragtomove.size.width/2 + 20, y: dragtomove.position.y)
            arrowRight.texture = global.getMainTexture(main: .Main_Menu_Arrow)
            arrowRight.name = "main_menu_arrow_right"
            root.addChild(arrowRight)
        
        // Actions to sprites
        let buildMove = SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -5, duration: 2.3), SKAction.moveBy(x: 0, y: 5, duration: 1.8)]))
            bd_one.run(buildMove)
            bd_two.run(buildMove)
            bd_three.run(buildMove)
        
        cloud2.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 15, duration: 3), SKAction.moveBy(x: 0, y: -15, duration: 3)])))
        
        cloud2.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.0, duration: 3.5), SKAction.scale(to: 1.1, duration: 3)])))
        
        arrowLeft.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: -5, y: 0, duration: 0.3), SKAction.moveBy(x: 5, y: 0, duration: 0.4)])))
        
        arrowRight.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 5, y: 0, duration: 0.3), SKAction.moveBy(x: -5, y: 0, duration: 0.4)])))
        
    }
    
   private func loadgameinfo(){
        // Check if any error from loading gameinfo
        let check = gameinfo.load(scene: self)
        
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }
    
        // Add Character Player
        self.addChild(gameinfo.getCurrentToonNode())
       
       
    }
    
   private func createUIButton(bname: String, offsetPosX dx:CGFloat, offsetPosY dy:CGFloat) -> SKSpriteNode{
        let button = SKSpriteNode()
            button.anchorPoint = CGPoint(x: 0.5, y: 1)
            button.texture = global.getMainTexture(main: .PurpleButton)
            button.position = CGPoint(x: dx, y: dy)
            button.size = CGSize(width: screenSize.width/4, height: screenSize.height/16)
            button.name = bname
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        for touch in touches{
            pos = touch.location(in: self)
        }
        
        if isPlayerMoved{
            // If player has swiped, it will not trigger this function
            return
        }
        let childs = self.nodes(at: pos)
        for c in childs{
            if c.name == "character_building_button"{
                 prepareToChangeScene(scene: .Character_Menu)
            }
        }
    }
    
    @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        
        let toon = gameinfo.getCurrentToon()
        let player = gameinfo.getCurrentToonNode()
    
       
        
        if !isPlayerMoved{
            isPlayerMoved = true
            
            gameinfo.changeGameState(.Start)
            
            _ = gameinfo.dragon.map {  gameinfo.addChild($0.dragon) }
          
            
        }
        
        if recognizer.state == .began {
            
        } else if recognizer.state == .changed {
            let locomotion = recognizer.translation(in: recognizer.view)
            
             player.position.x = player.position.x + locomotion.x*2.0
            
            if (player.position.y  < screenSize.height - player.size.height) {
             player.position.y = player.position.y - locomotion.y*2.0
            }
          
            recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            if (player.position.x < 0 ){
                player.position.x = 0
            }
            else if (player.position.x > screenSize.width){
                player.position.x = screenSize.width
            } else if (player.position.y < 0 ) {
                player.position.y =  player.size.height
            }
            
            if (locomotion.x < -1){
                player.run(SKAction.rotate(toAngle: 0.0872665, duration: 0.1))
            }
            else if (locomotion.x > 0.5){
                player.run(SKAction.rotate(toAngle: -0.0872665, duration: 0.1))
            }
            else if (locomotion.x == 0.0){
                player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
            }
            
            self.gameinfo.dragon[0].dragon.position = CGPoint(x: player.position.x-100, y: player.position.y)
            self.gameinfo.dragon[1].dragon.position = CGPoint(x: player.position.x+100, y: player.position.y)
            
            toon.updateProjectile(node:player)
            
            
        } else if recognizer.state == .ended {
            player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
        }
        else if recognizer.state == .cancelled{
            print ("FAILED CANCEL")
        }
        else if recognizer.state == .failed{
            print ("FAILED")
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var contactType:ContactType = .None
        var higherNode:SKSpriteNode?
        var lowerNode:SKSpriteNode?
        
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            higherNode = contact.bodyA.node as! SKSpriteNode?
            lowerNode = contact.bodyB.node as! SKSpriteNode?
        }
        else if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            higherNode = contact.bodyB.node as! SKSpriteNode?
            lowerNode = contact.bodyA.node as! SKSpriteNode?
        }
        else{  return }
        
        guard let h_node = higherNode, let l_node = lowerNode else { return }
       
        print("hihgh \(h_node) left \(l_node)")
        if (h_node.physicsBody?.categoryBitMask == PhysicsCategory.Imune){
            contactType = .Immune
        }
            
        else if (l_node.name! == "Enemy_Regular" || l_node.name! == "Enemy_Boss" ) && h_node.name!.contains("bullet"){
            contactType = .EnemyGotHit
        }
        else if l_node.name! == "toon" && h_node.name! == "coin"{
            contactType = .PlayerGetCoin
        }
        
            
        else if l_node.name! == "toon"  && h_node.name!.contains("Enemy"){
            contactType = .HitByEnemy
        }
        else if l_node.name!.contains("dragon")  && h_node.name!.contains("Enemy"){
            contactType = .HitByDragon
        }
        
        else if l_node.name! == "toon" && h_node.name!.contains("cofre"){
            contactType = .HitByCofre
        }
        
        else if l_node.name!.contains("Enemy") && l_node.name!.contains("Attack") && h_node.name == "bullet"{
            // Handle case where bullet hit enemy's attack
            return
        }
        
        contactUpdate(lowNode: l_node, highNode: h_node, contactType: contactType)
    }
    
    func contactUpdate(lowNode: SKSpriteNode, highNode: SKSpriteNode, contactType:ContactType){
        let regular = gameinfo.regular_enemies
        let boss = gameinfo.boss
        
        switch contactType{
            
        case .EnemyGotHit:
            
            // Generate FX Effect
            //converting bullet to mainscene's coordinate
            
            let newPos = self.convert(highNode.position, from: highNode.parent!)
            let effect = gameinfo.getToonBulletEmmiterNode(x: newPos.x, y: newPos.y)
            self.addChild(effect)
            
            // update enemy
            highNode.destroy()
            if lowNode.name!.contains("Regular"){
                regular.decreaseHP(ofTarget: lowNode, hitBy: highNode)
            }
            else if lowNode.name!.contains("Boss"){
                boss.decreaseHP(ofTarget: lowNode, hitBy: highNode)
            }
            else{
                print("WARNING: Should not reach here. Check contactUpdate in StartGame.swift")
            }
         
        case .HitByCofre:
            
            let toon = gameinfo.getCurrentToon()
        
            toon.changeTextureProjectile(restore: false)
            self.gameinfo.loadTimerProjectileTemp()
            self.run(self.gameinfo.mainAudio.getAction(type: .TicTack))

            toon.getNode().run(.sequence([
                .wait(forDuration: 10),.run {
                    toon.changeTextureProjectile(restore: true)
                    self.removeAllActions()
                    self.removeFromParent()
                }

            ]))
            
            
           
            /// Contact with enemy
        case .HitByEnemy:
            // particle effect testing
            
            let hitparticle = SKEmitterNode().contactEnemy(node: lowNode)
          
            self.addChild(hitparticle)
            
            lowNode.removeAllActions()
            lowNode.removeFromParent()
            highNode.removeAllActions()
            prepareToChangeScene(scene: .EndScene)
            
        case .Immune:
            lowNode.destroy()
            
        case .PlayerGetCoin:
            
            self.run(self.gameinfo.mainAudio.getAction(type: .Coin))
            self.gameinfo.addCoin(amount: 1)
            highNode.destroy()
            addLabelAddCoin(sknode: lowNode)
            
        case .None:
            break
        case .HitByDragon:
            print("contacto con dragon")
        }
    }
  
    // MARK: ADD LABEL COIN
    func addLabelAddCoin(sknode:SKSpriteNode) {
        
        let label = SKLabelNode(fontNamed: "Cartwheel", andText: "+1", andSize: 30, withShadow:.black )
        label?.fontColor = .yellow
        label?.position = sknode.position
        addChild(label!)
        label?.run(.sequence([
            .wait(forDuration: 0.5),
            .fadeOut(withDuration: 0.5),
            .run {
                label?.removeFromParent()
            }
        ]))
    }
    
    // MARK: PREPARE SCENE
    func prepareToChangeScene(scene:Scene){
        // remove all gestures
        for gesture in (view?.gestureRecognizers)!{
            view?.removeGestureRecognizer(gesture)
        }
        
        switch scene {
        case .EndScene:
            self.physicsWorld.speed = 0.4
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 4), SKAction.run {
            self.gameinfo.prepareToChangeScene()
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
                
            let scene = EndGame(size: self.size)
                scene.collectedCoins = self.gameinfo.getCurrentGold()
                self.view?.presentScene(scene)
                }]))
        case .Character_Menu:
            
            self.gameinfo.prepareToChangeScene()
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            
            let newScene = CharacterMenuScene(size: self.size)
            self.view?.presentScene(newScene)
        default:
            print("Should not reach here. PrepareToChangeScene from MainScene")
        }
        // switch scene
        
        
    }
}


